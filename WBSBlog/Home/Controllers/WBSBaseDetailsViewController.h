//
//  WBSBaseDetailsViewController.h
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSBottomBarViewController.h"

@interface WBSBaseDetailsViewController : WBSBottomBarViewController

/**
 *  详情实体
 */
@property id result;

/**
 *  用post初始化详情页面
 *
 *  @param post 文章
 *
 *  @return 详情页面
 */
- (instancetype)initWithPost:(id)post;

@end
