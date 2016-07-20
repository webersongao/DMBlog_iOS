//
//  WBSSettingsPage.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSSettingsPage.h"
#import "WBSUtils.h"
#import "SDImageCache.h"

@interface WBSSettingsPage ()<UIAlertViewDelegate>

@end

@implementation WBSSettingsPage

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.backgroundColor = [UIColor themeColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 1;
        case 1: return 3;
        case 2: return 4;
            
        default: return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    NSInteger section = indexPath.section;
    
    NSArray *titles = @[
                        @[@"清除缓存"],
                        @[@"是否显示页面",@"JSON API支持",@"针对Wordpress优化"],
                        @[@"意见反馈", @"给应用评分", @"关于", @"开源许可"]
                        ];
    
    cell.textLabel.text = titles[indexPath.section][indexPath.row];
    if (section == 1) {
        //添加Swich
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
        switchview.tag = indexPath.row;
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        
        if (indexPath.row == 0) {
            switchview.on = [def objectForKey:@"isShowPage"];
        }else if(indexPath.row == 1){
            switchview.on = [def objectForKey:@"isJSONAPIEnable"];
        }else{
            switchview.on = [def objectForKey:@"isWordpressOptimization"];
        }
        
        [switchview addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchview;
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section, row = indexPath.row;
    
    if (section == 0) {
        if (row == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定要清除缓存的图片和文件？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
            
        } else if (row == 1){
            
        }
    }
}




#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex]) {
        return;
    } else {
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] clearDisk];
        //操作提示
        MBProgressHUD *HUD = [WBSUtils createHUD];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
        HUD.labelText = [NSString stringWithFormat:@"缓存清除成功"];
        [HUD hide:YES afterDelay:1];
    }
}

/**
 *  更新设置
 *
 *  @param sender sender
 */
- (void)updateSwitchAtIndexPath:(UISwitch *)sender {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    //检测设置依赖
    if(! [[def objectForKey:@"isJSONAPIEnable"] boolValue] && sender.tag != 1){
        MBProgressHUD *HUD = [WBSUtils createHUD];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-none"]];
        HUD.labelText = [NSString stringWithFormat:@"此选项需要JSON API支持。"];
        [HUD hide:YES afterDelay:1];
        return;
    }
    
    if (sender.on) {
        NSLog(@"on:%ld",sender.tag);
        if (sender.tag == 0) {
            [def setObject:@NO forKey:@"isShowPage"];
        }else if(sender.tag == 1){
            [def setObject:@NO forKey:@"isJSONAPIEnable"];
        }else{
            [def setObject:@NO forKey:@"isWordpressOptimization"];
        }
    } else {
        NSLog(@"off:%ld",sender.tag);
        if (sender.tag == 0) {
            [def setObject:@YES forKey:@"isShowPage"];
        }else if(sender.tag == 1){
            [def setObject:@YES forKey:@"isJSONAPIEnable"];
        }else{
            [def setObject:@YES forKey:@"isWordpressOptimization"];
        }
    }
    
    [def synchronize];
    
}
@end
