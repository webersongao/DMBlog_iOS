//
//  WBSPostComment.m
//  WBSJsonApi
//
//  Created by WebersonGao on 2017/2/1.
//  Copyright © 2017年 WebersonGao. All rights reserved.
//

#import "WBSCommentModel.h"

@implementation WBSCommentModel

+ (WBSCommentModel *)CommentModelWithDictionary:(NSDictionary *)dictionary
{
    WBSCommentModel *CommentModel = [[WBSCommentModel alloc]init];
    CommentModel.ID = [dictionary[@"id"] integerValue];
    CommentModel.name = dictionary[@"name"];
    CommentModel.url = dictionary[@"url"];
    CommentModel.date = dictionary[@"date"];
    CommentModel.content = dictionary[@"content"];
    CommentModel.parent = [dictionary[@"parent"] integerValue];
    
    return CommentModel;
}

@end
