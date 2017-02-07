//
//  WBSGrowingTextView.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSGrowingTextView.h"

@implementation WBSGrowingTextView

- (instancetype)initWithPlaceholder:(NSString *)placeholder
{
    self = [super initWithPlaceholder:placeholder];
    if (self) {
        self.font = [UIFont systemFontOfSize:16];
        self.scrollEnabled = NO;
        self.scrollsToTop = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.enablesReturnKeyAutomatically = YES;
        self.textContainerInset = UIEdgeInsetsMake(7.5, 3.5, 7.5, 0);
        //KLog(@"%@, %f", self.font, self.font.lineHeight);
        _maxNumberOfLines = 4;
        _maxHeight = ceilf(self.font.lineHeight * _maxNumberOfLines + 15 + 4 * (_maxNumberOfLines - 1));
    }
    
    return self;
}

// Code from apple developer forum - @Steve Krulewitz, @Mark Marszal, @Eric Silverberg
- (CGFloat)measureHeight
{
    //[self layoutIfNeeded];
    //KLog(@"frameHeight: %f", self.frame.size.height);
    //KLog(@"lineHeight: %f", self.font.lineHeight);
    //KLog(@"contentSize:(height): %f, (width):%f", self.contentSize.height, self.contentSize.width);
    //KLog(@"Height: %f", [self sizeThatFits:self.frame.size].height + 15);
    
    
    return ceilf([self sizeThatFits:self.frame.size].height + 10);
}


@end
