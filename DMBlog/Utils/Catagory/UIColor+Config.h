//
//  UIColor+Util.h
//  DMBlog
//
//  Created by WebersonGao on 16/7/20.
//  Copyright © 2016年 WebersonGao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Config)

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHex:(int)hexValue;

+ (UIColor *)themeColor;
+ (UIColor *)nameColor;
+ (UIColor *)titleColor;
+ (UIColor *)separatorColor;
+ (UIColor *)cellsColor;
+ (UIColor *)titleBarColor;
+ (UIColor *)selectTitleBarColor;
+ (UIColor *)navigationbarColor;
+ (UIColor *)selectCellSColor;
+ (UIColor *)labelTextColor;
+ (UIColor *)teamButtonColor;

+ (UIColor *)infosBackViewColor;
+ (UIColor *)lineColor;

+ (UIColor *)contentTextColor;

@end
