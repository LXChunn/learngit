//
//  XPOtherDetailViewController.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/11.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "CExpandHeader.h"
#import "XPHeadView.h"
#import "XPMyPrivateMessageDetailViewController.h"
#import "XPOtherDetailViewController.h"
#import <UIImageView+WebCache.h>
@interface XPOtherDetailViewController ()
{
    CExpandHeader *header;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) XPHeadView *headView;
@end

@implementation XPOtherDetailViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UITableView alloc]init];
    self.tableView.delaysContentTouches = NO;
    _headView = [[[NSBundle mainBundle]loadNibNamed:@"XPHeadView" owner:nil options:nil]lastObject];
    _headView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 250);
    header = [CExpandHeader expandWithScrollView:self.tableView expandView:_headView];
    [self.tableView bringSubviewToFront:self.headView];
    UIImageView *avata = [_headView viewWithTag:9];
    UILabel *title = [_headView viewWithTag:22];
    title.text = @"TA的资料";
    UIButton *popBtn = [_headView viewWithTag:11];
    [[popBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self pop];
    }];
    [avata sd_setImageWithURL:[NSURL URLWithString:self.otherModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"common_default_avatar"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - UITableViewDelegateAndDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"otherDetailCell" forIndexPath:indexPath];
    UILabel *nikeNamelabel = [cell viewWithTag:12];
    nikeNamelabel.text = self.otherModel.nickname;
    tableView.separatorColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Event
- (IBAction)sendMessage:(id)sender
{
    XPMyPrivateMessageDetailViewController *detailViewController = (XPMyPrivateMessageDetailViewController *)[self instantiateViewControllerWithStoryboardName:@"MyPrivateLetter" identifier:@"XPMyPrivateMessageDetailViewController"];
    detailViewController.userModel = _otherModel;
    [self pushViewController:detailViewController];
}

@end
