//
//  WBSUserProtocolViewController.m
//  DMBlog
//
//  Created by WebersonGao on 17/2/7.
//  Copyright © 2016年 WebersonGao. All rights reserved.


#import "WBSUserProtocolViewController.h"

@interface WBSUserProtocolViewController ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation WBSUserProtocolViewController

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_Width, KSCREEN_Height)];
        [(UIScrollView*)[_webView.subviews objectAtIndex:0] setShowsHorizontalScrollIndicator:NO];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scalesPageToFit = YES;
        NSString *path = [[NSBundle mainBundle]pathForResource:@"UserProtocol" ofType:@"html"];
        NSString *dataString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [_webView loadHTMLString:dataString baseURL:nil];
    }
    return _webView;
}
#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"\"博客汇\" 使用协议";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"downback_button"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction)];
    [self.view addSubview:self.webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - events
//导航左侧返回按钮
- (void)rightBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - getters
- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, KSCREEN_Width-10, 100)];
    }
    return _label;
}


- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_Width, KSCREEN_Height - 64)];
        [_scrollView addSubview:self.label];
    }
    return _scrollView;
}



@end
