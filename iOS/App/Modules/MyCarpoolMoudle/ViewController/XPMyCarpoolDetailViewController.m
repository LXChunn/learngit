//
//  XPMyCarpoolDetailViewController.m
//  XPApp
//
//  Created by CaoShunQing on 16/2/24.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPMyCarpoolDetailViewController.h"
#import "XPCarpoolingsViewModel.h"
#import <MJRefresh/MJRefresh.h>
#import "XPCommonRefreshHeader.h"
#import "XPCommonRefreshFooter.h"
#import "NSDate+DateTools.h"
#import "XPMyCarpoolDetailCell.h"
#import <UIImageView+WebCache.h>

@interface XPMyCarpoolDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation XPMyCarpoolDetailViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"我的拼车详情";
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorColor = [UIColor clearColor];
}

#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.row ==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell" forIndexPath:indexPath];
        UIImageView *imageView = [cell viewWithTag:11];
        imageView.layer.cornerRadius = 40;
        imageView.layer.masksToBounds = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.detailmodel.author.avatarUrl] placeholderImage:[UIImage imageNamed:@"common_default_avatar"]];
        
        UILabel *nickName = [cell viewWithTag:12];
        nickName.text = self.detailmodel.author.nickname;
        
        UILabel *createTime = [cell viewWithTag:13];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.detailmodel.createdAt doubleValue]];
        createTime.text = [date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if (indexPath.row ==1) {
       XPMyCarpoolDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycarpoolDetail" forIndexPath:indexPath];
        if (!cell) {
            cell = [[XPMyCarpoolDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycarpoolDetail"];
        }
        cell.begainLabel.text =[NSString stringWithFormat:@"起点 : %@",self.detailmodel.startPoint];
        
        cell.endLabel.text = [NSString stringWithFormat:@"终点 : %@",self.detailmodel.endPoint];
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.detailmodel.time doubleValue]];
        cell.timeLabel.text = [NSString stringWithFormat:@"出发时间 : %@",[date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"]];
        cell.remarkLabel.text = @"备注 :";
        if (self.detailmodel.remark) {
           cell.remarkLabel.text = [NSString stringWithFormat:@"备注 : %@",self.detailmodel.remark];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row== 0) {
        return 103;
    }
    return 170;
}
#pragma mark - Event Responds
- (IBAction)callMe:(id)sender
{
    NSMutableString *phone = [[NSMutableString alloc] initWithFormat:@"telprompt://%@", self.detailmodel.mobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
}

#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end 
