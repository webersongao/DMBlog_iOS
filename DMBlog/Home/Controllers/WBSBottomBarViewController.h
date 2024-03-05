//
//  WBSBottomBarViewController.h
//  DMBlog
//
//  Created by WebersonGao on 16/7/20.
//  Copyright © 2016年 WebersonGao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBSEditingBar.h"
#import "WBSOperationBar.h"

@class WBSEmojiPageVC;

@interface WBSBottomBarViewController : UIViewController

@property (nonatomic, strong) WBSEditingBar *editingBar;
@property (nonatomic, strong) WBSOperationBar *operationBar;
@property (nonatomic, strong) NSLayoutConstraint *editingBarYConstraint;
@property (nonatomic, strong) NSLayoutConstraint *editingBarHeightConstraint;

- (instancetype)initWithModeSwitchButton:(BOOL)hasAModeSwitchButton;
- (void)sendContent;
- (void)updateInputBarHeight;
- (void)hideEmojiPageView;

@end
