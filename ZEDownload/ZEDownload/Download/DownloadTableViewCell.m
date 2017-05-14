//
//  DownloadTableViewCell.m
//  ZEDownload
//
//  Created by 泽i on 2017/5/13.
//  Copyright © 2017年 泽i. All rights reserved.
//

#import "DownloadTableViewCell.h"

@implementation DownloadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(Model *)model {
    _model = model;
    
    self.titleLabel.text = model.title;
    [self.button setTitle:model.stateString forState:UIControlStateNormal];
    self.progressView.progress = model.progress;
    if (model.totalSize.length) {
        self.sizeLabel.text = [NSString stringWithFormat:@"%@/%@",model.currentSize,model.totalSize];
    }
    self.speedLabel.text = [NSString stringWithFormat:@"%@",model.speedString];
    NSLog(@"state %ld",model.state);
    self.speedLabel.textColor = model.state == ZEStateFailed ? [UIColor redColor] : [UIColor blackColor];
}
@end
