//
//  WBSEmojiPanelVC.h
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WBSEmojiPanelVC : UIViewController

- (instancetype)initWithPageIndex:(int)pageIndex;

@property (nonatomic, readonly, assign) int pageIndex;
@property (nonatomic, copy) void (^didSelectEmoji)(NSTextAttachment *textAttachment);
@property (nonatomic, copy) void (^deleteEmoji)();

@end
