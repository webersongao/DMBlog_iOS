//
//  NSTextAttachment+Util.m
//  DMBlog
//
//  Created by WebersonGao on 16/7/20.
//  Copyright © 2016年 WebersonGao. All rights reserved.
//

#import "NSTextAttachment+Util.h"

@implementation NSTextAttachment (Util)

- (void)adjustY:(CGFloat)y
{
    self.bounds = CGRectMake(0, y, self.image.size.width, self.image.size.height);
}

@end
