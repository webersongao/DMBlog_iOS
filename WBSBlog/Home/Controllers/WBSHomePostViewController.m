//
//  WBSHomeViewController.m
//  WBSBlog
//
//  Created by Weberson on 2017/2/13.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import "WBSHomePostViewController.h"
#import "WBSPostTableView.h"


@interface WBSHomePostViewController ()

@property (nonatomic, strong) UITableView *tableView;  //!< 展示文章的tableView
@property (nonatomic, assign) PostViewType postType;  //!< 文章页面类型

@end

@implementation WBSHomePostViewController


/**
 *  根据文章类型初始化
 *
 *  @param type 文章类型
 *
 *  @return 当前对象
 */
- (instancetype)initWithPostType:(PostViewType)type
{
    if (self = [super init]) {
        //设置文章类型，仅仅高级API支持
        _postType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTableViewWithType:self.postType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 设置界面要展示的tableView
-(void)setTableViewWithType:(PostViewType)type{
    switch (type) {
        case PostResultTypeRecent:
        {
            // 博客文章界面
            WBSPostTableView *postTableView = [[WBSPostTableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
            [self.view addSubview:postTableView];
            self.tableView = postTableView;
            
            break;
        }
            
        case PostResultTypeSearch:
        {
            
            break;
        }
            
        case PostResultTypeTag:
        {
            
            break;
        }
            
        case PostResultTypeCategory:
        {
            
            break;
        }
            
        default:
            break;
    }
    
    
    
}


@end










