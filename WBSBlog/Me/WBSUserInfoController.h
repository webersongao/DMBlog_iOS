//
//  WBSUserInfoController.h
//  WBSBlog
//
//  Created by Weberson on 16/7/20.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBSUserModel.h"

@interface WBSUserInfoController : UITableViewController
@property (nonatomic, strong) WBSUserModel *userModel;  //!< 用户信息

@end
