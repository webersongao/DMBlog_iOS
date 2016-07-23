//
//  TGComment+SDCommentFromDictionary.h
//  TGBlogJsonApi-Demo
//
//  Created by Peter Foti on 9/4/14.
//  Copyright (c) 2014 Sebastian Dobrincu. All rights reserved.
//

#import "TGComment.h"

@interface TGComment (TGCommentFromDictionary)

+ (TGComment *)SDCommentFromDictionary:(NSDictionary *)dictionary;

@end
