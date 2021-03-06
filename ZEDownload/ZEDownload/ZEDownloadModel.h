//
//  ZEDownloadModel.h
//  ZEDownload
//
//  Created by 泽i on 2017/5/14.
//  Copyright © 2017年 泽i. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZEDownloadModel;

typedef NS_ENUM(NSInteger, ZEDownloadState) {
    ZEDownloadStateNone = 0,       // 初始状态
    ZEDownloadStateRunning = 1,    // 下载中
    ZEDownloadStateSuspended = 2,  // 下载暂停
    ZEDownloadStateCompleted = 3,  // 下载完成
    ZEDownloadStateFailed  = 4,    // 下载失败
    ZEDownloadStateWaiting = 5    // 等待下载
};


typedef void(^ZEProgressChanged)(ZEDownloadModel *model);
typedef void(^ZEStateChanged)(ZEDownloadModel *model);



@interface ZEDownloadModel : NSObject

/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 下载链接 */
@property (nonatomic, copy) NSString *downloadUrl;
/** 下载速度 */
@property (nonatomic, copy) NSString *speedString;
/** 下载大小 */
@property (nonatomic, copy) NSString *currentSize;
/** 总大小 */
@property (nonatomic, copy) NSString *totalSize;
/** 文件地址 */
@property (nonatomic, copy) NSString *localPath;
/** 下载编号 用于排序 添加到下载管理器之前设置 */
@property (nonatomic, assign) NSInteger downloadNum;
/** 下载进度 0.0 ~ 1.0 */
@property (nonatomic, assign) double progress;
/** 下载状态 */
@property (nonatomic, assign) ZEDownloadState state;
/** 1s 前下载大小  */
@property (nonatomic, assign) int64_t bytesWritten;
/** 下载进度数据 */
@property (nonatomic, strong) NSData *resumeData;
/** 用于计算下载速度的时间 */
@property (nonatomic, strong) NSDate *date;
/** 下载按钮的title 可选设置 */
@property (nonatomic, strong) NSString *stateString;

@property (nonatomic, copy) ZEProgressChanged progressChanged;
@property (nonatomic, copy) ZEStateChanged stateChanged;

- (instancetype)initWtihTitle:(NSString*)title url:(NSString*)url;

@end
