//
//  WBSSettingViewController.m
//  DMBlog
//
//  Created by WebersonGao on 16/7/20.
//  Copyright © 2016年 WebersonGao. All rights reserved.
//

#import "WBSSettingViewController.h"
#import "SDImageCache.h"
#import "WBSUserProtocolViewController.h"

#define headerHeight  200*KSCREEN_HeightScale
#define headerIconHeight  70

@interface WBSSettingViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *titlesArray;  //!< <#属性注释#>
@end

@implementation WBSSettingViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.titlesArray = @[
                         @[@"公众账号",@"清除缓存"],
                         @[@"是否显示页面",@"JSON API支持",@"针对Wordpress优化"],
                         @[@"关于我们",@"用户协议",@"意见反馈", @"开源许可", @"给应用评分"]
                         ];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.backgroundColor = [UIColor themeColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.showsVerticalScrollIndicator = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titlesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rowArr = self.titlesArray[section];
    return rowArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return headerHeight;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc]init];
    if (section == 0) {
        
        headerView.frame = CGRectMake(0, 0, KSCREEN_Width, headerHeight);
        
        UIImageView *iconimage = [[UIImageView alloc]initWithFrame:CGRectMake((KSCREEN_Width-headerIconHeight)/2, (headerHeight-headerIconHeight)*0.3, headerIconHeight, headerIconHeight)];
        iconimage.image = [UIImage imageNamed:@"Login_Logo"];
        [headerView addSubview:iconimage];
        
        UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, iconimage.bottom +30, KSCREEN_Width-60, 20)];
        versionLabel.text = @"Bokehui 1.0.1 beta";
        versionLabel.textAlignment = NSTextAlignmentCenter;
        versionLabel.font = [UIFont systemFontOfSize:14];
        [headerView addSubview:versionLabel];
        
        return headerView;
    }
    
    return  nil;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    NSInteger section = indexPath.section;
    if (section == 1) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = self.titlesArray[indexPath.section][indexPath.row];
    if (section == 0) {
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 20)];
        textLabel.textAlignment = NSTextAlignmentRight;
        
        if (indexPath.row == 0) {
            textLabel.text = @"博客汇";
        }else {
            float count = [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
            textLabel.text = [NSString stringWithFormat:@"%.1fM",count];
        }
        cell.accessoryView = textLabel;
    }
    if (section == 1) {
        //添加Swich
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        switchView.tag = indexPath.row;
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        
        if (indexPath.row == 0) {
            switchView.on = [def objectForKey:WBSIs_ShowPage];
        }else if(indexPath.row == 1){
            switchView.on = [def objectForKey:WBSIs_JSONAPI];
        }else{
            switchView.on = [def objectForKey:WBSIs_WP_Optimization];
        }
        
        [switchView addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchView;
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section, row = indexPath.row;
    
    switch (section) {
        case 0:
        {
            if (row == 0) {
                // 公众账号
                
            } else if (row == 1){
                // 清除缓存
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定要清除缓存数据？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertView show];
            }
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            if (row == 0) {
                // 关于我们
                
            } else if (row == 1){
                // 用户协议
                WBSUserProtocolViewController *ProtocolVC = [[WBSUserProtocolViewController alloc] init];
                UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:ProtocolVC];
                [self presentViewController:navi animated:YES completion:nil];
            }
            else if (row == 2){
                // 意见反馈
                
            }else if (row == 3){
                // 开源许可
                
            }else{
                //
            }
        }
            break;
            
        default:
            break;
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
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [DMSUtils showSuccessMessage:@"缓存清除成功"];
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
    if(! [[def objectForKey:WBSIs_JSONAPI] boolValue] && sender.tag != 1){
        [DMSUtils showErrorMessage:@"此选项需要JSON API支持"];
        return;
    }
    
    if (sender.on) {
        KLog(@"on:%ld",sender.tag);
        if (sender.tag == 0) {
            [def setObject:@NO forKey:WBSIs_ShowPage];
        }else if(sender.tag == 1){
            [def setObject:@NO forKey:WBSIs_JSONAPI];
        }else{
            [def setObject:@NO forKey:WBSIs_WP_Optimization];
        }
    } else {
        KLog(@"off:%ld",sender.tag);
        if (sender.tag == 0) {
            [def setObject:@YES forKey:WBSIs_ShowPage];
        }else if(sender.tag == 1){
            [def setObject:@YES forKey:WBSIs_JSONAPI];
        }else{
            [def setObject:@YES forKey:WBSIs_WP_Optimization];
        }
    }
    
    [def synchronize];
    
}
@end
