//
//  WBSPopoverView.h
//  DMBlog
//
//  Created by WebersonGao on 17/2/18.
//  Copyright © 2016年 WebersonGao. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WBSScaleDirectionType)
{
    WBSScaleDirectionTypeUpLeft,     // 上左
    WBSScaleDirectionTypeUpCenter,   // 上中
    WBSScaleDirectionTypeUpRight,    // 上右
    
    WBSScaleDirectionTypeDownLeft,   // 下左
    WBSScaleDirectionTypeDownCenter, // 下中
    WBSScaleDirectionTypeDownRight,  // 下右
    
    WBSScaleDirectionTypeLeftUp,     // 左上
    WBSScaleDirectionTypeLeftCenter, // 左中
    WBSScaleDirectionTypeLeftDown,   // 左下
    
    WBSScaleDirectionTypeRightUp,    // 右上
    WBSScaleDirectionTypeRightCenter,// 右中
    WBSScaleDirectionTypeRightDown,  // 右下
    
};
@class WBSPopoverView ;

@protocol scaleViewSelectRowDelegate <NSObject>

- (void)scaleView:(WBSPopoverView *  )scaleView didSelectRow:(NSInteger )rowIndex;

@end

@interface WBSPopoverView : UIView

/// backGoundView
@property (nonatomic, strong) UIView  * backGoundView;
/// height  默认是平均值
@property (nonatomic, assign) CGFloat row_height;
/// font  默认 13
@property (nonatomic, assign) CGFloat fontSize;
/// textColor  默认 blackColor
@property (nonatomic, strong) UIColor * titleTextColor;
// delegate
@property (nonatomic, assign) id <scaleViewSelectRowDelegate>  delegate;
/// 初始化方法
- (instancetype)initWithOrigin:(CGPoint)origin Width:(CGFloat)width Height:(CGFloat)height Type:(WBSScaleDirectionType)type Color:(UIColor *)color titleArray:(NSArray *)titleArr imagesArray:(NSArray *)imagesArr superView:(UIView *)superView;

- (void)showScaleView;

- (void)dismissScaleView;

@end










