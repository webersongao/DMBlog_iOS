//
//  WBSOptionButton.h
//  DMBlog
//
//  Created by WebersonGao on 16/7/20.
//  Copyright © 2016年 WebersonGao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBSOptionButton : UIView

@property (nonatomic, strong) UIView *button;

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image andColor:(UIColor *)color;

@end
