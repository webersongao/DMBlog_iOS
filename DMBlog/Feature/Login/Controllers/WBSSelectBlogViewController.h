//
//  WBSSelectBlogViewController.h
//  DMBlog
//
//  Created by WebersonGao on 16/7/20.
//  Copyright © 2016年 WebersonGao. All rights reserved.
//

#import "DMBaseViewController.h"

typedef void(^ReturnBlock) (NSString *footerUrlStr,NSString *footerApi);

@interface WBSSelectBlogViewController : DMBaseViewController

@property (nonatomic,copy)ReturnBlock returnBlock; // 回调的接口文字

@end
