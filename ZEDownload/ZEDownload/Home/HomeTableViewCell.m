//
//  HomeTableViewCell.m
//  ZEDownload
//
//  Created by 泽i on 2017/5/13.
//  Copyright © 2017年 泽i. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(ZEDownloadModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
}
@end
