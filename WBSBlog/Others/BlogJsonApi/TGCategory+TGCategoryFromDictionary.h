//
//  TGCategory+SDCategoryFromDictionary.h
//  TGBlogJsonApi-Demo
//
//  Created by Peter Foti on 9/4/14.
//  Copyright (c) 2014 Sebastian Dobrincu. All rights reserved.
//

#import "TGCategory.h"

@interface TGCategory (TGCategoryFromDictionary)

+ (TGCategory *)SDCategoryFromDictionary:(NSDictionary *)dictionary;

@end
