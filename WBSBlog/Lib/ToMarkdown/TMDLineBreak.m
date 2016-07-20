//
//  TMDLineBreak.m
//  ToMarkdown
//
//  Created by Atsushi Nagase on 11/2/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import "TMDLineBreak.h"

@implementation TMDLineBreak

- (BOOL)isVoid {
  return YES;
}

- (NSArray *)patterns {
  return @[@"br"];
}

-(NSString *)replaceText:(NSString *)text withTextCheckingResult:(NSTextCheckingResult *)result {
  if([result numberOfRanges] == 2) {
    NSRange range = [result rangeAtIndex:0];
    return [text stringByReplacingCharactersInRange:range withString:@"  \n"];
  }
  return text;
}

@end
