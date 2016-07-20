//
//  WBSSideMenuViewController.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSSideMenuViewController.h"
#import "WBSUtils.h"
#import "WBSConfig.h"
#import "WBSLoginNavViewController.h"
#import "WBSLoginViewController.h"
#import "WBSMyInfoController.h"
#import "RESideMenu.h"
#import "WBSPostViewController.h"
#import "WBSSwipableViewController.h"
#import "WBSSettingsPage.h"
#import "AppDelegate.h"

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
    NSArray *usersInformation ;
    UIImage *portrait;
    
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
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = usersInformation[0];
    nameLabel.font = [UIFont boldSystemFontOfSize:20];
    
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:nameLabel];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(portraitView, nameLabel);
    NSDictionary *metrics = @{@"x": @([UIScreen mainScreen].bounds.size.width / 4 - 15)};
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[portraitView(60)]-10-[nameLabel]-15-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-x-[portraitView(60)]" options:0 metrics:metrics views:views]];
    
    portraitView.userInteractionEnabled = YES;
    nameLabel.userInteractionEnabled = YES;
    [portraitView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushLoginPage)]];
    [nameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushLoginPage)]];
    
    return headerView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *selectedBackground = [UIView new];
    selectedBackground.backgroundColor = [UIColor colorWithHex:0xCFCFCF];
    [cell setSelectedBackgroundView:selectedBackground];
    
    cell.imageView.image = [UIImage imageNamed:@[@"sidemenu_blog", @"sidemenu_setting",  @"sidemenu-software"][indexPath.row]];
    cell.textLabel.text = @[@"博客", @"设置",  @"注销"][indexPath.row];
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
            NSLog(@"博客");
            WBSPostViewController *postViewCtl = [[WBSPostViewController alloc]initWithPostType:PostTypePost];
            WBSSwipableViewController *blogSVC = [[WBSSwipableViewController alloc] initWithTitle:@"博客"
                                                                               andSubTitles:nil
                                                                             andControllers:@[ postViewCtl]
                                                                                underTabbar:NO];
            
            [self setContentViewController:blogSVC];
            break;
        }
        case 1: {
            NSLog(@"设置");
            WBSSettingsPage *settingPage = [[WBSSettingsPage alloc]init];
            [self setContentViewController:settingPage];
            break;
        }
        case 2: {//退出
            NSLog(@"退出");
            [self performSelector:@selector(logout:) withObject:nil];
            break;
        }
        default: break;
    }
    
}

- (void)setContentViewController:(UIViewController *)viewController
{
    viewController.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = (UINavigationController *)((UITabBarController *)self.sideMenuViewController.contentViewController).selectedViewController;
    UIViewController *vc = nav.viewControllers[0];
    vc.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [nav pushViewController:viewController animated:NO];
    //隐藏侧边栏
    [self.sideMenuViewController hideMenuViewController];
}


#pragma mark - 点击登录

- (void)pushLoginPage
{
    if (![WBSConfig getAuthoizedApiInfo]) {
        [self setContentViewController:[WBSLoginNavViewController new]];
    } else {
        WBSMyInfoController *myInfoVC = [[WBSMyInfoController alloc]initWithStyle:UITableViewStyleGrouped];
        [self setContentViewController:myInfoVC];
    }
}

#pragma mark 退出
//退出
-(void) logout:(id)sender{
    //清空缓存数据
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:nil forKey:@"baseURL"];
    [def setObject:nil forKey:@"mw_username"];
    [def setObject:nil forKey:@"mw_password"];
    [def setObject:nil forKey:@"generate_auth_cookie"];
    [def synchronize];
    
    MBProgressHUD *HUD = [WBSUtils createHUD];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
    HUD.labelText = @"注销成功";
    [HUD hide:YES afterDelay:0.5];
    
    //跳转到登陆界面
    //NSLog(@"logout");
    WBSLoginViewController *loginController = [[WBSLoginViewController alloc]init];
    WBSLoginNavViewController *login = [[WBSLoginNavViewController alloc] init];
    [login pushViewController:loginController animated:YES];
    AppDelegate * appsDelegate =[[UIApplication sharedApplication] delegate];
    [appsDelegate.window setRootViewController:nil];
    [appsDelegate.window setRootViewController:login];
}
@end
