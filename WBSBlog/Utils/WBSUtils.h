//
//  WBSUtils.h
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+Util.h"
#import "UIView+Util.h"
#import "UIImage+Util.h"
#import "UIFont+FontAwesome.h"
#import "NSString+FontAwesome.h"
#import "MBProgressHUD.h"
#import "NSTextAttachment+Util.h"

static NSString * const kKeyYears = @"years";
static NSString * const kKeyMonths = @"months";
static NSString * const kKeyDays = @"days";
static NSString * const kKeyHours = @"hours";
static NSString * const kKeyMinutes = @"minutes";

@interface WBSUtils : NSObject

/**
 *  表情
 *
 *  @return  表情
 */
+ (NSDictionary *)emojiDict;

/**
 *  去除字符串里面的空格、换行以及Markdown特殊字符，如：＝、＃
 *
 *  @param str 原字符串
 *
 *  @return 处理后的字符串
 */
+(NSString *)removeSpaceAndNewlineAndChars:(NSString *)str;

/**
 *  提取字符串
 *
 *  @param str 原始字符串
 *  @param length  最小长度
 *
 *  @return 提取后的长度
 */
+(NSString *)shortString:(NSString *)str andLength:(NSInteger)length;

/**
 *  美化评论显示
 *
 *  @param commentCount 评论数目
 *
 *  @return 处理后的字符串
 */
+ (NSAttributedString *)attributedCommentCount:(int)commentCount;

/**
 *  显示时间距离现在的信息
 *
 *  @param dateStr 原始时间字符串
 *
 *  @return 处理后的信息
 */;
+ (NSAttributedString *)attributedTimeString:(NSDate *)date;

/**
 *  创建提示框
 *
 *  @return MBProgressHUD
 */
+ (MBProgressHUD *)createHUD;

/**
 *  还原HTMl特殊字符
 *
 *  @param originalHTML originalHTML
 *
 *  @return 还原后的字符
 */
+ (NSString *)unescapeHTML:(NSString *)originalHTML;

/**
 *  在Webview里面浏览网页
 *
 *  @param target 跳转之前的仕途控制器，一般为当前视图控制器
 *  @param url    要浏览的网址
 */
+(void)navigateUrl:(UIViewController *)target withUrl:(NSURL *)url andTitle:(NSString *)pageTitle;

/**
 *  将Markdown字符串转换为html
 *
 *  @param markdownString markdownString
 *
 *  @return htmlString
 */
+(NSString *)markdownToHtml:(NSString *)markdownString;

/**
 *  计算从所给的日期到现在开始间隔的时间
 *
 *  @param date 原始日期
 *
 *  @return 间隔的时间
 */
+ (NSString *)intervalSinceNow:(NSDate *)date;

/**
 *  字符串转换成时间
 *
 *  @param dateString 字符串
 *
 *  @return 时间
 */
+(NSDate *)dateFromString:(NSString *)dateString;

/**
 * 时间转换成字符串
 *
 *  @param date 时间
 *
 *  @return 字符串
 */
+(NSString *)stringFromDate:(NSDate *)date;

/**
 *  设置标题前面的标志
 *
 *  @param title 原标题
 *
 *  @return 设置标志后的标题
 */
+ (NSMutableAttributedString *)attributedTittle:(NSString *)title;

/**
 *  在当前页面展示API不受支持的信息
 *
 *  @param target target
 
 *  @param to     to
 */
+ (void)showApiNotSupported:(UIViewController *)target redirectTo:(UIViewController *)to;

/**
*  跳转到主界面
*/
+ (void)goToMainViewController;
@end
