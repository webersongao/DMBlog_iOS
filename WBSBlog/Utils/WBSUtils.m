//
//  WBSUtils.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSUtils.h"
#import "Reachability.h"
#import "WBSBrowserNavViewController.h"
#import "WBSBrowserViewController.h"
#import "GHMarkdownParser.h"
#import "WBSErrorViewController.h"
#import "WBSRootTabBarController.h"
#import "RESideMenu.h"
#import "WBSSideMenuViewController.h"
#import "AppDelegate.h"

@implementation WBSUtils


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
    
    NSTextAttachment *textAttachment = [NSTextAttachment new];
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
        daysInLastMonth = [calendar rangeOfUnit:NSDayCalendarUnit
                                         inUnit:NSMonthCalendarUnit
                                        forDate:date].length;
    }
    @catch (NSException *exception) {
        compsPast = [calendar components:unitFlags fromDate:[NSDate date]];
        daysInLastMonth = [calendar rangeOfUnit:NSDayCalendarUnit
                                         inUnit:NSMonthCalendarUnit
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
 *  在Webview里面浏览网页 15-07-29 by terewr
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
        NSLog(@"正在使用WebView打开网页:%@",[url absoluteString]);
    }];
}

#pragma mark 消息提示框
/**
 *  创建弹出框
 *
 *  @return 弹出框实例
 */
+ (MBProgressHUD *)createHUD
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:window];
    HUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    [window addSubview:HUD];
    [HUD show:YES];
    //[HUD addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:HUD action:@selector(hide:)]];
    return HUD;
}

/**
 *  创建弹出框
 *
 *  @return 弹出框实例
 */
+ (MBProgressHUD *)DismissHUD
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:window];
    HUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    [window addSubview:HUD];
    [HUD show:YES];
    //[HUD addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:HUD action:@selector(hide:)]];
    return HUD;
}

/**
 *  在当前页面展示API不受支持的信息
 *
 *  @param target target
 
 *  @param to     to
 */
+ (void)showApiNotSupported:(UIViewController *)target redirectTo:(WBSErrorViewController *)to{
    NSString *errorMessage =  NSLocalizedString(@"APINotSupported", nil);;
    
    MBProgressHUD *HUD = [WBSUtils createHUD];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
    HUD.detailsLabelText = errorMessage;
    [HUD hide:YES afterDelay:1];
    
    UILabel *labelMessage = [[UILabel alloc]init];
    labelMessage.text = errorMessage;
    [target.view addSubview:labelMessage];
    [to.navigationItem setHidesBackButton:YES];
    to.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"首页" style:UIBarButtonItemStylePlain target:to action:@selector(returnHome)];
    to.navigationItem.title = @"出错啦";
    to.errorMessage = errorMessage;
    [target.navigationController pushViewController:to animated:YES];
}


/**
 *  跳转到主界面
 */
+ (void)goToMainViewController {
    WBSRootTabBarController *tabBarController = [[WBSRootTabBarController alloc]init];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    tabBarController.delegate = (id <UITabBarControllerDelegate>) appDelegate;
    
    RESideMenu *sideMenuTabBarViewController = [[RESideMenu alloc] initWithContentViewController:tabBarController                                                                          leftMenuViewController:[WBSSideMenuViewController new]                                                          rightMenuViewController:nil];
    
    //设置样式
    sideMenuTabBarViewController.scaleContentView = YES;
    sideMenuTabBarViewController.contentViewScaleValue = 0.95;
    sideMenuTabBarViewController.scaleMenuView = NO;
    sideMenuTabBarViewController.contentViewShadowEnabled = YES;
    sideMenuTabBarViewController.contentViewShadowRadius = 4.5;
    
    //设置根视图
    appDelegate.window.rootViewController = sideMenuTabBarViewController;
}

@end
