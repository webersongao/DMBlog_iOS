//
//  WBSBrowserViewController.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSBrowserViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "WBSUtils.h"

@interface WBSBrowserViewController ()<UIWebViewDelegate, UIScrollViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIWebView *detailsView;
@property (nonatomic, strong) MBProgressHUD *HUD;

@end

@implementation WBSBrowserViewController

@synthesize url=_url,pageTitle=_pageTitle;

-(instancetype)initWithURL:(NSURL *)url andTitle:(NSString *)pageTitle {
    if (self = [super init]) {
        _url = url;
        _pageTitle = pageTitle ;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnBack)];
    //设置网页标题
    self.navigationItem.title = _pageTitle;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(showShare:)];
    
    NSLog(@"即将访问:%@ 网页标题：%@",_url,_pageTitle);
    
    _detailsView = [[UIWebView alloc]initWithFrame:CGRectMake(0.0f,0.0f,self.view.frame.size.width, self.view.frame.size.height)];
    _detailsView.delegate = self;
    _detailsView.scrollView.delegate = self;
    _detailsView.scrollView.bounces = NO;
    //去除Autoresize
    _detailsView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //下面两行代码可以设置UIWebView的背景
    [_detailsView setBackgroundColor:[UIColor themeColor]];
    [_detailsView setOpaque:NO];
    
    [self.view addSubview:_detailsView];
    
    //加载数据
    [self fetchDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  返回
 */
-(void)returnBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * 使用Safari打开网页
 *
 *  @param sender 当前按钮
 */
-(void)showShare:(id)sender{
    UIAlertController *confirmCtl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否使用Safari打开网页？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:_url]; //调用Safari打开网页
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
    [confirmCtl addAction:yesAction];
    [confirmCtl addAction:noAction];
    [self presentViewController:confirmCtl animated:YES completion:nil];
    NSLog(@"分享：%@",_url);
}


#pragma mark Webview delegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    // 添加等待动画
    _HUD = [WBSUtils createHUD];
    _HUD.detailsLabelText = @"网页加载中";
    _HUD.userInteractionEnabled = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_HUD hide:YES afterDelay:1];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    _HUD.detailsLabelText = @"加载失败";
    _HUD.mode = MBProgressHUDModeCustomView;
    _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
    [_HUD hide:YES afterDelay:1];
}


// 在界面消失的时候隐藏 状态提示
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_HUD hide:YES];
}

#pragma mark 数据加载

/**
 *  访问网页
 */
- (void)fetchDetails
{
    NSLog(@"fetch details");
    NSURLRequest *request =[NSURLRequest requestWithURL:_url];
    [_detailsView loadRequest:request];
}

@end