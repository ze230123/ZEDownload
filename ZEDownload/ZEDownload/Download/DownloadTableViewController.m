//
//  DownloadTableViewController.m
//  ZEDownload
//
//  Created by 泽i on 2017/5/13.
//  Copyright © 2017年 泽i. All rights reserved.
//

#import "DownloadTableViewController.h"
#import "DownloadTableViewCell.h"
#import "ZEDownloadManager.h"
#import "ZEDownloadModel.h"

@interface DownloadTableViewController ()

@end

@implementation DownloadTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}
- (void)dealloc {
    NSLog(@"dealloc %@",self.description);
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ZEDownloader.downloadArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DownloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DOWNLOADCELL" forIndexPath:indexPath];
    [cell.button addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    cell.button.tag = 100 + indexPath.row;
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    DownloadTableViewCell *displayCell = (DownloadTableViewCell *)cell;
    ZEDownloadModel *model = ZEDownloader.downloadArr[indexPath.row];
    [displayCell setModel:model];
    
    model.progressChanged = ^(ZEDownloadModel *model) {
        [displayCell setModel:model];
    };
    model.stateChanged = ^(ZEDownloadModel *model) {
        [displayCell setModel:model];
        if (model.state == ZEDownloadStateCompleted) {
            [tableView reloadData];
        }
    };
}

- (void)start:(UIButton *)sender {
    NSInteger index = sender.tag - 100;
    ZEDownloadModel *model = ZEDownloader.downloadArr[index];
    
    switch (model.state) {
        case ZEDownloadStateNone: {
            
            break;
        }
        case ZEDownloadStateRunning: {
            [ZEDownloader suspend:model];
            break;
        }
        case ZEDownloadStateSuspended: {
            [ZEDownloader resume:model];
            break;
        }
        case ZEDownloadStateCompleted: {
            NSLog(@"已下载完成，可以播放了，播放路径：%@", model.localPath);
            break;
        }
        case ZEDownloadStateFailed: {
            [ZEDownloader resume:model];
            break;
        }
        case ZEDownloadStateWaiting: {
            [ZEDownloader suspend:model];
            break;
        }
    }

}

@end
