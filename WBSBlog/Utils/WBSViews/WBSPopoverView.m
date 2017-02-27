//
//  WBSPopoverView.m
//  WBSBlog
//
//  Created by Weberson on 17/2/18.
//  Copyright © 2016年 Weberson. All rights reserved.
//

#import "WBSPopoverView.h"
#define Length 5
#define Length2 15
@interface WBSPopoverView ()<UITableViewDelegate, UITableViewDataSource>
{
    UIView *coverView;
}
@property (nonatomic, assign) CGPoint scaleOrigin;

@property (nonatomic, assign) CGFloat scaleHeight;

@property (nonatomic, assign) CGFloat scaleWidth;
// titles
@property (nonatomic, strong) NSArray * titleArray;
// images
@property (nonatomic, strong) NSArray * imagesArray;

@property (nonatomic, assign) WBSScaleDirectionType type;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WBSPopoverView

- (instancetype)initWithOrigin:(CGPoint)origin Width:(CGFloat)width Height:(CGFloat)height Type:(WBSScaleDirectionType)type Color:(UIColor *)color titleArray:(NSArray *)titleArr imagesArray:(NSArray *)imagesArr superView:(UIView *)superView
{
    
    self = [super initWithFrame:CGRectMake(0, 0, KSCREEN_Width, KSCREEN_Height)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // 箭头的位置
        self.scaleOrigin = origin;
        // 视图的宽度
        self.scaleWidth = width;
        // 视图的高度
        self.scaleHeight = height;
        
        // 类型
        self.type = type;
        self.backGoundView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, width, height)];
        self.backGoundView.backgroundColor = color;
        [self addSubview:self.backGoundView];
        // 添加tableview
        [self.backGoundView addSubview:self.tableView];
        
        // 标题和图片
        self.titleArray = [[NSArray alloc]initWithArray:titleArr];
        self.imagesArray = [[NSArray alloc]initWithArray:imagesArr];
        
        //给superView添加蒙板
        coverView = [[UIView alloc]init];
        coverView.frame = superView.bounds;
        coverView.backgroundColor = [UIColor blackColor];
        coverView.alpha = 0.3;
        [superView addSubview:coverView];
        
        
    }
    return self;
}
#pragma mark - drawRect
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    switch (self.type) {
        case WBSScaleDirectionTypeUpLeft:
        case WBSScaleDirectionTypeUpCenter:
        case WBSScaleDirectionTypeUpRight:{
            {
                CGFloat startX = self.scaleOrigin.x;
                CGFloat startY = self.scaleOrigin.y;
                CGContextMoveToPoint(context, startX, startY);
                CGContextAddLineToPoint(context, startX + Length, startY + Length);
                CGContextAddLineToPoint(context, startX - Length, startY + Length);
            }
            break;
        }
        case WBSScaleDirectionTypeDownLeft:
        case WBSScaleDirectionTypeDownCenter:
        case WBSScaleDirectionTypeDownRight: {
            {
                CGFloat startX = self.scaleOrigin.x;
                CGFloat startY = self.scaleOrigin.y;
                CGContextMoveToPoint(context, startX, startY);
                CGContextAddLineToPoint(context, startX - Length, startY - Length);
                CGContextAddLineToPoint(context, startX + Length, startY - Length);
            }
            break;
        }
        case WBSScaleDirectionTypeLeftUp:
        case WBSScaleDirectionTypeLeftCenter:
        case WBSScaleDirectionTypeLeftDown: {
            {
                CGFloat startX = self.scaleOrigin.x;
                CGFloat startY = self.scaleOrigin.y;
                CGContextMoveToPoint(context, startX, startY);
                CGContextAddLineToPoint(context, startX + Length, startY - Length);
                CGContextAddLineToPoint(context, startX + Length, startY + Length);
            }
            break;
        }
        case WBSScaleDirectionTypeRightUp:
        case WBSScaleDirectionTypeRightCenter:
        case WBSScaleDirectionTypeRightDown: {
            {
                CGFloat startX = self.scaleOrigin.x;
                CGFloat startY = self.scaleOrigin.y;
                CGContextMoveToPoint(context, startX, startY);
                CGContextAddLineToPoint(context, startX - Length, startY - Length);
                CGContextAddLineToPoint(context, startX - Length, startY + Length);
            }
            break;
        }
    }
    
    CGContextClosePath(context);
    [self.backGoundView.backgroundColor setFill];
    [self.backgroundColor setStroke];
    CGContextDrawPath(context, kCGPathFillStroke);
}
#pragma mark - popView
- (void)showScaleView
{
    // 同步显示 子控件(views)和(self)
    NSArray *results = [self.backGoundView subviews];
    for (UIView *view in results) {
        [view setHidden:YES];
    }
    UIWindow *windowView = [UIApplication sharedApplication].keyWindow;
    [windowView addSubview:self];
    switch (self.type) {
        case WBSScaleDirectionTypeUpLeft: {
            {
                self.backGoundView.frame = CGRectMake(self.scaleOrigin.x, self.scaleOrigin.y + Length, 0, 0);
                CGFloat origin_x = self.scaleOrigin.x - Length2;
                CGFloat origin_y = self.scaleOrigin.y + Length;
                CGFloat size_width = self.scaleWidth;
                CGFloat size_height = self.scaleHeight;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
        case WBSScaleDirectionTypeUpCenter: {
            {
                self.backGoundView.frame = CGRectMake(self.scaleOrigin.x, self.scaleOrigin.y + Length, 0, 0);
                CGFloat origin_x = self.scaleOrigin.x - self.scaleWidth / 2;
                CGFloat origin_y = self.scaleOrigin.y + Length;
                CGFloat size_width = self.scaleWidth;
                CGFloat size_height = self.scaleHeight;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
        case WBSScaleDirectionTypeUpRight: {
            {
                self.backGoundView.frame = CGRectMake(self.scaleOrigin.x, self.scaleOrigin.y + Length, 0, 0);
                CGFloat origin_x = self.scaleOrigin.x + Length2;
                CGFloat origin_y = self.scaleOrigin.y + Length;
                CGFloat size_width = -self.scaleWidth;
                CGFloat size_height = self.scaleHeight;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
        case WBSScaleDirectionTypeDownLeft: {
            {
                self.backGoundView.frame = CGRectMake(self.scaleOrigin.x, self.scaleOrigin.y - Length, 0, 0);
                CGFloat origin_x = self.scaleOrigin.x - Length2;
                CGFloat origin_y = self.scaleOrigin.y - Length;
                CGFloat size_width = self.scaleWidth;
                CGFloat size_height = -self.scaleHeight;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
        case WBSScaleDirectionTypeDownCenter: {
            {
                self.backGoundView.frame = CGRectMake(self.scaleOrigin.x, self.scaleOrigin.y - Length, 0, 0);
                CGFloat origin_x = self.scaleOrigin.x - self.scaleWidth / 2;
                CGFloat origin_y = self.scaleOrigin.y - Length;
                CGFloat size_width = self.scaleWidth;
                CGFloat size_height = -self.scaleHeight;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
        case WBSScaleDirectionTypeDownRight: {
            {
                self.backGoundView.frame = CGRectMake(self.scaleOrigin.x, self.scaleOrigin.y - Length, 0, 0);
                CGFloat origin_x = self.scaleOrigin.x-self.scaleWidth + Length2;
                CGFloat origin_y = self.scaleOrigin.y - Length;
                CGFloat size_width = self.scaleWidth;
                CGFloat size_height = -self.scaleHeight;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
            
        case WBSScaleDirectionTypeLeftUp: {
            {
                self.backGoundView.frame = CGRectMake(self.scaleOrigin.x + Length, self.scaleOrigin.y, 0, 0);
                CGFloat origin_x = self.scaleOrigin.x + Length;
                CGFloat origin_y = self.scaleOrigin.y - Length2;
                CGFloat size_width = self.scaleWidth;
                CGFloat size_height = self.scaleHeight;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
        case WBSScaleDirectionTypeLeftCenter: {
            {
                self.backGoundView.frame = CGRectMake(self.scaleOrigin.x + Length, self.scaleOrigin.y, 0, 0);
                CGFloat origin_x = self.scaleOrigin.x + Length;
                CGFloat origin_y = self.scaleOrigin.y - self.scaleHeight / 2;
                CGFloat size_width = self.scaleWidth;
                CGFloat size_height = self.scaleHeight;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
        case WBSScaleDirectionTypeLeftDown: {
            {
                self.backGoundView.frame = CGRectMake(self.scaleOrigin.x + Length, self.scaleOrigin.y, 0, 0);
                CGFloat origin_x = self.scaleOrigin.x + Length;
                CGFloat origin_y = self.scaleOrigin.y - self.scaleHeight + Length2;
                CGFloat size_width = self.scaleWidth;
                CGFloat size_height = self.scaleHeight;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
        case WBSScaleDirectionTypeRightUp: {
            {
                self.backGoundView.frame = CGRectMake(self.scaleOrigin.x - Length, self.scaleOrigin.y, 0, 0);
                CGFloat origin_x = self.scaleOrigin.x - Length;
                CGFloat origin_y = self.scaleOrigin.y - Length2;
                CGFloat size_width = -self.scaleWidth;
                CGFloat size_height = self.scaleHeight;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
        case WBSScaleDirectionTypeRightCenter: {
            {
                self.backGoundView.frame = CGRectMake(self.scaleOrigin.x - Length, self.scaleOrigin.y, 0, 0);
                CGFloat origin_x = self.scaleOrigin.x - Length;
                CGFloat origin_y = self.scaleOrigin.y - self.scaleHeight / 2;
                CGFloat size_width = -self.scaleWidth;
                CGFloat size_height = self.scaleHeight;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
        case WBSScaleDirectionTypeRightDown: {
            {
                self.backGoundView.frame = CGRectMake(self.scaleOrigin.x - Length, self.scaleOrigin.y, 0, 0);
                CGFloat origin_x = self.scaleOrigin.x - Length;
                CGFloat origin_y = self.scaleOrigin.y - self.scaleHeight + Length2;
                CGFloat size_width = -self.scaleWidth;
                CGFloat size_height = self.scaleHeight;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
    }
}
#pragma mark -
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (![[touches anyObject].view isEqual:self.backGoundView]) {
        [self dismissScaleView];
    }
    
}
#pragma mark -
- (void)dismissScaleView
{
    /**
     *  删除 在backGroundView 上的子控件
     */
    
    NSArray *results = [self.backGoundView subviews];
    
    for (UIView *view in results) {
        
        [view removeFromSuperview];
        
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        //
        self.backGoundView.frame = CGRectMake(self.scaleOrigin.x, self.scaleOrigin.y, 0, 0);
    } completion:^(BOOL finished) {
        //移除蒙板
        [coverView removeFromSuperview];
        [self removeFromSuperview];
        
    }];
    
    
    
}
#pragma mark -
- (void)startAnimateView_x:(CGFloat) x
                        _y:(CGFloat) y
              origin_width:(CGFloat) width
             origin_height:(CGFloat) height
{
    [UIView animateWithDuration:0.25 animations:^{
        self.backGoundView.frame = CGRectMake(x, y, width, height);
    }completion:^(BOOL finished) {
        NSArray *results = [self.backGoundView subviews];
        for (UIView *view in results) {
            [view setHidden:NO];
        }
    }];
}
#pragma mark -
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.backGoundView.frame.size.width , self.backGoundView.frame.size.height) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.bounces = NO;
    }
    return _tableView;
}
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}
#pragma mark -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.row_height ? self.row_height : (self.backGoundView.frame.size.height/self.titleArray.count);
}
#pragma mark -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"WBSScaleViewId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.imageView.image = [UIImage imageNamed:self.imagesArray[indexPath.row]];
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:self.fontSize ? self.fontSize : 13.0];
    cell.textLabel.textColor = self.titleTextColor ? self.titleTextColor : [UIColor blackColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scaleView:didSelectRow:)]) {
        [self.delegate scaleView:self didSelectRow:indexPath.row];
    }
}
@end
