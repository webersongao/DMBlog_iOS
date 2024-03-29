//
//  CustomAlertView_Runtime.h
//  DMBlog
//
//  Created by WebersonGao on 16/1/11.
//  Copyright (c) 2016年 WebersonGao. All rights reserved.
//

/**
 *  系统提示框的简单封装
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ClickAtIndexBlock)(NSInteger buttonIndex);

@interface CustomAlertView_Runtime : NSObject

+(UIAlertView *)initWithTitle:(NSString*)title message:(NSString *)messge cancleButtonTitle:(NSString *)cancleButtonTitle OtherButtonsArray:(NSArray*)otherButtons clickAtIndex:(ClickAtIndexBlock) clickAtIndex;
@end
