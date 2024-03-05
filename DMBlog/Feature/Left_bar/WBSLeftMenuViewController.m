//
//  WBSSideMenuViewController.m
//  DMBlog
//
//  Created by WebersonGao on 16/7/20.
//  Copyright © 2016年 WebersonGao. All rights reserved.
//

#import "WBSLeftMenuViewController.h"
#import "WBSUserLoginViewController.h"
#import "WBSUserCenterController.h"
#import "WBSSettingViewController.h"
#import "DMAppDelegate.h"
#import "WBSScanQRCodeViewController.h"
#import "UIViewController+MMDrawerController.h"

@interface WBSLeftMenuViewController ()

@end

@implementation WBSLeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.bounces = NO;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"menu-background(%dx%d)", (int)screenSize.width, (int)screenSize.height]];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:image];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 160;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 用户昵称数组
    NSString *userNickName = @"";
    if ([DMGUICtrl sharedCtrl].isLogin) {
        if ([DMGUICtrl sharedCtrl].user.displayname.length != 0) {
            userNickName = [DMGUICtrl sharedCtrl].user.displayname;
        }else{
            userNickName = [DMGUICtrl sharedCtrl].user.nicename;
        }
    }else if([DMGUICtrl sharedCtrl].isGuest){
        userNickName = @"游客";
    }else{
        userNickName = @"未登录";
    }
    
    // 用户头像View
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIImageView *portraitView = [[UIImageView alloc]init];
    portraitView.contentMode = UIViewContentModeScaleAspectFit;
    [portraitView setCornerRadius:30];
    portraitView.userInteractionEnabled = YES;
    portraitView.translatesAutoresizingMaskIntoConstraints = NO;
    // 头像写死
    portraitView.image = [UIImage imageNamed:@"default_portrait"];
    [headerView addSubview:portraitView];
    
    /**
     @author Weberson
     昵称名字Label
     */
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = userNickName;
    nameLabel.font = [UIFont boldSystemFontOfSize:18];
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:nameLabel];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(portraitView, nameLabel);
    NSDictionary *metrics = @{@"x": @([UIScreen mainScreen].bounds.size.width / 4 - 15)};
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[portraitView(60)]-10-[nameLabel]-15-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-x-[portraitView(60)]" options:0 metrics:metrics views:views]];
    
    portraitView.userInteractionEnabled = YES;
    nameLabel.userInteractionEnabled = YES;
    // 点击图像或者昵称 跳转个人信息界面 或 登录账户
    [portraitView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToUserInfoVC)]];
    [nameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToUserInfoVC)]];
    
    return headerView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *selectedBackgroundView = [[UIView alloc]init];
    selectedBackgroundView.backgroundColor = [UIColor colorWithHex:0xCFCFCF];
    [cell setSelectedBackgroundView:selectedBackgroundView];
    
    cell.imageView.image = [UIImage imageNamed:@[@"sidemenu_log", @"sidemenu_setting",  @"sidemenu-software", @"sidemenu_setting"][indexPath.row]];
    cell.textLabel.text = @[@"博客", @"设置",  @"注销", @"二维码"][indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithHex:0x428bd1];
    //将注销设置成红色
    if (indexPath.row == 2) {
        cell.textLabel.textColor = [UIColor redColor];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:19];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor selectCellSColor];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0: {
            KLog(@"博客");
            [DMSUtils goToMainViewController];
            break;
        }
        case 1: {
            KLog(@"设置");
            WBSSettingViewController *settingVC = [[WBSSettingViewController alloc]init];
            [self setContentViewController:settingVC];
            break;
        }
        case 2: {//注销退出
            KLog(@"退出");
            [self logOutAndCleanUserData];
            break;
        }
        case 3: {//二维码
            KLog(@"二维码");
            WBSScanQRCodeViewController *ScanQRcodeVC = [[WBSScanQRCodeViewController alloc]init];
            [self setContentViewController:ScanQRcodeVC];
            
            break;
        }
        default: break;
    }
    
}


#pragma mark 注销 退出
- (void)logOutAndCleanUserData{
    // 1、清空保存数据
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:nil forKey:WBSSiteBaseURL];
    [def setObject:nil forKey:WBSUserUserName];
    [def setObject:nil forKey:WBSUserPassWord];
    [def setObject:nil forKey:WBSSiteAuthCookie];
    [def setObject:nil forKey:WBSSiteAuthCookieName];
    [def synchronize];
    // 恢复默认配置
    [WBSConfig resetUserConfigToDefault];
    // 修改登录状态
    [DMGUICtrl sharedCtrl].isLogin = NO;
    [DMGUICtrl sharedCtrl].user = nil;
    
    [DMSUtils showSuccessMessage:@"注销成功"];
    
    // 跳转到登录界面
    [DMSUtils goToLoginViewController];
    
}

- (void)setContentViewController:(UIViewController *)viewController
{
    viewController.hidesBottomBarWhenPushed = YES;
    // 获取导航控制器
    UINavigationController *naviVC = [[UINavigationController alloc]initWithRootViewController:viewController];
    naviVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //隐藏侧边栏
    [self.mm_drawerController setCenterViewController:naviVC withCloseAnimation:YES completion:^(BOOL finished) {
        //
    }];
}

-(void)dealloc{
    NSLog(@"WBSLeftMenuViewController is dealloc ");
}


#pragma mark - 点击登录

- (void)pushToUserInfoVC {
    if (![DMGUICtrl sharedCtrl].isLogin && ![DMGUICtrl sharedCtrl].isGuest) {
        // 如果 没有登录 跳转到登录控制器
        [self setContentViewController:[[WBSUserLoginViewController alloc]init]];
    }else if (![WBSConfig isJSONAPIEnable]){
        [DMSUtils showErrorMessage:@"API不支持"];
    }else if ([DMGUICtrl sharedCtrl].isGuest){
        [DMSUtils showErrorMessage:@"游客请登录"];
    }else {
        // json Api已经登录  跳转到个人信息界面 XMLRPC接口不支持该功能
        WBSUserCenterController *userInfoVC = [[WBSUserCenterController alloc]init];
        [self setContentViewController:userInfoVC];
    }
}

@end
