//
//  DMAppDelegate.h
//  DMBlog
//
//  Created by WebersonGao on 16/7/1.
//  Copyright © 2016年 WebersonGao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
/**
 *  夜间模式
 */
@property (nonatomic, assign) BOOL inNightMode;

@end


