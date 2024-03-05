//
//  WBSUtils.h
//  DMBlog
//
//  Created by WebersonGao on 16/7/20.
//  Copyright © 2016年 WebersonGao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+Config.h"
#import "UIImage+Util.h"
#import "UIFont+FontAwesome.h"
#import "NSString+FontAwesome.h"
#import "NSTextAttachment+Util.h"

static NSString * const kKeyYears = @"years";
static NSString * const kKeyMonths = @"months";
static NSString * const kKeyDays = @"days";
static NSString * const kKeyHours = @"hours";
static NSString * const kKeyMinutes = @"minutes";

//这是获取路径时候使用的
typedef enum{
    HomeDirectoryPath = 1,//沙盒路径
    DocumentsPath = 2,//Documents文件的路径
    LibraryPath = 3,//Library文件的路径
    tmpPath = 4,//tem文件的路径
    CachesPath = 5//cash文件的路径
}FilePath;

@interface WBSUtils : NSObject

//  跳转到主界面
+ (void)goToMainViewController;
+ (void)goToLoginViewController;

//获取app的版本
+ (NSString *)getMyApplicationVersion;

/********************* 时间问题 **********************/
//根据字符串获取到NSdate类型的数据
+ (NSDate *)getDateFromString:(NSString *)string;
//根据NSDate类型转换成字符串
+ (NSString *)getStringFromNSDate:(NSDate *)date;

/********************* NSUserDefaults **********************/
+ (void)saveObjectforKey:(id)valuem forKey:(NSString *)key;

+ (void)saveBoolforKey:(BOOL)boo forKey:(NSString *)key;

+ (id)getObjectforKey:(NSString *)key;

+ (BOOL)getBoolforKey:(NSString *)key;

/********************* SVProgressHUD **********************/

+ (void)showSuccessMessage:(NSString *)message;

+ (void)showErrorMessage:(NSString *)message;

+ (void)showStatusMessage:(NSString *)message;

+ (void)showProgressMessage:(NSString *)message;

+ (void)dismissHUDWithDelay:(double)timeInterval;

+ (void)dismissHUD;
/********************* 检测,确认合法性 **********************/
//验证手机号的合法性
+ (BOOL)checkPhoneNumber:(NSString *)phoneNumber;

//检测字符串是不是空的 或者 是空格
+ (BOOL)isBlankString:(NSString *)string;

//随机的颜色
+ (UIColor *)randomColor;

///  判断设备是否联网
+ (BOOL)connectedToNetwork;

/// 获取沙盒内部的路径
+ (NSString *)GetPath:(FilePath)path;

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
 */
+ (NSAttributedString *)attributedCommentCount:(int)commentCount;

/**
 *  显示时间距离现在的信息
 */;
+ (NSAttributedString *)attributedTimeString:(NSDate *)date;

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


/// 网址 账号密码信息校验
+(BOOL)checkUrlString:(NSString *)urlString userNameStr:(NSString *)userNameStr passWord:(NSString *)passWordStr;


@end
