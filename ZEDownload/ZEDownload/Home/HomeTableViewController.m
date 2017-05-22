//
//  HomeTableViewController.m
//  ZEDownload
//
//  Created by 泽i on 2017/5/13.
//  Copyright © 2017年 泽i. All rights reserved.
//

#import "HomeTableViewController.h"
#import "HomeTableViewCell.h"
#import "ZEDownloadModel.h"

#import "ZEDownloadManager.h"
@interface HomeTableViewController ()

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    ZEDownloader.maxDownloadCount = 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"dealloc %@",self.description);
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HOMECELL" forIndexPath:indexPath];
    [cell.button addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
    cell.button.tag = 100 +indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *displayCell = (HomeTableViewCell *)cell;
    ZEDownloadModel *model = self.array[indexPath.row];
    [displayCell setModel:model];
}

- (void)download:(UIButton *)sender {
    NSInteger index = sender.tag - 100;
    ZEDownloadModel *model = self.array[index];
    [sender setBackgroundColor:[UIColor lightGrayColor]];
    if ([ZEDownloader isExecuted:model]) {
        
        NSLog(@"该资源正在下载");
        return;
    }
    model.downloadNum = ZEDownloader.downloadArr.count;
    [ZEDownloader addDownLoad:model];
}


#pragma mark- getter and setter
- (NSMutableArray *)array {
    if (_array == nil) {
        _array = [NSMutableArray array];
        NSArray *urls = [self urls];
        for (int i = 0; i <= urls.count -1; i++) {
            NSString *title = [NSString stringWithFormat:@"我是第%d个任务",i];
            ZEDownloadModel *model = [[ZEDownloadModel alloc]initWtihTitle:title url:urls[i]];
            [_array addObject:model];
        }
    }
    return _array;
}

- (NSArray*)urls {
    return @[@"http://sw.bos.baidu.com/sw-search-sp/software/d2ad2d0b38c/PlantsVsZombiesSetup.zip",
             @"http://dlsw.baidu.com/sw-search-sp/soft/5b/22122/10350318.1329783614.exe",
             @"http://dlsw.baidu.com/sw-search-sp/soft/51/22754/Empires2.1460516577.zip",
             @"http://dlsw.baidu.com/sw-search-sp/soft/34/17728/wj_95_full_1.1.1967712034.exe",
             @"http://dlsw.baidu.com/sw-search-sp/soft/86/21724/WooolMiniClient_2.1.0.40_setup.1456138801.exe"
             ];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
