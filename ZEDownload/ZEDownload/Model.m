//
//  Model.m
//  ZEDownload
//
//  Created by 泽i on 2016/10/6.
//  Copyright © 2016年 泽i. All rights reserved.
//

#import "Model.h"

@implementation Model

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

- (void)setState:(ZEState)state {
    _state = state;
    switch (state) {
        case ZEStateNone: {
            self.stateString = @"开始下载";
            break;
        }
        case ZEStateRunning: {
            self.stateString = @"暂停";
            break;
        }
            
        case ZEStateCompleted: {
            self.stateString = @"完成";
            self.speedString = @"";
            break;
        }
            
        case ZEStateWaiting: {
            self.stateString = @"等待";
            self.speedString = @"";
            break;
        }
            
        case ZEStateSuspended: {
            self.stateString = @"继续";
            self.speedString = @"";
            break;
        }
            
        case ZEStateFailed: {
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
