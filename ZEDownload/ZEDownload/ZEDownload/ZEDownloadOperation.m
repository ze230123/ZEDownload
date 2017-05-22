//
//  ZEDownloadOperation.m
//  ZEDownload
//
//  Created by 泽i on 2016/10/7.
//  Copyright © 2016年 泽i. All rights reserved.
//

#import "ZEDownloadOperation.h"
#import "NSURLSession+CorrectResumData.h"
#import <objc/runtime.h>


#pragma mark- Category
static const void *downloadModelKey = "downloadModelKey";

@implementation NSURLSessionTask (DownloadModel)

- (void)setDownloadModel:(ZEDownloadModel *)downloadModel {
    objc_setAssociatedObject(self, downloadModelKey, downloadModel, OBJC_ASSOCIATION_ASSIGN);
}

- (ZEDownloadModel *)downloadModel {
    return objc_getAssociatedObject(self, downloadModelKey);
}

@end

#pragma mark- ZEDownloadOperation
@interface ZEDownloadOperation()

@property (nonatomic, strong) NSURLSessionDownloadTask *task;
@property (nonatomic, strong) NSMutableURLRequest *request;
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation ZEDownloadOperation

#pragma mark- life cycle
- (instancetype)initWith:(ZEDownloadModel *)model session:(NSURLSession *)session {
    if (self = [super init]) {
        self.model = model;
        self.session = session;
    }
    return self;
}

- (void)dealloc {
    self.task = nil;
    NSLog(@"dealloc %@",self.description);
}
- (void)start {
    // 创建下载任务  根据 resumeData 创建新任务或续传任务
    if (!self.model.resumeData) {
        self.task = [self.session downloadTaskWithRequest:self.request];
    } else {
//        self.task = [self.session downloadTaskWithResumeData:self.model.resumeData];
        self.task = [self.session downloadTaskWithCorrectResumeData:self.model.resumeData];
    }
    
    self.task.downloadModel = self.model;
    /**
     *  开始任务
     */
    [self.task resume];
    [self updateState:ZEOperationRuning];
}

#pragma mark- Public method
- (void)suspend {
    [self updateState:ZEOperationCancelled];
    [self.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        self.model.resumeData = resumeData;
    }];
}

- (void)downloadFinished {
    
    [self updateState:ZEOperationComplete];
}

#pragma mark- Private method
- (void)updateState:(ZEOperationState)state {
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    _state = state;
    [self didChangeValueForKey:@"isFinished"];
    [self didChangeValueForKey:@"isExecuting"];
    
}

#pragma mark- setter and getter
- (NSMutableURLRequest *)request {
    if (_request == nil) {
        _request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.model.downloadUrl]
                                                cachePolicy: NSURLRequestReloadIgnoringLocalCacheData
                                            timeoutInterval:20];
    }
    return _request;
}


- (BOOL)isExecuting {
    
    return self.state == ZEOperationRuning;
}

- (BOOL)isFinished {
    
    return self.state == ZEOperationComplete || self.state == ZEOperationCancelled;
}

@end


