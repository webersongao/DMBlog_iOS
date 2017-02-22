//
//  WBSPostTableView.m
//  WBSBlog
//
//  Created by Weberson on 2017/2/13.
//  Copyright © 2017年 Weberson. All rights reserved.
//

#import "WBSPostTableView.h"
#import "WBSPostCell.h"
#import "WBSPostModel.h"
#import "WBSCategoryModel.h"

static NSString *PostCellID = @"WBSPostCellID";

@interface WBSPostTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) PostAPIType ApiType;  //!< <#属性注释#>

@end


@implementation WBSPostTableView


-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withAPiType:(PostAPIType)type{
    
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.ApiType = type;
        self.delegate = self;
        self.dataSource = self;
        self.bounces = YES;
        [self registerClass:[WBSPostCell class] forCellReuseIdentifier:PostCellID];
        
//        self.rowHeight = UITableViewAutomaticDimension;  // 开启预估行高
//        self.estimatedRowHeight = 90;
    }
    return self;
}


#pragma mark - 数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WBSPostCell *cell = [tableView dequeueReusableCellWithIdentifier:PostCellID forIndexPath:indexPath];
    //为了兼容，利用适配方法
    //    NSDictionary * adaptedPost = [self adaptPostByAPIType:self.ApiType post:self.dataArray[indexPath.row]];
    cell.postModel = self.dataArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WBSPostModel *postModel = self.dataArray[indexPath.row];
    
    UILabel *tempLabel = [[UILabel alloc]init];
    tempLabel.numberOfLines = 0;
    tempLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tempLabel.font = [UIFont boldSystemFontOfSize:14];
    
    tempLabel.font = [UIFont boldSystemFontOfSize:15];
    [tempLabel setAttributedText:[WBSUtils attributedTittle:postModel.title]];
    CGFloat titleHeight = [tempLabel sizeThatFits:CGSizeMake(self.width - 16, MAXFLOAT)].height;
    
    tempLabel.text = [WBSUtils shortString:postModel.content andLength:60];
    tempLabel.font = [UIFont systemFontOfSize:13];
    titleHeight += [tempLabel sizeThatFits:CGSizeMake(self.width - 16, MAXFLOAT)].height;
    
    return titleHeight + 42 +(postModel.thumbnailURL?40:0);
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
    
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    WBSPostModel *postModel = self.dataArray[indexPath.row];
    //    NSInteger postId =[NSString stringWithFormat:@"%ld",postModel.postId];//文章ID
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 调用删除文章的方法
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // 调用插入文章的方法
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WBSPostModel *postModel = self.dataArray[indexPath.row];
    
    if (self.selectDelegate && [self.selectDelegate respondsToSelector:@selector(PostTableViewCellDidSelectWithTableView:andPostModel:)])
    {
        [self.selectDelegate performSelector:@selector(PostTableViewCellDidSelectWithTableView:andPostModel:) withObject:self withObject:postModel];
    }
    
}





#pragma mark 适配文章数据
/**
 *  根据API类型适配文章内容
 *
 *  @param type  API类型
 *  @param post  文章
 *
 *  @return 适配后的文章
 */
-(NSDictionary *)adaptPostByAPIType:(PostAPIType)type post:(id)post{
    NSMutableArray *categroies = [NSMutableArray array];
    NSArray *comments =  [NSMutableArray array];
    
    NSMutableDictionary *adaptedPost = [NSMutableDictionary dictionary];
    switch (type) {
        case APITypeJSON:{
            WBSPostModel *jsonPost = post;
            [adaptedPost setValue:[NSString stringWithFormat:@"%ld",jsonPost.postId] forKey:@"id"];
            [adaptedPost setValue:jsonPost.title forKey:@"title"];
            [adaptedPost setValue:jsonPost.content forKey:@"content"];
            [adaptedPost setValue:[WBSUtils dateFromString:jsonPost.date] forKey:@"date"];
            [adaptedPost setValue:@"" forKey:@"author"];
            for (WBSCategoryModel *category in jsonPost.categoriesArray) {
                [categroies addObject:category.title];
            }
            [adaptedPost setValue:categroies forKey:@"categroies"];
            comments = jsonPost.commentsArray;
            [adaptedPost setValue:comments forKey:@"comments"];
            break;
        }
        case APITypeXMLRPC:{
            [adaptedPost setValue:[post valueForKey:@"postid"] forKey:@"id"];
            [adaptedPost setValue:[post valueForKey:@"title"] forKey:@"title"];
            [adaptedPost setValue:[post valueForKey:@"description"] forKey:@"content"];
            [adaptedPost setValue:[post objectForKey:@"dateCreated"] forKey:@"date"];
            [adaptedPost setValue:@"" forKey:@"author"];
            [adaptedPost setValue:categroies forKey:@"categroies"];
            [adaptedPost setValue:comments forKey:@"comments"];
            break;
        }
        case APITypeHttp:{
            [adaptedPost setValue:[post valueForKey:@"id"] forKey:@"id"];
            [adaptedPost setValue:[post objectForKey:@"title"] forKey:@"title"];
            [adaptedPost setValue:[post objectForKey:@"content"] forKey:@"content"];
            [adaptedPost setValue:[WBSUtils dateFromString:[post objectForKey:@"date"]] forKey:@"date"];
            [adaptedPost setValue:@"" forKey:@"author"];
            [adaptedPost setValue:categroies forKey:@"categroies"];
            [adaptedPost setValue:comments forKey:@"comments"];
            break;
        }
        default:
            break;
    }
    return adaptedPost;
}





@end

















