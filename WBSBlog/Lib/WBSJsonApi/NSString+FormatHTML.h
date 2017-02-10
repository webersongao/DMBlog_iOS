//
//  NSString+FormatHTML.h
//  WBSJsonApi
//
//  Created by Weberson on 2017/2/1.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FormatHTML)

+ (NSString *)stringByStrippingHTML:(NSString *)string;

@end
