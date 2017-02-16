//
//  WBSUtils.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSUtils.h"
#import "Reachability.h"
#import "WBSBrowserViewController.h"
#import "WBSBrowserNavViewController.h"
#import "GHMarkdownParser.h"
#import "WBSRootTabBarController.h"
#import "WBSBlogAppDelegate.h"
#import "SVProgressHUD.h"
#import "UIWindow+KeyWindow.h"

@implementation WBSUtils


/**
 *  跳转到主界面
 */
+ (void)goToMainViewController {
    //切换控制器
//    [[UIApplication sharedApplication].keyWindow switchToRootViewController];  //原来的
    [[UIApplication sharedApplication].keyWindow switchToRootTabbarViewController];  //最新的抽屉效果
}

+ (void)goToLoginViewController {
    //切换 登录控制器
    [[UIApplication sharedApplication].keyWindow switchToLoginViewController];  //最新的抽屉效果
}


// 清除用户保存信息
+(void)clearUserInfoValue{

}

#pragma mark 字符串处理
/**
 *  删除字符串中的换行和空白
 *
 *  @param str 原有字符串
 *
 *  @return 处理后的字符串
 */
+(NSString *)removeSpaceAndNewlineAndChars:(NSString *)str
{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"#" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"=" withString:@""];
    temp = [self deleteHTMLTag:temp];
    return temp;
}

/**
 *  截取字符串
 *
 *  @param str    原有字符串
 *  @param length 截取的长度
 *
 *  @return <#return value description#>
 */
+(NSString *)shortString:(NSString *)str andLength:(NSInteger)length{
    NSString *cleanedStr = [WBSUtils removeSpaceAndNewlineAndChars:str];
    if ([cleanedStr length]<length) {
        return cleanedStr;
    }
    return [[cleanedStr substringToIndex:length] stringByAppendingString:@"..."];
}

/**
 *  将评论转换为属性字符串
 *
 *  @param commentCount 原有评论数
 *
 *  @return 处理后的字符串
 */
+ (NSAttributedString *)attributedCommentCount:(int)commentCount
{
    NSString *rawString = [NSString stringWithFormat:@"%@ %d", [NSString fontAwesomeIconStringForEnum:FACommentsO], commentCount];
    NSAttributedString *attributedCommentCount = [[NSAttributedString alloc] initWithString:rawString
                                                                                 attributes:@{
                                                                                              NSFontAttributeName: [UIFont fontAwesomeFontOfSize:12],
                                                                                              }];
    
    return attributedCommentCount;
}

/**
 *  设置标题前面的标志
 *
 *  @param title 原标题
 *
 *  @return 设置标志后的标题
 */
+ (NSMutableAttributedString *)attributedTittle:(NSString *)title
{
    NSMutableAttributedString *attributeString ;
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc]init];
    //转载
    //textAttachment.image = [UIImage imageNamed:@"widget_repost"];
    //原创
    textAttachment.image = [UIImage imageNamed:@"widget-original"];
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    attributeString = [[NSMutableAttributedString alloc] initWithAttributedString:attachmentString];
    [attributeString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    [attributeString appendAttributedString:[[NSAttributedString alloc] initWithString:title]];
    
    return attributeString;
}

#pragma mark - emoji Dictionary

/**
 *  表情字典
 *
 *  @return 表情字典
 */
+ (NSDictionary *)emojiDict
{
    static dispatch_once_t once;
    static NSDictionary *emojiDict;
    
    dispatch_once(&once, ^ {
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:@"emoji" ofType:@"plist"];
        emojiDict = [[NSDictionary alloc] initWithContentsOfFile:path];
    });
    
    return emojiDict;
}

#pragma mark 信息处理

//输入的日期字符串形如：@"1992-05-21 13:08:08"
/**
 *  字符串转换成时间
 *
 *  @param dateString 字符串
 *
 *  @return 时间
 */
+(NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

/**
 * 时间转换成字符串
 *
 *  @param date 时间
 *
 *  @return 字符串
 */
+(NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

/**
 *  返回从现在开始的时间字典
 *
 *  @param date 原有时间
 *
 *  @return 处理后的字典类型
 */
+ (NSDictionary *)timeIntervalArrayFromString:(NSDate *)date
{
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *compsPast =nil;
    NSInteger daysInLastMonth = 0;
    //防止时间转换出错
    @try {
        compsPast = [calendar components:unitFlags fromDate:date];
        daysInLastMonth = [calendar rangeOfUnit:NSCalendarUnitDay
                                         inUnit:NSCalendarUnitMonth
                                        forDate:date].length;
    }
    @catch (NSException *exception) {
        compsPast = [calendar components:unitFlags fromDate:[NSDate date]];
        daysInLastMonth = [calendar rangeOfUnit:NSCalendarUnitDay
                                         inUnit:NSCalendarUnitMonth
                                        forDate:[NSDate date]].length;
    }
    
    NSDateComponents *compsNow = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSInteger years = [compsNow year] - [compsPast year];
    NSInteger months = [compsNow month] - [compsPast month] + years * 12;
    NSInteger days = [compsNow day] - [compsPast day] + months * daysInLastMonth;
    NSInteger hours = [compsNow hour] - [compsPast hour] + days * 24;
    NSInteger minutes = [compsNow minute] - [compsPast minute] + hours * 60;
    
    return @{
             kKeyYears:  @(years),
             kKeyMonths: @(months),
             kKeyDays:   @(days),
             kKeyHours:  @(hours),
             kKeyMinutes:@(minutes)
             };
}


/**
 *  将字符串转换成日期字符串
 *
 *  @param date 原有日期
 *
 *  @return 处理后的字符串
 */
+ (NSAttributedString *)attributedTimeString:(NSDate *)date
{
    NSString *rawString = [NSString stringWithFormat:@"%@ %@", [NSString fontAwesomeIconStringForEnum:FAClockO], [self intervalSinceNow:date]];
    NSAttributedString *attributedTime = [[NSAttributedString alloc] initWithString:rawString
                                                                         attributes:@{
                                                                                      NSFontAttributeName: [UIFont fontAwesomeFontOfSize:12],
                                                                                      }];
    
    return attributedTime;
}

/**
 *  从现在开始的时间
 *
 *  @param date 原有时间
 *
 *  @return 处理后的字符串
 */
+ (NSString *)intervalSinceNow:(NSDate *)date
{
    NSDictionary *dic = [WBSUtils timeIntervalArrayFromString:date];
    //NSInteger years = [[dic objectForKey:kKeyYears] integerValue];
    NSInteger months = [[dic objectForKey:kKeyMonths] integerValue];
    NSInteger days = [[dic objectForKey:kKeyDays] integerValue];
    NSInteger hours = [[dic objectForKey:kKeyHours] integerValue];
    NSInteger minutes = [[dic objectForKey:kKeyMinutes] integerValue];
    
    if (minutes < 1) {
        return @"刚刚";
    } else if (minutes < 60) {
        return [NSString stringWithFormat:@"%ld分钟前", (long)minutes];
    } else if (hours < 24) {
        return [NSString stringWithFormat:@"%ld小时前", (long)hours];
    } else if (hours < 48 && days == 1) {
        return @"昨天";
    } else if (days < 30) {
        return [NSString stringWithFormat:@"%ld天前", (long)days];
    } else if (days < 60) {
        return @"一个月前";
    } else if (months < 12) {
        return [NSString stringWithFormat:@"%ld个月前", (long)months];
    } else {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy年"];
        NSString *msg  = [df stringFromDate:date];
        return msg;
    }
}

#pragma mark HTML处理

/**
 *  加密啊HTML
 *
 *  @param originalHTML 原始HTML
 *
 *  @return 加密后的HTML
 */
+ (NSString *)escapeHTML:(NSString *)originalHTML
{
    if (!originalHTML) {return @"";}
    
    NSMutableString *result = [[NSMutableString alloc] initWithString:originalHTML];
    [result replaceOccurrencesOfString:@"&"  withString:@"&amp;"  options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@"<"  withString:@"&lt;"   options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@">"  withString:@"&gt;"   options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@"\"" withString:@"&quot;" options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@"'"  withString:@"&#39;"  options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    return result;
}

/**
 *  解码HTML
 *
 *  @param originalHTML 原始HTML
 *
 *  @return 解码后的HTML
 */
+ (NSString *)unescapeHTML:(NSString *)originalHTML
{
    if (!originalHTML) {return @"";}
    
    NSMutableString *result = [[NSMutableString alloc] initWithString:originalHTML];
    [result replaceOccurrencesOfString:@"&amp;"  withString:@"&"  options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@"&lt;" withString:@"<"    options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@"&gt;"   withString:@">"  options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@"&#39;"  withString:@"'"  options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    return result;
}

/**
 *  删除HTML标签
 *
 *  @param HTML 原有HTML内容
 *
 *  @return 处理后的HTML
 */
+ (NSString *)deleteHTMLTag:(NSString *)HTML
{
    //修复HTML为空的情况
    if (!HTML) {
        return @"";
    }
    
    NSMutableString *trimmedHTML = [[NSMutableString alloc] initWithString:HTML];
    
    NSString *styleTagPattern = @"<style[^>]*?>[\\s\\S]*?<\\/style>";
    NSRegularExpression *styleTagRe = [NSRegularExpression regularExpressionWithPattern:styleTagPattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *resultsArray = [styleTagRe matchesInString:trimmedHTML options:0 range:NSMakeRange(0, trimmedHTML.length)];
    for (NSTextCheckingResult *match in [resultsArray reverseObjectEnumerator]) {
        [trimmedHTML replaceCharactersInRange:match.range withString:@""];
    }
    
    NSString *htmlTagPattern = @"<[^>]+>";
    NSRegularExpression *normalHTMLTagRe = [NSRegularExpression regularExpressionWithPattern:htmlTagPattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    resultsArray = [normalHTMLTagRe matchesInString:trimmedHTML options:0 range:NSMakeRange(0, trimmedHTML.length)];
    for (NSTextCheckingResult *match in [resultsArray reverseObjectEnumerator]) {
        [trimmedHTML replaceCharactersInRange:match.range withString:@""];
    }
    
    return trimmedHTML;
}

/**
 *  是否是URL
 *
 *  @param string 原字符串
 *
 *  @return 是否为URL
 */
+ (BOOL)isURL:(NSString *)string
{
    NSString *pattern = @"^(http|https)://.*?$(net|com|.com.cn|org|me|)";
    
    NSPredicate *urlPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    
    return [urlPredicate evaluateWithObject:string];
}

#pragma mark 网络
/**
 *  检测网路是否可用
 *
 *  @return 网路状态
 */
+ (NSInteger)networkStatus
{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.webersongao.com"];
    return reachability.currentReachabilityStatus;
}

/**
 *  是否存在网络
 *
 *  @return 网路状态
 */
+ (BOOL)isNetworkExist
{
    return [self networkStatus] > 0;
}

/**
 *  将Markdown字符串转换为html
 *
 *  @param markdownString markdownString
 *
 *  @return htmlString
 */
+(NSString *)markdownToHtml:(NSString *)markdownString{
    GHMarkdownParser *parser = [[GHMarkdownParser alloc] init];
    parser.options = kGHMarkdownAutoLink; // for example
    parser.githubFlavored = YES;
    NSString *htmlString = [parser HTMLStringFromMarkdownString:markdownString];
    return htmlString;
}

#pragma mark WebView

/**
 *  在Webview里面浏览网页
 *
 *  @param target 跳转之前的视图控制器，一般为当前视图控制器
 *  @param url    要浏览的网址
 */
+(void)navigateUrl:(UIViewController *)target withUrl:(NSURL *)url andTitle:(NSString *)pageTitle{
    WBSBrowserNavViewController *browserNavCtl = [[WBSBrowserNavViewController alloc]init];
    browserNavCtl.url = url;
    browserNavCtl.title = pageTitle;
    //添加浏览器视图控制器到当前导航控制器
    WBSBrowserViewController *browserCtl = [[WBSBrowserViewController alloc]initWithURL:url andTitle:pageTitle];
    [browserNavCtl pushViewController:browserCtl animated:YES];
    [target presentViewController:browserNavCtl animated:NO completion:^{
        KLog(@"正在使用WebView打开网页:%@",[url absoluteString]);
    }];
}



/// 网址 账号密码信息校验
+(BOOL)checkUrlString:(NSString *)urlString userNameStr:(NSString *)userNameStr passWord:(NSString *)passWordStr{
    
    if ([urlString isEqualToString:@""]) {
        [WBSUtils showErrorMessage:@"博客API地址不能为空！"];
        return NO;
    }else if([urlString hasPrefix:@"http"]) {
        [WBSUtils showErrorMessage:@"博客地址勿带http"];
        return NO;
    }else if([userNameStr isEqualToString:@""]) {
        [WBSUtils showErrorMessage:@"用户名不能为空！"];
        
        return NO;
    }else if(userNameStr.length < 5 || userNameStr.length > 20) {
        
        [WBSUtils showErrorMessage:@"用户名只能在5-20之间！"];
        return NO;
    }else if([passWordStr isEqualToString:@""]) {
        [WBSUtils showErrorMessage:@"密码不能为空!"];
        return NO;
    }else if(passWordStr.length < 5 || passWordStr.length > 20) {
        [WBSUtils showErrorMessage:@"密码只能在5-20之间!"];
        return NO;
    }else{
        return YES;
    }
}


//获取app的版本
+ (NSString *)getMyApplicationVersion{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [info objectForKey:@"CFBundleShortVersionString"];
    return version;
}

/*********************---NSUserDefaults---******************/
+ (void)saveObjectforKey:(id)valuem forKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:valuem forKey:key];
    [defaults synchronize];
}

+ (void)saveBoolforKey:(BOOL)boo forKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:boo forKey:key];
    [defaults synchronize];
}

+ (id)getObjectforKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}

+ (BOOL)getBoolforKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:key];
}

/*******************--- 时间问题 ---*********************/
//根据字符串获取到NSdate类型的数据
+ (NSDate *)getDateFromString:(NSString *)string{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *date = [formatter dateFromString:string];
    return date;
}

//根据NSDate类型转换成字符串
+ (NSString *)getStringFromNSDate:(NSDate *)date{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *str= [formatter stringFromDate:date];
    return str;
}

/********************* SVProgressHUD **********************/

/// 自动消失
+ (void)showSuccessMessage:(NSString *)message{
    //想设置一些信息可以选择custom类型的 具体看api

    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showSuccessWithStatus:message];
}

/// 自动消失
+ (void)showErrorMessage:(NSString *)message{

    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showErrorWithStatus:message];
}

/// 需要手动 dismiss
+ (void)showStatusMessage:(NSString *)message;{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:message];
}

/// 需要手动 dismiss
+ (void)showProgressMessage:(NSString *) message{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:message];
}

+ (void)dismissHUDWithDelay:(double)timeInterval{
    [SVProgressHUD dismissWithDelay:timeInterval];
}

+ (void)dismissHUD{
    [SVProgressHUD dismiss];
}


/*******************--检测--******************************/
//验证手机合法性
+ (BOOL)checkPhoneNumber:(NSString *)phoneNumber{
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:phoneNumber];
    BOOL res2 = [regextestcm evaluateWithObject:phoneNumber];
    BOOL res3 = [regextestcu evaluateWithObject:phoneNumber];
    BOOL res4 = [regextestct evaluateWithObject:phoneNumber];
    
    if (res1 || res2 || res3 || res4 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//随机颜色
+ (UIColor *)randomColor{
    CGFloat red=arc4random()%256/255.0;
    CGFloat green=arc4random()%256/255.0;
    CGFloat blue=arc4random()%256/255.0;
    UIColor *randomColor=[UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    return randomColor;
}

/// 检测空格是不是空 或者  是空格
+ (BOOL)isBlankString:(NSString *)string{
    
    if (string == nil) {
        return YES;
    }
    
    if (string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

/// 获取沙盒内部的路径
+ (NSString *)GetPath:(FilePath)path{
    
    NSString *homePath = NSHomeDirectory();
    if (path == HomeDirectoryPath) {
        return homePath;
    }else if (path == DocumentsPath){
        return  [homePath stringByAppendingPathComponent:@"Documents"];
    }else if(path == LibraryPath){
        return [homePath stringByAppendingPathComponent:@"Library"];
    }else if (path == CachesPath){
        return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    }else{
        return [homePath stringByAppendingPathComponent:@"tmp"];
    }
}


///  判断设备是否联网
+ (BOOL)connectedToNetwork{
    // 创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_storage zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.ss_len = sizeof(zeroAddress);
    zeroAddress.ss_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    // 获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    // 如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags){
        return NO;
    }
    // 根据获得的连接标志进行判断
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable&&!needsConnection) ? YES : NO;
}

@end




