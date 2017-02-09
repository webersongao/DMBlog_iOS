//
//  WBSCategoryModel.m
//  WBSJsonApi
//
//  Created by Weberson on 2017/2/1.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import "WBSCategoryModel.h"

@implementation WBSCategoryModel

+ (WBSCategoryModel *)CategoryModelWithDictionary:(NSDictionary *)dictionary
{
    WBSCategoryModel *CategoryModel = [[WBSCategoryModel alloc]init];
    
    CategoryModel.ID = [dictionary[@"id"] integerValue];
    CategoryModel.slug = dictionary[@"slug"];
    CategoryModel.title = dictionary[@"title"];
    CategoryModel.categoryDescription = dictionary[@"description"];
    CategoryModel.parent = [dictionary[@"parent"] integerValue];
    CategoryModel.postsCount = [dictionary[@"post_count"] integerValue];
    
    return CategoryModel;
}

@end
