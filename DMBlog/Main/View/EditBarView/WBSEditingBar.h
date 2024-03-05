//
//  WBSEditingBar.h
//  DMBlog
//
//  Created by WebersonGao on 16/7/20.
//  Copyright © 2016年 WebersonGao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBSAutoScaleTextView.h"

@interface WBSEditingBar : UIToolbar

@property (nonatomic, copy) void (^sendContent)(NSString *content);

@property (nonatomic, strong) WBSAutoScaleTextView *editView;
@property (nonatomic, strong) UIButton *modeSwitchButton;
@property (nonatomic, strong) UIButton *inputViewButton;

- (instancetype)initWithModeSwitchButton:(BOOL)hasAModeSwitchButton;

@end
