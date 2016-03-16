//
//  ViewController.m
//  分组的tableview
//
//  Created by Mac OS on 16/3/15.
//  Copyright © 2016年 JASON. All rights reserved.
//

#import "ViewController.h"
#import "XCTableViewCell.h"
#import "CExpandHeader.h"

#define ONESECTIONCOUNT 2
#define TWOSECTIONCOUNT 3
#define THREESECTIONCOUNT 2

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    
}

@property(nonatomic,strong)NSMutableArray* imageArr;
@property(nonatomic,strong)NSMutableArray* lableNameArr;

@end
static NSString* myCellId = @"myCell";
@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageArr = [[NSMutableArray alloc]initWithArray:@[@"me_system_ico",
                                                          @"me_message_ico",
                                                          @"me_publish_ico",
                                                          @"me_reply_ico",
                                                          @"me_favorites_ico",
                                                          @"me_activity_ico",
                                                          @"my_car_ico"
                                                         ]];
    self.lableNameArr = [[NSMutableArray alloc]initWithArray:@[@"系统消息",
                                                @"我的私信",
                                                @"我的发布",
                                                @"我的评论",
                                                @"我的收藏",
                                                @"我的活动",
                                                @"我的拼车"
                                                ]];
    
//    _view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 200)];
//    _view.backgroundColor = [UIColor redColor];
//    self.tableView.tableHeaderView = _view;
    
//    self.tableView.contentOffset = CGPointMake(0, -200);
//    self.tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -200, self.view.bounds.size.width, 200)];
    imageView.image = [UIImage imageNamed:@"1"];
    
    [CExpandHeader expandWithScrollView:_tableView expandView:imageView];
//    [self.tableView addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    [self.tableView bringSubviewToFront:imageView];
    self.tableView.rowHeight = 44;
    self.tableView.delegate = self;
    self.tableView.separatorColor = [UIColor clearColor];
    
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark - dedelegate datasource scrolldelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"y = %lf",scrollView.contentOffset.y);
//    CGRect rect = _view.frame;
//    rect.size.height = _view.frame.size.height - scrollView.contentOffset.y;
//    _view.frame = rect;
//    self.tableView.tableHeaderView = _view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        return 2;
    }else if(1 == section){
        return 3;
    }else{
        return 2;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XCTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:myCellId];
    if (cell == nil) {
        cell = [[XCTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger index;
    if (indexPath.section == 1) {
        index = ONESECTIONCOUNT + indexPath.row;
    }else if(indexPath.section == 2){
        index = TWOSECTIONCOUNT + ONESECTIONCOUNT + indexPath.row;
    }else{
        index = indexPath.row;
    }
    
//    NSLog(@"%d",index);
    //添加数据
    cell.image.image = [UIImage imageNamed:self.imageArr[index]];
    cell.lable.text = self.lableNameArr[index];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 12)];
    view.backgroundColor = [UIColor lightGrayColor];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d",indexPath.row);
}

#pragma mark - responder
- (IBAction)click:(id)sender {
    NSLog(@"click...");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
