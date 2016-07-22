//
//  TGPost+SDPostFromDictionary.h
//  TGBlogJsonApi-Demo
//
//  Created by Peter Foti on 9/4/14.
//  Copyright (c) 2014 Sebastian Dobrincu. All rights reserved.
//

#import "TGPost.h"

@interface TGPost (SDPostFromDictionary)

+ (TGPost *)SDPostFromDictionary:(NSDictionary *)dictionary;

@end
