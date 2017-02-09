//
//  WBSTagModel.m
//  WBSJsonApi
//
//  Created by Weberson on 2017/2/1.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import "WBSTagModel.h"

@implementation WBSTagModel

+ (WBSTagModel *)TagModelWithDictionary:(NSDictionary *)dictionary
{
    WBSTagModel *TagModel = [[WBSTagModel alloc]init];
    TagModel.ID = [dictionary[@"id"] integerValue];
    TagModel.slug = dictionary[@"slug"];
    TagModel.title = dictionary[@"title"];
    TagModel.tagDescription = dictionary[@"description"];
    TagModel.postsCount = [dictionary[@"post_count"] integerValue];
    
    return TagModel;
}

@end
