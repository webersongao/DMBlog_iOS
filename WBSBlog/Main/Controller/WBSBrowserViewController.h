//
//  WBSBrowserViewController.h
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSBaseViewController.h"

@interface WBSBrowserViewController : WBSBaseViewController

/**
 *  要浏览的URL
 */
@property (nonatomic,strong) NSURL *url;
/**
 *  当前网页标题
 */
@property (nonatomic,strong) NSString *pageTitle;

/**
 *  用指定的URL初始化一个浏览器视图控制器
 *
 *  @param url URL
 
 *  @param title 网页标题
 *
 *  @return 当前视图控制器
 */
-(instancetype)initWithURL:(NSURL *)url andTitle:(NSString *)pageTitle;

@end
