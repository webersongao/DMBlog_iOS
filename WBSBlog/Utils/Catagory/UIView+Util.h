//
//  UIView+Util.h
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Util)

- (void)setCornerRadius:(CGFloat)cornerRadius;
- (void)setBorderWidth:(CGFloat)width andColor:(UIColor *)color;

- (UIImage *)convertViewToImage;
- (UIImage *)updateBlur;

@end
