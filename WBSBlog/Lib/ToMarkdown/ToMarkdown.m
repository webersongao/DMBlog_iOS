//
//  ToMarkdown.m
//  ToMarkdown
//
//  Created by Atsushi Nagase on 11/2/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import "ToMarkdown.h"
#import "TMDAnchor.h"
#import "TMDBold.h"
#import "TMDCode.h"
#import "TMDElement.h"
#import "TMDHeading.h"
#import "TMDHorizontalRule.h"
#import "TMDImage.h"
#import "TMDItalic.h"
#import "TMDLineBreak.h"
#import "TMDParagraph.h"

@implementation ToMarkdown

static NSArray *_elements = nil;

+ (NSArray *)elements {
  if(!_elements) {
    _elements =
    @[
      [[TMDParagraph alloc] init],
      [[TMDLineBreak alloc] init],
      [[TMDHeading alloc] init],
      [[TMDHorizontalRule alloc] init],
      [[TMDAnchor alloc] init],
      [[TMDBold alloc] init],
      [[TMDItalic alloc] init],
      [[TMDCode alloc] init],
      [[TMDImage alloc] init]
      ];
  }
  return _elements;
}

+ (NSString *)fromHTML:(NSString *)htmlString {
  NSString *ret = [htmlString copy];
  for (TMDElement *ele in [self elements]) {
    ret = [ele replaceText:ret];
  }
  return ret;
}

@end
