//
//  WBSPostCell.h
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBSPostCell : UITableViewCell
//文章标题
@property (nonatomic, strong) UILabel *titleLabel;
//文章摘要
@property (nonatomic, strong) UILabel *bodyLabel;
//作者
@property (nonatomic, strong) UILabel *authorLabel;
//发表时间
@property (nonatomic, strong) UILabel *timeLabel;
//评论数
@property (nonatomic, strong) UILabel *commentCount;
//文章分类
@property (nonatomic,strong) UILabel *categories;

@end
