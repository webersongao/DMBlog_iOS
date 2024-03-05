//
//  WBSGrowingTextView.h
//  DMBlog
//
//  Created by WebersonGao on 16/7/20.
//  Copyright © 2016年 WebersonGao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBSPlaceholderTextView.h"

@interface WBSAutoScaleTextView : WBSPlaceholderTextView

@property (nonatomic, assign) NSUInteger maxNumberOfLines;
@property (nonatomic, readonly) CGFloat maxHeight;

- (instancetype)initWithPlaceholder:(NSString *)placeholder;
- (CGFloat)measureHeight;


@end
