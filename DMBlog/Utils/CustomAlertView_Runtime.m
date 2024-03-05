//
//  CustomAlertView_Runtime.m
//  DMBlog
//
//  Created by WebersonGao on 16/1/11.
//  Copyright (c) 2016年 WebersonGao. All rights reserved.
//

#import "CustomAlertView_Runtime.h"
#import <objc/runtime.h>


const char *IC_alertView_Block = "IC_alertView_Block";

@interface UIAlertView(CustomAlertView_Runtime)
-(void)setClickBlock:(ClickAtIndexBlock)block;
-(ClickAtIndexBlock)clickBlock;
@end

@implementation UIAlertView(CustomAlertView_Runtime)
-(void)setClickBlock:(ClickAtIndexBlock)block{
    objc_setAssociatedObject(self, IC_alertView_Block, block, OBJC_ASSOCIATION_COPY);
}
-(ClickAtIndexBlock)clickBlock{
    return objc_getAssociatedObject(self, IC_alertView_Block);
}
@end


@implementation CustomAlertView_Runtime
+(UIAlertView *)initWithTitle:(NSString*)title message:(NSString *)messge cancleButtonTitle:(NSString *)cancleButtonTitle OtherButtonsArray:(NSArray*)otherButtons clickAtIndex:(ClickAtIndexBlock) clickAtIndex{
    UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:title message:messge delegate:self cancelButtonTitle:cancleButtonTitle otherButtonTitles: nil];
    alert.clickBlock = clickAtIndex;
    for (NSString *otherTitle in otherButtons) {
        [alert addButtonWithTitle:otherTitle];
    }
    [alert show];
    return alert;
}

#pragma mark -- UIAlertViewDelegate
+(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.clickBlock) {
        alertView.clickBlock(buttonIndex);
    }
}

/*
+(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView.clickBlock) {

        alertView.clickBlock(buttonIndex);
    }
}
 */

@end
