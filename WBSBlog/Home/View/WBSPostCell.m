//
//  WBSPostCell.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSPostCell.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

#define topMarginOfCell 8
#define leftMarginOfCell 10
#define verticalMarginOfCell 8
#define horizontalMarginOfCell 10  // 水平间隔


const int MAX_DESCRIPTION_LENGTH = 60;//描述最多字数
const int MAX_PAGE_SIZE = 10;//每页默认显示文章数目

@interface WBSPostCell ()

//文章配图
@property (nonatomic,strong) UIImageView *thumbImageView;
//文章标题
@property (nonatomic, strong) UILabel *titleLabel;
//文章摘要
@property (nonatomic, strong) UILabel *bodyLabel;
//作者
@property (nonatomic, strong) UILabel *authorLabel;
//发表时间
@property (nonatomic, strong) UILabel *timeLabel;
//评论数
@property (nonatomic, strong) UILabel *commentCountLabel;
//文章分类
@property (nonatomic,strong) UILabel *categoriesLabel;

@end

@implementation WBSPostCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor themeColor];
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [UIColor selectCellSColor];
        [self initSubviews];
        [self setConstraintLayout];
    }
    return self;
}


- (void)initSubviews
{
    self.thumbImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.thumbImageView];
    self.thumbImageView.backgroundColor = [UIColor lightGrayColor];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:self.titleLabel];
    
    self.bodyLabel = [[UILabel alloc]init];
    self.bodyLabel.numberOfLines = 0;
    self.bodyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.bodyLabel.font = [UIFont systemFontOfSize:13];
    self.bodyLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.bodyLabel];
    
    self.authorLabel = [[UILabel alloc]init];
    self.authorLabel.font = [UIFont systemFontOfSize:12];
    self.authorLabel.textColor = [UIColor nameColor];
    [self.contentView addSubview:self.authorLabel];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.timeLabel];
    
    self.commentCountLabel = [[UILabel alloc]init];
    self.commentCountLabel.font = [UIFont systemFontOfSize:12];
    self.commentCountLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.commentCountLabel];
    
    self.categoriesLabel = [[UILabel alloc]init];
    self.categoriesLabel.font = [UIFont systemFontOfSize:12];
    self.categoriesLabel.textColor = [UIColor nameColor];
    [self.contentView addSubview:self.categoriesLabel];
}


/// masonry 布局
- (void)setMyAutoLayout
{
    [self.thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(leftMarginOfCell);
        make.top.equalTo(self.contentView).offset(topMarginOfCell);
        make.right.equalTo(self.contentView).offset(-leftMarginOfCell);
        make.height.equalTo(@40);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.thumbImageView).offset(verticalMarginOfCell);
        make.left.equalTo(self.contentView).offset(leftMarginOfCell);
        make.right.equalTo(self.contentView).offset(-leftMarginOfCell);
    }];
    
    [self.bodyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel).offset(verticalMarginOfCell);
        make.right.equalTo(self.contentView).offset(-leftMarginOfCell);
    }];
    
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel);
        make.top.equalTo(self.bodyLabel).offset(verticalMarginOfCell);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.authorLabel).offset(horizontalMarginOfCell);
        make.top.equalTo(self.authorLabel);
    }];
    
    [self.commentCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.authorLabel);
        make.left.equalTo(self.timeLabel).offset(horizontalMarginOfCell);
    }];
    
    [self.categoriesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.authorLabel);
        make.left.equalTo(self.commentCountLabel).offset(horizontalMarginOfCell);
    }];
    
}

/// 系统 Constraint 布局
- (void)setConstraintLayout
{
    
    for (UIView *view in [self.contentView subviews]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(_titleLabel, _bodyLabel, _authorLabel, _timeLabel, _commentCountLabel,_categoriesLabel);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_titleLabel]-5-[_bodyLabel]" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:viewsDict]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bodyLabel]-5-[_authorLabel]-8-|"
                                                                             options:NSLayoutFormatAlignAllLeft
                                                                             metrics:nil
                                                                               views:viewsDict]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_titleLabel]-8-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewsDict]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_authorLabel]-10-[_timeLabel]-10-[_commentCountLabel]-0-[_categoriesLabel]"
                                                                             options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom
                                                                             metrics:nil
                                                                               views:viewsDict]];
}

/// 赋值数据
-(void)setPostModel:(WBSPostModel *)postModel{
    _postModel = postModel;
    
    //表格数据绑定
    [self.titleLabel setAttributedText:[WBSUtils attributedTittle:postModel.title]];
    [self.bodyLabel setText:[WBSUtils shortString:postModel.content andLength:MAX_DESCRIPTION_LENGTH]];
    //作者处理
    NSString *authorStr = postModel.authorModel.name;
    [self.authorLabel setText:(!authorStr||[authorStr isEqual:@""])?@"admin":authorStr];
    self.titleLabel.textColor = [UIColor titleColor];
    NSDate *createdDate = [WBSUtils dateFromString:postModel.date];
    [self.timeLabel setAttributedText:[WBSUtils attributedTimeString:createdDate]];
    [self.commentCountLabel setAttributedText:[WBSUtils attributedCommentCount:(int)postModel.commentsArray.count]];
    NSArray *categories = postModel.categoriesArray;
    NSString *joinedString = [WBSUtils shortString:[[categories firstObject]title] andLength:15];
    //处理分类为空的情况
    NSString *categoriesString = [NSString stringWithFormat:@"  发布在【%@】",[joinedString isEqualToString: @""]?@"默认分类":joinedString];
    self.categoriesLabel.text =categoriesString;
    
    // 计算cell高度
    [self setCellHeightWithModel:postModel];
    
}




- (void)setCellHeightWithModel:(WBSPostModel *)postModel{
    
    UILabel *tempLabel = [[UILabel alloc]init];
    tempLabel.numberOfLines = 0;
    tempLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tempLabel.font = [UIFont boldSystemFontOfSize:14];
    
    tempLabel.font = [UIFont boldSystemFontOfSize:15];
    [tempLabel setAttributedText:[WBSUtils attributedTittle:postModel.title]];
    CGFloat titleHeight = [tempLabel sizeThatFits:CGSizeMake(self.width - 16, MAXFLOAT)].height;
    
    tempLabel.text = [WBSUtils shortString:postModel.content andLength:MAX_DESCRIPTION_LENGTH];
    tempLabel.font = [UIFont systemFontOfSize:13];
    titleHeight += [tempLabel sizeThatFits:CGSizeMake(self.width - 16, MAXFLOAT)].height;
    
    self.cellHeight = titleHeight +42;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
