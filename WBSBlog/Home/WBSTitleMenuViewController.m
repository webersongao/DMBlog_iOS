//
//  WBSTitleMenuTableViewController.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSTitleMenuViewController.h"
#import "WBSDropdownMenuView.h"
#import "WBSUtils.h"
#import "AFNetworking.h"
#import "WBSCategoryCell.h"
#import "WBSMacro.h"

static NSString *kCategoryCellID = @"categoryCell";

@interface WBSTitleMenuViewController ()

@property (nonatomic, strong) NSMutableArray * data;

@end

@implementation WBSTitleMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册cell
    [self.tableView registerClass:[WBSCategoryCell class] forCellReuseIdentifier:kCategoryCellID];
    
    [self fetchCategories];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"statusCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    NSString * name = [_data[indexPath.row] objectForKey:@"title"];
    cell.textLabel.text = name;
    
    return cell;
}

#pragma mark Cell点击事件处理器
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_dropdownMenuView) {
        [_dropdownMenuView dismiss];
    }
    
    if (_delegate) {
        [_delegate selectAtIndexPathAndID:indexPath ID:[[_data[indexPath.row] objectForKey:@"id"]  integerValue] title:[_data[indexPath.row] objectForKey:@"title"]];
    }
    
}



# pragma mark 加载分类
/**
 *  加载分类，仅仅JSON API才支持
 */
-(void)fetchCategories{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userDefaults objectForKey:WBSSiteBaseURL];

    NSString *requestURL = [NSString stringWithFormat:@"%@/get_category_index/",baseURL];
    
    //创建加载中
    MBProgressHUD *HUD = [WBSUtils createHUD];
    HUD.detailsLabelText = @"分类加载中...";
    
    NSLog(@"category request URL:%@",requestURL);
    //获取作者数据
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //刷新数据
            //NSLog(@"JSON: %@", responseObject);
            NSLog(@"status:%@",[result objectForKey:@"status"]);
            NSString *status = [result objectForKey:@"status"];
            if ([status isEqualToString:@"ok"]) {
                //获取数据
                NSLog(@"categories get ok :%lu",(unsigned long)result.count);
                
                self.data = [result objectForKey:@"categories"];
                //刷新数据
                [self.tableView reloadData];
                
                //取消加载中
                [HUD hide:YES afterDelay:1];
            }else{
                NSLog(@"category posts get error");
            }
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error fetching authors: %@", [error localizedDescription]);
        MBProgressHUD *HUD = [WBSUtils createHUD];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        HUD.detailsLabelText = [NSString stringWithFormat:@"%@", error.userInfo[NSLocalizedDescriptionKey]];
        
        [HUD hide:YES afterDelay:1];
        
        [self.tableView reloadData];
    }];
}


@end
