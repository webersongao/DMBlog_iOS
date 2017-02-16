//
//  WBSPostTableView.h
//  WBSBlog
//
//  Created by Weberson on 2017/2/13.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  API 类型枚举
 */
typedef NS_ENUM(NSInteger,PostAPIType){
    /**
     *  JSON API
     */
    APITypeJSON,
    /**
     *  XMLRPC API
     */
    APITypeXMLRPC,
    /**
     *  Http API
     */
    APITypeHttp
};
@class WBSPostTableView;
@class WBSPostModel ;

@protocol PostTableViewDelegate <NSObject>

-(void)PostTableViewCellDidSelectWithTableView:(WBSPostTableView *)tableView andPostModel:(WBSPostModel *)postModel;

@end

@interface WBSPostTableView : UITableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withAPiType:(PostAPIType)type;

@property (nonatomic, strong) NSArray *dataArray;  //!< 数据源数组

@property (nonatomic, assign) id<PostTableViewDelegate> selectDelegate;  //!< <#属性注释#>

@end















