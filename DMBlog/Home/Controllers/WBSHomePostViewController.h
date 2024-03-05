//
//  WBSHomePostViewController.h
//  DMBlog
//
//  Created by WebersonGao on 2017/2/13.
//  Copyright © 2017年 WebersonGao. All rights reserved.
//

#import "WBSBasePostViewController.h"

/**
 *  文章结果类型枚举
 */
typedef NS_ENUM(NSUInteger, PostViewType){
    /**
     *  普通文章
     */
    PostViewTypePost,
    /**
     *  搜索文章
     */
    PostViewTypeSearch,
    /**
     *  分类文章
     */
    PostViewTypeCategory,
    /**
     *  标签文章
     */
    PostViewTypeTag
};

@interface WBSHomePostViewController : WBSBasePostViewController


@end





