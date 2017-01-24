//
//  WBSOptionButton.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSOptionButton.h"
#import "UIColor+Config.h"

@interface WBSOptionButton ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *image;

@end

@implementation WBSOptionButton

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image andColor:(UIColor *)color
{
    if (self = [super init]) {
        _button = [UIImageView new];
        _button.backgroundColor = color;
        
        _image = [UIImageView new];
        _image.image = image;
        _image.translatesAutoresizingMaskIntoConstraints = NO;
        [_button addSubview:_image];
        
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor colorWithHex:0x666666];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.text = title;
        
        [self addSubview:_button];
        [self addSubview:_titleLabel];
        
        [self setLayout];
    }
    
    return self;
}

- (void)setLayout
{
    for (UIView *view in self.subviews) {view.translatesAutoresizingMaskIntoConstraints = NO;}
    NSDictionary *views = NSDictionaryOfVariableBindings(_button, _titleLabel, _image);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_button]-8-[_titleLabel]-8-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_button]-8-|" options:0 metrics:nil views:views]];
    [_button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-15-[_image]-15-|" options:0 metrics:nil views:views]];
    [_button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_image]-15-|" options:0 metrics:nil views:views]];
}

@end
