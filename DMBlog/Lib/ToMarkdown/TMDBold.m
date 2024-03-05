//
//  TMDBold.m
//  ToMarkdown
//
//  Created by Atsushi Nagase on 11/2/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import "TMDBold.h"

@implementation TMDBold

- (NSArray *)patterns {
  return @[@"b", @"strong"];
}

- (NSString *)replaceText:(NSString *)text
   withTextCheckingResult:(NSTextCheckingResult *)result {
  if([result numberOfRanges] == 3) {
    NSRange range = [result rangeAtIndex:2];
    NSString *value = [text substringWithRange:range];
    return
    [text
     stringByReplacingCharactersInRange:[result rangeAtIndex:0]
     withString:[NSString stringWithFormat:@"**%@**", value]];
  }
  return text;
}

@end
