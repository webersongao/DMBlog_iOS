//
//  TMDElement.m
//  ToMarkdown
//
//  Created by Atsushi Nagase on 11/2/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import "TMDElement.h"

@implementation TMDElement

- (NSArray *)patterns {
  return nil;
}

- (BOOL)isVoid {
  return NO;
}

- (NSString *)replaceText:(NSString *)text {
  __block NSString *mText = [text copy];
  [self.patterns enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSArray *match = nil;
    NSString *fromText = nil;
    NSTextCheckingResult *res = nil;
    do {
      match = [[[[self regexAtIndex:idx]
                 matchesInString:mText options:0 range:NSMakeRange(0, mText.length)] reverseObjectEnumerator] allObjects];
      fromText = [mText copy];
      if([match count] > 0) {
        res = match[0];
        mText = [self replaceText:mText withTextCheckingResult:res];
      }
    } while (![fromText isEqualToString:mText]);
  }];
  return mText;
}

- (NSString *)replaceText:(NSString *)text
   withTextCheckingResult:(NSTextCheckingResult *)result {
  return nil;
}

- (NSRegularExpression *)regexAtIndex:(NSInteger)index {
  NSString *tag = self.patterns[index];
  NSString *strRE = nil;
  if([self isVoid]) {
    strRE = [NSString stringWithFormat:@"<%@\\b([^>]*)\\/?>", tag];
  } else {
    strRE = [NSString stringWithFormat:@"<%@\\b([^>]*)>([\\s\\S]*?)<\\/%@>", tag, tag];
  }
  return [NSRegularExpression
          regularExpressionWithPattern:strRE
          options:NSRegularExpressionCaseInsensitive error:nil];
}

- (NSString *)attributeValueWithText:(NSString *)attrText name:(NSString *)name {
  NSRegularExpression *re =
  [NSRegularExpression
   regularExpressionWithPattern:[NSString stringWithFormat:@"%@\\s*=\\s*[\"']?([^\"']*)[\"']?", name]
   options:NSRegularExpressionCaseInsensitive
   error:nil];
  NSArray *ar = [re matchesInString:attrText options:0 range:NSMakeRange(0, attrText.length)];
  if([ar count] > 0) {
    NSTextCheckingResult *res = ar[0];
    if([res numberOfRanges] > 1)
      return [attrText substringWithRange:[res rangeAtIndex:1]];
  }
  return nil;
}

@end
