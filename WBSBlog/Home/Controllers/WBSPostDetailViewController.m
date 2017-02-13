//
//  WBSPostDetailViewController.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSPostDetailViewController.h"
#import "WBSPostEditViewController.h"

@interface WBSPostDetailViewController ()

@end

@implementation WBSPostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    KLog(@"This is post detail...");
    
    self.navigationItem.title = @"文章详情";
    self.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(editPost)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


/**
 *  编辑文章
 */
- (void)editPost{
    KLog(@"editing post...");
    WBSPostEditViewController *postEditVC = [[WBSPostEditViewController alloc]init];
    postEditVC.post = super.result;
    [self.navigationController pushViewController:postEditVC animated:NO];
}

@end
