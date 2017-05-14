//
//  ZEDownloadModel.m
//  ZEDownload
//
//  Created by 泽i on 2017/5/14.
//  Copyright © 2017年 泽i. All rights reserved.
//

#import "ZEDownloadModel.h"

@implementation ZEDownloadModel

- (instancetype)initWtihTitle:(NSString *)title url:(NSString *)url {
    if (self = [super init]) {
        self.title = title;
        self.downloadUrl = url;
    }
    return self;
}

- (void)setProgress:(double)progress {
    _progress = progress;
    if (_progressChanged) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _progressChanged(self);
        });
    }
}

- (void)setState:(ZEDownloadState)state {
    _state = state;
    switch (state) {
        case ZEDownloadStateNone: {
            self.stateString = @"开始下载";
            break;
        }
        case ZEDownloadStateRunning: {
            self.stateString = @"暂停";
            break;
        }
            
        case ZEDownloadStateCompleted: {
            self.stateString = @"完成";
            self.speedString = @"";
            break;
        }
            
        case ZEDownloadStateWaiting: {
            self.stateString = @"等待";
            self.speedString = @"";
            break;
        }
            
        case ZEDownloadStateSuspended: {
            self.stateString = @"继续";
            self.speedString = @"";
            break;
        }
            
        case ZEDownloadStateFailed: {
            self.stateString = @"重新开始";
            self.speedString = @"下载失败";
            break;
        }
    }
    if (_stateChanged) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _stateChanged(self);
        });
    }
}


@end
