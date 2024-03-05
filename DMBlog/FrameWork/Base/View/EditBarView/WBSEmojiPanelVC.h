//
//  WBSEmojiPanelVC.h
//  DMBlog
//
//  Created by WebersonGao on 16/7/20.
//  Copyright © 2016年 WebersonGao. All rights reserved.
//

#import "DMBaseViewController.h"

@interface WBSEmojiPanelVC : DMBaseViewController

- (instancetype)initWithPageIndex:(int)pageIndex;

@property (nonatomic, readonly, assign) int pageIndex;
@property (nonatomic, copy) void (^didSelectEmoji)(NSTextAttachment *textAttachment);
@property (nonatomic, copy) void (^deleteEmoji)();

@end
