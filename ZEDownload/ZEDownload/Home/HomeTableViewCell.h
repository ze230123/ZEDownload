//
//  HomeTableViewCell.h
//  ZEDownload
//
//  Created by 泽i on 2017/5/13.
//  Copyright © 2017年 泽i. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface HomeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (nonatomic, strong) Model *model;

@end
