//
//  NSString+FormatHTML.m
//  WBSJsonApi
//
//  Created by WebersonGao on 2017/2/1.
//  Copyright © 2017年 WebersonGao. All rights reserved.
//

#import "NSString+FormatHTML.h"

@implementation NSString (FormatHTML)

+ (NSString *)stringByStrippingHTML:(NSString *)string {
    NSRange r;
    NSString *s = string;
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

@end
