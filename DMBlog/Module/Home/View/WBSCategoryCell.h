//
//  WBSCategoryCell.h
//  DMBlog
//
//  Created by WebersonGao on 16/7/20.
//  Copyright © 2016年 WebersonGao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WBSCategoryCell : UITableViewCell
/**
 *  分类名
 */
@property (nonatomic,strong) NSString *title;
/**
 *  分类别名
 */
@property (nonatomic,strong) NSString *slug;
/**
 *  分类ID
 */
@property (nonatomic,assign) NSInteger catId;

@end
