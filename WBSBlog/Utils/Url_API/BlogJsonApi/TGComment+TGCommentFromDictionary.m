//
//  TGComment+SDCommentFromDictionary.m
//  TGBlogJsonApi-Demo
//
//  Created by Peter Foti on 9/4/14.
//  Copyright (c) 2014 Sebastian Dobrincu. All rights reserved.
//

#import "TGComment+TGCommentFromDictionary.h"

@implementation TGComment (TGCommentFromDictionary)

+ (TGComment *)SDCommentFromDictionary:(NSDictionary *)dictionary
{
    TGComment *newComment = [TGComment new];
    newComment.ID = [dictionary[@"id"] integerValue];
    newComment.name = dictionary[@"name"];
    newComment.url = dictionary[@"url"];
    newComment.date = dictionary[@"date"];
    newComment.content = dictionary[@"content"];
    newComment.parent = [dictionary[@"parent"] integerValue];
    
    return newComment;
}

@end
