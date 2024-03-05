//
//  WBSEditingBar.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSEditingBar.h"
#import "WBSAutoScaleTextView.h"
#import "WBSBlogAppDelegate.h"

@interface WBSEditingBar ()

@end

@implementation WBSEditingBar

- (id)initWithModeSwitchButton:(BOOL)hasAModeSwitchButton
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        
        [self addBorder];
        [self setLayoutWithModeSwitchButton:hasAModeSwitchButton];
    }
    
    return self;
}


- (void)setLayoutWithModeSwitchButton:(BOOL)hasAModeSwitchButton
{
    // 左侧切换 输入模式
    _modeSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_modeSwitchButton setImage:[UIImage imageNamed:@"toolbar-barSwitch"] forState:UIControlStateNormal];
    
    // 右侧Emoji表情
    _inputViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_inputViewButton setImage:[UIImage imageNamed:@"toolbar-emoji2"] forState:UIControlStateNormal];
    
    // 中间 文字输入框
    _editView = [[WBSAutoScaleTextView alloc] initWithPlaceholder:@"说点什么"];
    _editView.placeholderFont = [UIFont systemFontOfSize:16];
    _editView.returnKeyType = UIReturnKeySend;
    [_editView setCornerRadius:5.0];
    [_editView setBorderWidth:1.0f andColor:[UIColor colorWithHex:0xC8C8CD]];
    
    ((WBSBlogAppDelegate *)[UIApplication sharedApplication].delegate).inNightMode = [WBSConfig getMode];
    if (((WBSBlogAppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
        self.barTintColor = [UIColor colorWithRed:22.0/255 green:22.0/255 blue:22.0/255 alpha:1.0];
        [_editView setBorderWidth:1.0f andColor:[UIColor colorWithRed:106.0/255 green:106.0/255 blue:106.0/255 alpha:1.0]];
        _modeSwitchButton.backgroundColor = [UIColor clearColor];
        _inputViewButton.backgroundColor = [UIColor clearColor];
        _editView.backgroundColor = [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1.0];
    } else {
        self.barTintColor = [UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1.0];
        _modeSwitchButton.backgroundColor = [UIColor clearColor];
        _inputViewButton.backgroundColor = [UIColor clearColor];
        _editView.backgroundColor = [UIColor colorWithHex:0xF5FAFA];
    }
    _editView.textColor = [UIColor titleColor];
    
    [self addSubview:_editView];
    [self addSubview:_modeSwitchButton];
    [self addSubview:_inputViewButton];
    
    for (UIView *view in self.subviews) {view.translatesAutoresizingMaskIntoConstraints = NO;}
    NSDictionary *views = NSDictionaryOfVariableBindings(_modeSwitchButton, _inputViewButton, _editView);
    
    if (hasAModeSwitchButton) {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-5-[_modeSwitchButton(22)]-5-[_editView]-8-[_inputViewButton(25)]-10-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_modeSwitchButton]|" options:0 metrics:nil views:views]];
    } else {
        [_modeSwitchButton removeFromSuperview];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-5-[_editView]-8-[_inputViewButton(25)]-10-|"
                                                                     options:0 metrics:nil views:views]];
    }
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_inputViewButton]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_editView]-5-|" options:0 metrics:nil views:views]];
}


- (void)addBorder
{
    UIView *upperLineBorder = [[UIView alloc]init];
    upperLineBorder.backgroundColor = [UIColor lightGrayColor];
    upperLineBorder.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:upperLineBorder];
    
    UIView *bottomLineBorder = [[UIView alloc]init];
    bottomLineBorder.backgroundColor = [UIColor lightGrayColor];
    bottomLineBorder.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:bottomLineBorder];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(upperLineBorder, bottomLineBorder);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[upperLineBorder]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[upperLineBorder(0.5)]->=0-[bottomLineBorder(0.5)]|"
                                                                 options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight
                                                                 metrics:nil views:views]];
}




@end
