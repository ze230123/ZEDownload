//
//  ZEDownloadManager.m
//  ZEDownload
//
//  Created by 泽i on 2016/10/6.
//  Copyright © 2016年 泽i. All rights reserved.
//

#import "ZEDownloadManager.h"
#import "ZEFileUtils.h"

@interface ZEDownloadManager() <NSURLSessionDelegate>
/** 共享的session */
@property (nonatomic, strong) NSURLSession *session;
/** 下载队列 */
@property(strong,nonatomic) NSOperationQueue *downloadQueue;
/** 等待队列 */
@property (nonatomic, strong) NSMutableArray *waitingQueue;
@end

@implementation ZEDownloadManager
#pragma mark- life cycle
+(instancetype)manager {
    
    static ZEDownloadManager *downloadManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloadManager = [[ZEDownloadManager alloc] init];
    });
    return downloadManager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.maxDownloadCount = 1;
        _downloadArr = [NSMutableArray array];
        _completeArr = [NSMutableArray array];
        _waitingQueue = [NSMutableArray array];
    }
    return self;
}
- (void)dealloc {
    NSLog(@"dealloc %@",self.description);
}
#pragma mark- Public method
- (void)addDownLoad:(ZEDownloadModel *)model {
    [_downloadArr addObject:model];
    ZEDownloadOperation *operation = [[ZEDownloadOperation alloc]initWith:model session:self.session];
    [self addDownArrOrWaitingArr:operation];
}

- (void)suspend:(ZEDownloadModel *)model{
    ZEDownloadOperation *operation = [self operatonForModel:model];
    model.state = ZEDownloadStateSuspended;
    [operation suspend];
    //下载队列未达到最大下载数 将operation添加到下载队列 并将自己从等待队列中删除
    if (self.downloadQueue.operations.count < self.maxDownloadCount) {
        [self nextDownload];
    } else if ([self.waitingQueue containsObject:operation]) { //下载队列达到最大下载数  将自己从等待队列中删除
        [self.waitingQueue removeObject:operation];
    }
}

- (void)resume:(ZEDownloadModel *)model {
    ZEDownloadOperation *operation = [self operatonForModel:model];
    [self addDownArrOrWaitingArr:operation];
}

- (BOOL)isExecuted:(ZEDownloadModel *)model {
    return [_downloadArr containsObject:model];
}
#pragma mark- Private method
// 添加operation到 downloadQueue开始下载 或 waitings等待下载
- (void)addDownArrOrWaitingArr:(ZEDownloadOperation *)operation {
    if (self.downloadQueue.operations.count < self.maxDownloadCount) { //下载队列未满
        [self addOperation:operation];
    } else {                                                    //下载队列已满  添加到等待队列 并排序 使下载任务从上往下 进行下载
        operation.model.state = ZEDownloadStateWaiting;
        [self.waitingQueue addObject:operation];
        [self sortWaitingQueue];
    }
}

//对等待队列排序
- (void)sortWaitingQueue {
    [self.waitingQueue sortUsingComparator:^NSComparisonResult(ZEDownloadOperation *obj1, ZEDownloadOperation *obj2) {
        if (obj1.model.downloadNum > obj2.model.downloadNum) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if (obj1.model.downloadNum < obj2.model.downloadNum) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
}

/**
 下一个下载任务
 */
- (void)nextDownload {
    if (self.waitingQueue.count) {
        ZEDownloadOperation *operation = [self.waitingQueue firstObject];
        [self addOperation:operation];
        [self.waitingQueue removeObject:operation];
    }
}
//添加任务的下载队列
- (void)addOperation:(ZEDownloadOperation *)operation {
    [self.downloadQueue addOperation:operation];
    operation.model.state = ZEDownloadStateRunning;
}

/**
 查找operation对象

 @param model 数据模型
 @return operation对象  下载队列和等待队列里都没有 创建一个新的对象
 */
- (ZEDownloadOperation *)operatonForModel:(ZEDownloadModel *)model {
    if ([self findOperationInDownloadQueue:model]) {
        
        return [self findOperationInDownloadQueue:model];
        
    } else if ([self findOperationInWaiting:model]) {
        
        return [self findOperationInWaiting:model];
    }
    return [[ZEDownloadOperation alloc] initWith:model session:self.session];
}
// 在下载队列中查找
- (ZEDownloadOperation *)findOperationInDownloadQueue:(ZEDownloadModel *)model {
    for (ZEDownloadOperation *operation in self.downloadQueue.operations) {
        if (operation.model == model) {
            return operation;
        }
    }
    return nil;
}
// 在等待队列中查找
- (ZEDownloadOperation *)findOperationInWaiting:(ZEDownloadModel *)model {
    for (ZEDownloadOperation *operation in self.waitingQueue) {
        if (operation.model == model) {
            return operation;
        }
    }
    return nil;
}
// 完成的任务移动到 completeArr
- (void)moveToCompleteArr:(ZEDownloadOperation *)operation {
    [_completeArr addObject:operation.model];
    [_downloadArr removeObject:operation.model];
    [operation downloadFinished];
}

#pragma mark- NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {

    NSDate *currentDate = [NSDate date];
    NSTimeInterval interval = [currentDate timeIntervalSinceDate:downloadTask.downloadModel.date];
    if (downloadTask.downloadModel.date == nil || interval >= 1 || totalBytesWritten == totalBytesExpectedToWrite) {
        double progress = (double)totalBytesWritten / totalBytesExpectedToWrite;
        NSString *speedStr = [NSByteCountFormatter stringFromByteCount:totalBytesWritten - downloadTask.downloadModel.bytesWritten
                                                            countStyle:NSByteCountFormatterCountStyleMemory];
        NSString *speedString = [speedStr stringByAppendingString:@"/s"];
        NSString *currentSize = [NSByteCountFormatter stringFromByteCount:totalBytesWritten
                                                               countStyle:NSByteCountFormatterCountStyleMemory];
        NSString *totalSize = [NSByteCountFormatter stringFromByteCount:totalBytesExpectedToWrite
                                                             countStyle:NSByteCountFormatterCountStyleMemory];
        
        downloadTask.downloadModel.bytesWritten = totalBytesWritten;
        downloadTask.downloadModel.speedString = speedString;
        downloadTask.downloadModel.progress = progress;
        downloadTask.downloadModel.currentSize = currentSize;
        downloadTask.downloadModel.totalSize = totalSize;
        downloadTask.downloadModel.date = currentDate;
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    [ZEFileUtils createDirctory:@"Downloads"];
    
    NSString *homePath = [ZEFileUtils getDocuments];
    NSString *fileName = [@"Downloads" stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    NSString *filePath = [homePath stringByAppendingPathComponent:fileName];
    
    if ([ZEFileUtils moveFileAtPath:location.absoluteString toPath:filePath]) {
        downloadTask.downloadModel.localPath = fileName;
        downloadTask.downloadModel.state = ZEDownloadStateCompleted;
    }
    ZEDownloadOperation *operation = [self findOperationInDownloadQueue:downloadTask.downloadModel];
    [self moveToCompleteArr:operation];
    [self nextDownload];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    // code < 0 是发生错误  -999 是task 被取消了  暂且如下处理
    if (error.code < 0 && error.code != -999) {
        NSLog(@"发生错误");
        task.downloadModel.resumeData = error.userInfo[NSURLSessionDownloadTaskResumeData];
        task.downloadModel.state = ZEDownloadStateFailed;
        ZEDownloadOperation *operation = [self findOperationInDownloadQueue:task.downloadModel];
        [operation downloadFinished];
    }
    
}

#pragma mark- getter and setter
- (NSOperationQueue *)downloadQueue {
    if (_downloadQueue == nil) {
        _downloadQueue = [[NSOperationQueue alloc]init];
    }
    return _downloadQueue;
}

- (void)setMaxDownloadCount:(NSInteger)maxDownloadCount {
    _maxDownloadCount = maxDownloadCount;
    self.downloadQueue.maxConcurrentOperationCount = _maxDownloadCount;
}

- (NSURLSession *)session {
    if (_session == nil) {
        /**
         * 创建NSURLSessionConfiguration类的对象, 这个对象被用于创建NSURLSession类的对象.
         */
        NSURLSessionConfiguration *configura = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.background"];
        /**
         * 2. 创建NSURLSession的对象.
         * 参数一 : NSURLSessionConfiguration类的对象.(第1步创建的对象.)
         * 参数二 : session的代理人. 如果为nil, 系统将会提供一个代理人.
         * 参数三 : 一个队列, 代理方法在这个队列中执行. 如果为nil, 系统会自动创建一系列的队列.
         * 注: 只能通过这个方法给session设置代理人, 因为在NSURLSession中delegate属性是只读的.
         */
        _session = [NSURLSession sessionWithConfiguration:configura delegate:self delegateQueue:nil];
    }
    return _session;
}

@end
