//
//  WBSHomePostViewController.h
//  WBSBlog
//
//  Created by Weberson on 2017/2/13.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import "WBSBasePostViewController.h"

/**
 *  文章结果类型枚举
 */
typedef NS_ENUM(NSUInteger, PostViewType){
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

@interface WBSHomePostViewController : WBSBasePostViewController


@end





