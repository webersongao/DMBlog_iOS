//
//  WBSBasePostViewController.h
//  WBSBlog
//
//  Created by Weberson on 2017/2/13.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import "WBSBaseViewController.h"
#import "WBSPostTableView.h"

@interface WBSBasePostViewController : WBSBaseViewController

@property (nonatomic, strong) UILabel *desLabel; /// 预览文字

@property (nonatomic, strong) WBSPostTableView *tableView;  //!< 展示文章的tableView

@end
