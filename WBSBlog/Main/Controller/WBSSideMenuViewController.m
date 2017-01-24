//
//  WBSSideMenuViewController.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSSideMenuViewController.h"
#import "WBSLoginNavViewController.h"
#import "WBSLoginViewController.h"
#import "WBSMyInfoController.h"
#import "RESideMenu.h"
#import "WBSHomePostViewController.h"
#import "WBSSwipableViewController.h"
#import "WBSSettingsPage.h"
#import "AppDelegate.h"
#import "WBSScanQRCodeViewController.h"

@interface WBSSideMenuViewController ()

@end

@implementation WBSSideMenuViewController

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
    NSArray *usersInformationArr = [[NSArray alloc]initWithObjects:@"未登录", nil];
    UIImage *portrait = [[UIImage alloc]init];
    
    // 用户头像View
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIImageView *portraitView = [UIImageView new];
    portraitView.contentMode = UIViewContentModeScaleAspectFit;
    [portraitView setCornerRadius:30];
    portraitView.userInteractionEnabled = YES;
    portraitView.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:portraitView];
    
    if (portrait == nil) {
        portraitView.image = [UIImage imageNamed:@"default-portrait"];
    } else {
        portraitView.image = portrait;
    }
    
    /**
     @author Weberson
     昵称名字Label
     */
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = usersInformationArr[0];
    nameLabel.font = [UIFont boldSystemFontOfSize:20];
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:nameLabel];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(portraitView, nameLabel);
    NSDictionary *metrics = @{@"x": @([UIScreen mainScreen].bounds.size.width / 4 - 15)};
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[portraitView(60)]-10-[nameLabel]-15-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-x-[portraitView(60)]" options:0 metrics:metrics views:views]];
    
    portraitView.userInteractionEnabled = YES;
    nameLabel.userInteractionEnabled = YES;
    // 点击图像或者昵称 登录账户
    [portraitView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushLoginPage)]];
    [nameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushLoginPage)]];
    
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
    UITableViewCell *cell = [UITableViewCell new];
    
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *selectedBackgroundView = [UIView new];
    selectedBackgroundView.backgroundColor = [UIColor colorWithHex:0xCFCFCF];
    [cell setSelectedBackgroundView:selectedBackgroundView];
    
    cell.imageView.image = [UIImage imageNamed:@[@"sidemenu_blog", @"sidemenu_setting",  @"sidemenu-software", @"sidemenu_setting"][indexPath.row]];
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
            WBSHomePostViewController *postViewCtl = [[WBSHomePostViewController alloc]initWithPostType:PostTypePost];
            WBSSwipableViewController *blogSVC = [[WBSSwipableViewController alloc] initWithTitle:@"博客" andSubTitles:nil andControllers:@[ postViewCtl]underTabbar:NO];
            
            [self setContentViewController:blogSVC];
            break;
        }
        case 1: {
            KLog(@"设置");
            WBSSettingsPage *settingPage = [[WBSSettingsPage alloc]init];
            [self setContentViewController:settingPage];
            break;
        }
        case 2: {//退出
            KLog(@"退出");
            [self performSelector:@selector(logout:) withObject:nil];
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

- (void)setContentViewController:(UIViewController *)viewController
{
    viewController.hidesBottomBarWhenPushed = YES;
    // 获取导航控制器
    UINavigationController *nav = (UINavigationController *)((UITabBarController *)self.sideMenuViewController.contentViewController).selectedViewController;
        // 获取 导航控制器的第一个控制器
    UIViewController *vc = nav.viewControllers[0];
    vc.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [nav pushViewController:viewController animated:NO];
    //隐藏侧边栏
    [self.sideMenuViewController hideMenuViewController];
}


#pragma mark - 点击登录

- (void)pushLoginPage
{
    if (![WBSConfig getAuthoizedApiInfo]) {
        // 如果 没有登录 跳转到登录控制器
        [self setContentViewController:[WBSLoginNavViewController new]];
    } else {
        // 已经登录  跳转到个人信息界面 XMLRPC接口不支持该功能
        WBSMyInfoController *myInfoVC = [[WBSMyInfoController alloc]initWithStyle:UITableViewStyleGrouped];
        [self setContentViewController:myInfoVC];
    }
}

#pragma mark 退出
//退出
-(void)logout:(id)sender{
    //清空缓存数据
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:nil forKey:WBSSiteBaseURL];
    [def setObject:nil forKey:WBSUserUserName];
    [def setObject:nil forKey:WBSUserPassWord];
    [def setObject:nil forKey:WBSSiteAuthCookie];
    [def synchronize];
    
    [WBSUtils showSuccessMessage:@"注销成功"];
    
    //跳转到登陆界面
    //KLog(@"logout");
    WBSLoginViewController *loginController = [[WBSLoginViewController alloc]init];
    WBSLoginNavViewController *loginNaviVC = [[WBSLoginNavViewController alloc] init];
    [loginNaviVC pushViewController:loginController animated:YES];
    AppDelegate * appsDelegate =[[UIApplication sharedApplication] delegate];
    [appsDelegate.window setRootViewController:nil];
    [appsDelegate.window setRootViewController:loginNaviVC];
}
@end
