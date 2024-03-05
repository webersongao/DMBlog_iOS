//
//  UIWindow+KeyWindow.h
//  DMBlog
//
//  Created by WebersonGao on 2017/1/23.
//  Copyright © 2017年 WebersonGao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (KeyWindow)

- (void)switchToRootTabbarViewController;

/// 跳转到登录控制器
- (void)switchToLoginViewController;
    
@end
