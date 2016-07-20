//
//  UIColor+Util.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "UIColor+Util.h"
#import "AppDelegate.h"

@implementation UIColor (Util)

#pragma mark - Hex

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithHex:(int)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}


#pragma mark - theme colors

+ (UIColor *)themeColor
{
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
        return [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1.0];
    }
    return [UIColor colorWithRed:235.0/255 green:235.0/255 blue:243.0/255 alpha:1.0];
}

+ (UIColor *)nameColor
{
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
        return [UIColor colorWithRed:66.0/255 green:139.0/255 blue:209.0/255 alpha:1.0];
    }
    return [UIColor colorWithHex:0x267dd1];
}

+ (UIColor *)titleColor
{
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
        return [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    }
    return [UIColor blackColor];
}

+ (UIColor *)separatorColor
{
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
        return [UIColor colorWithRed:0.234 green:0.234 blue:0.234 alpha:1.0];
    }
    return [UIColor colorWithRed:217.0/255 green:217.0/255 blue:223.0/255 alpha:1.0];
}

+ (UIColor *)cellsColor
{
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
        return [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1.0];
    }
    return [UIColor whiteColor];
}

+ (UIColor *)titleBarColor
{
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
        return  [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    }
    return [UIColor colorWithHex:0xE1E1E1];
}

+ (UIColor *)contentTextColor
{
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
        return  [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    }
    return [UIColor colorWithHex:0x272727];
}


+ (UIColor *)selectTitleBarColor
{
    
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
        return  [UIColor colorWithRed:0.067 green:0.282 blue:0.094 alpha:1.0];
    }
    return [UIColor colorWithHex:0xE1E1E1];
}

+ (UIColor *)navigationbarColor
{
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
        return [UIColor colorWithRed:0.067 green:0.282 blue:0.094 alpha:1.0];
    }
    return [UIColor colorWithHex:0x428BD1];
}

+ (UIColor *)selectCellSColor
{
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
        return [UIColor colorWithRed:23.0/255 green:23.0/255 blue:23.0/255 alpha:1.0];
    }
    return [UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1.0];
}

+ (UIColor *)labelTextColor
{
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
        return [UIColor colorWithRed:74.0/255 green:74.0/255 blue:74.0/255 alpha:1.0];
    }
    return [UIColor whiteColor];
}

+ (UIColor *)teamButtonColor
{
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
        return [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    }
    return [UIColor colorWithRed:251.0/255 green:251.0/255 blue:253.0/255 alpha:1.0];
}

+ (UIColor *)infosBackViewColor
{
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
        return [UIColor colorWithRed:24.0/255 green:24.0/255 blue:24.0/255 alpha:0.6];
    }
    return [UIColor clearColor];
}

+ (UIColor *)lineColor
{
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
        return [UIColor colorWithRed:18.0/255 green:144.0/255 blue:105.0/255 alpha:0.6];
    }
    return [UIColor colorWithHex:0x237ace];
}

@end
