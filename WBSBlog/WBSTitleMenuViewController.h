//
//  WBSTitleMenuTableViewController.h
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBSDropdownMenuView;

@protocol TitleMenuDelegate <NSObject>
#pragma mark 当前选中了哪一行
@required
- (void)selectAtIndexPathAndID:(NSIndexPath *)indexPath ID:(NSInteger)ID title:(NSString*)title;
@end

@interface WBSTitleMenuViewController : UITableViewController

@property (nonatomic, weak) id<TitleMenuDelegate> delegate;

@property (nonatomic, weak) WBSDropdownMenuView * dropdownMenuView;

@end