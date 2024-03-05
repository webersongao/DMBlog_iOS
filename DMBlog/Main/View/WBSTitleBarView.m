//
//  WBSTitleBarView.m
//  DMBlog
//
//  Created by WebersonGao on 16/7/20.
//  Copyright © 2016年 WebersonGao. All rights reserved.
//

#import "WBSTitleBarView.h"
#import "UIColor+Config.h"

@interface WBSTitleBarView ()

@end

@implementation WBSTitleBarView

- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentIndex = 0;
        _titleButtons = [[NSMutableArray alloc]initWithCapacity:1];
        
        CGFloat buttonWidth = frame.size.width / titles.count;
        CGFloat buttonHeight = frame.size.height;
        
        [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor colorWithHex:0xE1E1E1];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:[UIColor colorWithHex:0x909090] forState:UIControlStateNormal];
            [button setTitle:title forState:UIControlStateNormal];
            
            button.frame = CGRectMake(buttonWidth * idx, 0, buttonWidth, buttonHeight);
            button.tag = idx;
            [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [_titleButtons addObject:button];
            [self addSubview:button];
            [self sendSubviewToBack:button];
        }];
      
        self.contentSize = CGSizeMake(frame.size.width, 25);
        self.showsHorizontalScrollIndicator = NO;
        UIButton *firstTitle = _titleButtons[0];
        [firstTitle setTitleColor:[UIColor colorWithHex:0x428BD1] forState:UIControlStateNormal];
        firstTitle.transform = CGAffineTransformMakeScale(1.15, 1.15);
        
    }
    return self;
}


- (void)onClick:(UIButton *)button
{
    if (_currentIndex != button.tag) {
        UIButton *preTitle = _titleButtons[_currentIndex];
        
        [preTitle setTitleColor:[UIColor colorWithHex:0x909090] forState:UIControlStateNormal];
        preTitle.transform = CGAffineTransformIdentity;
        
        [button setTitleColor:[UIColor colorWithHex:0x428bd1] forState:UIControlStateNormal];
        button.transform = CGAffineTransformMakeScale(1.2, 1.2);
        
        _currentIndex = button.tag;
        _titleButtonClicked(button.tag);
    }
}

@end
