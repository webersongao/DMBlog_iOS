//
//  WBSPlaceholderTextView.m
//  DMBlog
//
//  Created by WebersonGao on 16/7/20.
//  Copyright © 2016年 WebersonGao. All rights reserved.
//

#import "WBSPlaceholderTextView.h"
#import "DMAppDelegate.h"

@interface WBSPlaceholderTextView ()

@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation WBSPlaceholderTextView

- (instancetype)initWithPlaceholder:(NSString *)placeholder
{
    self = [super init];
    if (self) {
        [self setUpPlaceholderLabel:placeholder];
        ((DMAppDelegate *)[UIApplication sharedApplication].delegate).inNightMode = [WBSConfig getMode];
        if (((DMAppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
            self.keyboardAppearance = UIKeyboardAppearanceDark;
        } else {
            self.keyboardAppearance = UIKeyboardAppearanceLight;
        }
    }
    
    return self;
}

- (void)setUpPlaceholderLabel:(NSString *)placeholder
{
    _placeholderLabel = [[UILabel alloc]init];
    _placeholderLabel.textColor = [UIColor lightGrayColor];
    _placeholderLabel.backgroundColor = [UIColor clearColor];
    _placeholderLabel.text = placeholder;
    [self addSubview:_placeholderLabel];
    
    _placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(_placeholderLabel);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_placeholderLabel]-6-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[_placeholderLabel]"   options:0 metrics:nil views:views]];
}


- (void)checkShouldHidePlaceholder
{
    _placeholderLabel.hidden = [self hasText];
}


#pragma mark - property accessor
#pragma mark placeholder

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholderLabel.text = placeholder;
}

- (NSString *)placeholder
{
    return _placeholderLabel.text;
}

#pragma mark placeholderFont

- (void)setPlaceholderFont:(UIFont *)placeholderFont
{
    _placeholderLabel.font = placeholderFont;
}

- (UIFont *)placeholderFont
{
    return _placeholderLabel.font;
}




@end
