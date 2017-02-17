//
//  WBSEmojiPageVC.m
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSEmojiPageVC.h"
#import "WBSEmojiPanelVC.h"
#import "WBSPlaceholderTextView.h"

@interface WBSEmojiPageVC () <UIPageViewControllerDataSource>

@property (nonatomic, copy) void (^didSelectEmoji) (NSTextAttachment *);
@property (nonatomic, copy) void (^deleteEmoji)();

@end


@implementation WBSEmojiPageVC

- (instancetype)initWithTextView:(WBSPlaceholderTextView *)textView
{
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                  options:nil];
    if (self) {
        _didSelectEmoji = ^(NSTextAttachment *textAttachment) {
            NSAttributedString *emojiAttributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
            NSMutableAttributedString *mutableAttributeString = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
            [mutableAttributeString replaceCharactersInRange:textView.selectedRange withAttributedString:emojiAttributedString];
            textView.attributedText = mutableAttributeString;
            [textView insertText:@""];
            textView.font = [UIFont systemFontOfSize:16];
            [textView checkShouldHidePlaceholder];
            [textView.delegate textViewDidChange:textView];
        };
        _deleteEmoji = ^ {
            [textView deleteBackward];
            [textView checkShouldHidePlaceholder];
            [textView.delegate textViewDidChange:textView];
        };
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor themeColor];
    
    WBSEmojiPanelVC *emojiPanelVC = [[WBSEmojiPanelVC alloc] initWithPageIndex:0];
    emojiPanelVC.didSelectEmoji = _didSelectEmoji;
    emojiPanelVC.deleteEmoji    = _deleteEmoji;
    if (emojiPanelVC != nil) {
        self.dataSource = self;
        [self setViewControllers:@[emojiPanelVC]
                       direction:UIPageViewControllerNavigationDirectionReverse
                        animated:NO
                      completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(WBSEmojiPanelVC *)vc
{
    int index = vc.pageIndex;
    
    if (index == 0) {
        return nil;
    } else {
        WBSEmojiPanelVC *emojiPanelVC = [[WBSEmojiPanelVC alloc] initWithPageIndex:index-1];
        emojiPanelVC.didSelectEmoji = _didSelectEmoji;
        emojiPanelVC.deleteEmoji    = _deleteEmoji;
        return emojiPanelVC;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(WBSEmojiPanelVC *)vc
{
    int index = vc.pageIndex;
    
    if (index == 6) {
        return nil;
    } else {
        WBSEmojiPanelVC *emojiPanelVC = [[WBSEmojiPanelVC alloc] initWithPageIndex:index+1];
        emojiPanelVC.didSelectEmoji = _didSelectEmoji;
        emojiPanelVC.deleteEmoji    = _deleteEmoji;
        return emojiPanelVC;
    }
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 7;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}





@end
