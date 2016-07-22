//
//  WBSBottomBarViewController.h
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
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
