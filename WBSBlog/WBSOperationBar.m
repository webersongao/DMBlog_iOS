//
//  WBSOperationBar.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSOperationBar.h"
#import "WBSBlogAppDelegate.h"

@implementation WBSOperationBar

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        
        [self setLayout];
        [self addBorder];
    }
    
    return self;
}


- (void)setLayout
{
    NSMutableArray *items = [[NSMutableArray alloc]init];
    NSArray *images    = @[@"toolbar-keyboardUp", @"toolbar-separatorline", @"toolbar-comments", @"toolbar-editingComment", @"toolbar-star", @"toolbar-share", @"toolbar-report"];
    NSArray *selectors = @[@"switchMode:", @"", @"showComments:", @"editComment:", @"toggleStar:", @"share:", @"report:"];
    
    [images enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL *stop) {
        UIImage *image = [UIImage imageNamed:imageName];
        if (idx != 1) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:NSSelectorFromString(selectors[idx]) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
            [button setBackgroundImage:image forState:UIControlStateNormal];
            
            UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
            
            ((WBSBlogAppDelegate *)[UIApplication sharedApplication].delegate).inNightMode = [WBSConfig getMode];
            if (((WBSBlogAppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
                self.barTintColor = [UIColor colorWithRed:22.0/255 green:22.0/255 blue:22.0/255 alpha:1.0];
                barButton.tintColor = [UIColor clearColor];
            } else {
                self.barTintColor = [UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1.0];
                barButton.tintColor = [UIColor clearColor];
            }
            
            [items addObject:barButton];
        } else {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:imageView];
            [items addObject:barButton];
        }
        
        if (idx == 0) {
            UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            fixedSpace.width = 5;
            [items addObject:fixedSpace];
        } else {
            [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
        }

    }];
    
    [self setItems:items];
}

- (void)setIsStarred:(BOOL)isStarred
{
    UIBarButtonItem *starBarButton = self.items[8];
    UIButton *starButton = (UIButton *)starBarButton.customView;
    
    if (isStarred) {
        [starButton setImage:[UIImage imageNamed:@"toolbar-starred"] forState:UIControlStateNormal];
    } else {
        [starButton setImage:[UIImage imageNamed:@"toolbar-star"] forState:UIControlStateNormal];
    }
    
    _isStarred = isStarred;
}


- (void)switchMode:(id)sender
{
    if (_switchMode) {_switchMode();}
}

- (void)showComments:(id)sender
{
    if (_showComments) {_showComments();}
}

- (void)editComment:(id)sender
{
    if (_editComment) {_editComment();}
}

- (void)toggleStar:(id)sender
{
    if (_toggleStar) {_toggleStar();}
}

- (void)share:(id)sender
{
    if (_share) {_share();}
}

- (void)report:(id)sender
{
    if (_report) {_report();}
}


- (void)addBorder
{
    UIView *upperBorder = [[UIView alloc]init];
    upperBorder.backgroundColor = [UIColor lightGrayColor];
    upperBorder.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:upperBorder];
    
    UIView *bottomBorder = [[UIView alloc]init];
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
