//
//  WBSOldHomePostViewController.h
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBSOldBasePostViewController.h"

/**
 *  文章类型枚举
 */
typedef NS_ENUM(NSUInteger, PostVCType){
    /**
     *  文章
     */
    PostTypePost,
    /**
     *  页面
     */
    PostTypePage,
};


/**
 *  API 类型枚举 15-08-04 by weberson
 */
typedef NS_ENUM(NSInteger,APIType){
    /**
     *  JSON API
     */
    APITypeJSON,
    /**
     *  XMLRPC API
     */
    APITypeXMLRPC,
    /**
     *  Http API
     */
    APITypeHttp
};


/**
 *  文章结果类型枚举
 */
typedef NS_ENUM(NSUInteger, PostResultType){
    /**
     *  最近文章
     */
    PostResultTypeRecent,
    /**
     *  搜索文章
     */
    PostResultTypeSearch,
    /**
     *  分类文章
     */
    PostResultTypeCategory,
    /**
     *  标签文章
     */
    PostResultTypeTag
};

@interface WBSOldHomePostViewController : WBSOldBasePostViewController

/**
 *  API类型
 */
@property (nonatomic,assign) APIType apiType;
/**
 *  文章类型
 */
@property (nonatomic,assign) PostVCType postType;
/**
 *  文章结果类型
 */
@property (nonatomic,assign) PostResultType postResultType;
/**
 *  文章列表数据
 */
@property (nonatomic,strong) NSArray *posts;
/**
 *  是否搜索
 */
@property (nonatomic,assign)  BOOL isSearch;
/**
 *  搜索框
 */
@property (nonatomic,strong)  UISearchBar *searchBar;
/**
 *  搜索关键字
 */
@property (nonatomic,strong) NSString *searchString;
/**
 *  分类Id
 */
@property (nonatomic,assign) NSInteger categoryId;
/**
 *  标签ID
 */
@property (nonatomic,assign)  NSInteger tagId;
/**
 *  文章搜索控制器
 */
@property  (nonatomic,strong) UISearchController *postSearchController;
/**
 *  下拉分类
 */
@property (nonatomic, strong) UIButton *titleButton;
/**
 *  根据文章类型初始化
 *
 *  @param type 文章类型
 *
 *  @return 当前对象
 */
- (instancetype)initWithPostType:(PostVCType)type;

@end
