//
//  TGTag+SDTagFromDictionary.m
//  TGBlogJsonApi-Demo
//
//  Created by Peter Foti on 9/4/14.
//  Copyright (c) 2014 Sebastian Dobrincu. All rights reserved.
//

#import "TGTag+TGTagFromDictionary.h"

@implementation TGTag (TGTagFromDictionary)

+ (TGTag *)SDTagFromDictionary:(NSDictionary *)dictionary
{
    TGTag *newTag = [TGTag new];
    newTag.ID = [dictionary[@"id"] integerValue];
    newTag.slug = dictionary[@"slug"];
    newTag.title = dictionary[@"title"];
    newTag.tagDescription = dictionary[@"description"];
    newTag.postsCount = [dictionary[@"post_count"] integerValue];
    
    return newTag;
}

@end
