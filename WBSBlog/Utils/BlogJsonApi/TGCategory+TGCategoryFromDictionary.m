//
//  TGCategory+SDCategoryFromDictionary.m
//  TGBlogJsonApi-Demo
//
//  Created by Peter Foti on 9/4/14.
//  Copyright (c) 2014 Sebastian Dobrincu. All rights reserved.
//

#import "TGCategory+TGCategoryFromDictionary.h"

@implementation TGCategory (TGCategoryFromDictionary)

+ (TGCategory *)SDCategoryFromDictionary:(NSDictionary *)dictionary
{
    TGCategory *newCategory = [TGCategory new];
    
    newCategory.ID = [dictionary[@"id"] integerValue];
    newCategory.slug = dictionary[@"slug"];
    newCategory.title = dictionary[@"title"];
    newCategory.categoryDescription = dictionary[@"description"];
    newCategory.parent = [dictionary[@"parent"] integerValue];
    newCategory.postsCount = [dictionary[@"post_count"] integerValue];
    
    return newCategory;
}

@end
