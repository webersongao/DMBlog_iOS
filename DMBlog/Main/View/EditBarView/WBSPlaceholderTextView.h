//
//  WBSPlaceholderTextView.h
//  DMBlog
//
//  Created by WebersonGao on 16/7/20.
//  Copyright © 2016年 WebersonGao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBSPlaceholderTextView : UITextView

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIFont   *placeholderFont;

- (instancetype)initWithPlaceholder:(NSString *)placeholder;
- (void)checkShouldHidePlaceholder;

@end
