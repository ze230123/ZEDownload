//
//  ZEDownloadOperation.h
//  ZEDownload
//
//  Created by 泽i on 2016/10/7.
//  Copyright © 2016年 泽i. All rights reserved.
//
/**
 *  无参数block
 */

#import <Foundation/Foundation.h>
#import "ZEDownloadModel.h"



/**
 为NSURLSessionTask 添加一个下载的数据模型 方便在NSURLSessionDelegate 中获取到数据模型
 */
@interface NSURLSessionTask (DownloadModel)

// 为了更方便去获取，而不需要遍历，采用扩展的方式，可直接提取，提高效率
@property (nonatomic, weak) ZEDownloadModel *downloadModel;

@end



typedef NS_OPTIONS(NSInteger,ZEOperationState) {
    ZEOperationRuning = 0,
    ZEOperationCancelled = 1,
    ZEOperationComplete = 2,
};

/**
 下载任务 继承NSOperation 使用NSOperationQueue管理
 */
@interface ZEDownloadOperation : NSOperation

@property (nonatomic, strong) ZEDownloadModel *model;
/** 任务状态 */
@property (nonatomic, assign, readonly) ZEOperationState state;

- (instancetype)initWith:(ZEDownloadModel *)model session:(NSURLSession *)session;

/**
 暂停下载
 */
- (void)suspend;

/**
 完成下载
 */
- (void)downloadFinished;

@end
