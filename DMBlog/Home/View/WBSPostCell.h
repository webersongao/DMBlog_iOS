//
//  WBSPostCell.h
//  DMBlog
//
//  Created by WebersonGao on 16/7/20.
//  Copyright © 2016年 WebersonGao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBSPostModel.h"

@interface WBSPostCell : UITableViewCell

@property (nonatomic, strong) WBSPostModel *postModel;  //!< 单条数据

@property (nonatomic, assign) CGFloat cellHeight;  //!< cell高度

@end
