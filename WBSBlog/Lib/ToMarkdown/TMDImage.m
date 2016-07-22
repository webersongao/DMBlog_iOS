
  //
//  TMDImage.m
//  ToMarkdown
//
//  Created by Atsushi Nagase on 11/2/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import "TMDImage.h"

@implementation TMDImage

- (BOOL)isVoid {
  return YES;
}

- (NSArray *)patterns {
  return @[@"img"];
}

-(NSString *)replaceText:(NSString *)text withTextCheckingResult:(NSTextCheckingResult *)result {
  if([result numberOfRanges] == 2) {
    NSRange range = [result rangeAtIndex:0];
    NSString *attrs = [text substringWithRange:range];
    NSString *src  = [self attributeValueWithText:attrs name:@"src"];
    NSString *alt = [self attributeValueWithText:attrs name:@"alt"];
    NSString *title = [self attributeValueWithText:attrs name:@"title"];
    NSString *repl = nil;
    if(title && title.length > 0)
      repl = [NSString stringWithFormat:@"![%@](%@ \"%@\")", alt, src, title];
    else
      repl = [NSString stringWithFormat:@"![%@](%@)", alt, src];
    text = [text stringByReplacingCharactersInRange:[result rangeAtIndex:0] withString:repl];
  }
  return text;
}


@end
