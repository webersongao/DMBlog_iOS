//
//  WBSEditingBar.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSEditingBar.h"
#import "WBSGrowingTextView.h"
#import "WBSUtils.h"
#import "WBSConfig.h"
#import "AppDelegate.h"

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
    _modeSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_modeSwitchButton setImage:[UIImage imageNamed:@"toolbar-barSwitch"] forState:UIControlStateNormal];
    
    _inputViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_inputViewButton setImage:[UIImage imageNamed:@"toolbar-emoji2"] forState:UIControlStateNormal];
    
    _editView = [[WBSGrowingTextView alloc] initWithPlaceholder:@"说点什么"];
    _editView.placeholderFont = [UIFont systemFontOfSize:16];
    _editView.returnKeyType = UIReturnKeySend;
    [_editView setCornerRadius:5.0];
    [_editView setBorderWidth:1.0f andColor:[UIColor colorWithHex:0xC8C8CD]];
    
    ((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode = [WBSConfig getMode];
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
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
    UIView *upperBorder = [UIView new];
    upperBorder.backgroundColor = [UIColor lightGrayColor];
    upperBorder.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:upperBorder];
    
    UIView *bottomBorder = [UIView new];
    bottomBorder.backgroundColor = [UIColor lightGrayColor];
    bottomBorder.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:bottomBorder];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(upperBorder, bottomBorder);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[upperBorder]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[upperBorder(0.5)]->=0-[bottomBorder(0.5)]|"
                                                                 options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight
                                                                 metrics:nil views:views]];
}




@end
