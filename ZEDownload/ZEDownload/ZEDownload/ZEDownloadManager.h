//
//  ZEDownloadManager.h
//  ZEDownload
//
//  Created by 泽i on 2016/10/6.
//  Copyright © 2016年 泽i. All rights reserved.
//

#define ZEDownloader [ZEDownloadManager manager]

#import <Foundation/Foundation.h>
#import "ZEDownloadOperation.h"

/**
 下载任务管理器
 */
@interface ZEDownloadManager : NSObject {
    NSMutableArray *_downloadArr;
    NSMutableArray *_completeArr;
}
/** 最大下载数 默认 1 */
@property (nonatomic, assign) NSInteger maxDownloadCount;
/** 所有下载任务 */
@property (nonatomic, strong, readonly) NSArray *downloadArr;

@property (nonatomic, strong, readonly) NSArray *completeArr;

/**
 获取单例对象

 @return 实例对象
 */
+(instancetype)manager;

/**
 添加到下载管理器中 开始或等待下载

 @param model 数据模型
 */
- (void)addDownLoad:(Model *)model;

/**
 暂停

 @param model 数据模型
 */
- (void)suspend:(Model *)model;

/**
 开始 或 继续

 @param model 数据模型
 */
- (void)resume:(Model *)model;

/**
 是否在下载队列中
 */
- (BOOL)isExecuted:(Model *)model;

@end
