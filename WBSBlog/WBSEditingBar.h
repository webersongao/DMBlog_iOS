//
//  WBSEditingBar.h
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBSGrowingTextView.h"

@interface WBSEditingBar : UIToolbar

@property (nonatomic, copy) void (^sendContent)(NSString *content);

@property (nonatomic, strong) WBSGrowingTextView *editView;
@property (nonatomic, strong) UIButton *modeSwitchButton;
@property (nonatomic, strong) UIButton *inputViewButton;

- (instancetype)initWithModeSwitchButton:(BOOL)hasAModeSwitchButton;

@end
