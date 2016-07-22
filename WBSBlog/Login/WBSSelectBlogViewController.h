//
//  WBSSelectBlogViewController.h
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReturnBlock) (NSString *footerUrlStr,NSString *footerApi);

@interface WBSSelectBlogViewController : UIViewController

@property (nonatomic,copy)ReturnBlock returnBlock; // 回调的接口文字

@end
