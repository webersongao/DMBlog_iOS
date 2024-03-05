//
//  TMDHorizontalRule.m
//  ToMarkdown
//
//  Created by Atsushi Nagase on 11/2/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import "TMDHorizontalRule.h"

@implementation TMDHorizontalRule

- (BOOL)isVoid {
  return YES;
}

- (NSArray *)patterns {
  return @[@"hr"];
}

-(NSString *)replaceText:(NSString *)text withTextCheckingResult:(NSTextCheckingResult *)result {
  if([result numberOfRanges] == 2) {
    NSRange range = [result rangeAtIndex:0];
    return [text stringByReplacingCharactersInRange:range withString:@"\n\n* * *\n"];
  }
  return text;
}

@end
