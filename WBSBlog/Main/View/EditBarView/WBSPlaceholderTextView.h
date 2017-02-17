//
//  WBSPlaceholderTextView.h
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBSPlaceholderTextView : UITextView

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIFont   *placeholderFont;

- (instancetype)initWithPlaceholder:(NSString *)placeholder;
- (void)checkShouldHidePlaceholder;

@end
