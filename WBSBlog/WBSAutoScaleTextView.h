//
//  WBSGrowingTextView.h
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBSPlaceholderTextView.h"

@interface WBSGrowingTextView : WBSPlaceholderTextView

@property (nonatomic, assign) NSUInteger maxNumberOfLines;
@property (nonatomic, readonly) CGFloat maxHeight;

- (instancetype)initWithPlaceholder:(NSString *)placeholder;
- (CGFloat)measureHeight;


@end
