//
//  XPDetailCarpoolViewController.m
//  XPApp
//
//  Created by iiseeuu on 16/2/22.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPDetailCarpoolViewController.h"
#import <UIImageView+WebCache.h>
#import <NSDate+DateTools.h>
#import "XPMoreOptionsViewController.h"
#import "UIAlertView+XPKit.h"
#import "XPCarpoolingsViewModel.h"
#import "MJRefresh.h"
#import "UIView+HESizeHeight.h"
#import "UIView+block.h"
#import "XPLoginModel.h"
#import "XPDetailTitleCarpoolTableViewCell.h"
#import "XPDetailContentCarpoolTableViewCell.h"

#define BoundsWidth [UIScreen mainScreen].bounds.size.width

@interface XPDetailCarpoolViewController ()<UITableViewDataSource,UITableViewDelegate,XPOptionsViewControllerDelegate>
{
    CGFloat remarkHeight;
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (weak, nonatomic) IBOutlet UITableView *tableView;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic) IBOutlet XPCarpoolingsViewModel *viewModel;
#pragma clang diagnostic pop
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *navigaitonBarButtonItem;
@property (nonatomic, strong) XPMoreOptionsViewController *moreOptions;

@end

@implementation XPDetailCarpoolViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    if([[XPLoginModel singleton].userId isEqualToString:self.detailModel.author.userId]) {
        _navigaitonBarButtonItem.image = [UIImage imageNamed:@"common_navigation_more"];
    }else{
        self.navigationItem.rightBarButtonItems = nil;
    }
    self.bottomView.userInteractionEnabled = YES;
    self.middleView.userInteractionEnabled = YES;
    [self.bottomView whenTapped:^{
    NSMutableString *phone = [[NSMutableString alloc]initWithFormat:@"telprompt://%@",self.detailModel.mobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
    }];
    
  
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float startPointHeight =[UIView getTextSizeHeight:self.detailModel.startPoint font:14 withSize:CGSizeMake(BoundsWidth - 34, MAXFLOAT)];
    float endPointHeight =[UIView getTextSizeHeight:self.detailModel.endPoint font:14 withSize:CGSizeMake(BoundsWidth - 34, MAXFLOAT)];
    float startTimeHeight =[UIView getTextSizeHeight:self.detailModel.time font:14 withSize:CGSizeMake(BoundsWidth - 34, MAXFLOAT)];
    if (indexPath.row==0) {
        return 71;
    }
    if (indexPath.row == 1) {
        if (self.detailModel.remark.length>1) {
            
            remarkHeight = [UIView getTextSizeHeight:self.detailModel.remark font:14 withSize:CGSizeMake(BoundsWidth - 34, MAXFLOAT)];
            return 110+remarkHeight+startPointHeight+endPointHeight+startTimeHeight;
            
        }else{
            return 62+startPointHeight+endPointHeight+startTimeHeight;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        XPDetailTitleCarpoolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell" forIndexPath:indexPath];
        cell.detailModel = _detailModel;
        __weak typeof(self) weakSelf = self;
        [cell whenClickAvatorWithBlock:^{
            [weakSelf goOtherUserInfoCenterWithModel:_detailModel.author];
        }];
        return cell;
    }else{
        XPDetailContentCarpoolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContentCell" forIndexPath:indexPath];
        cell.detailModel = _detailModel;
        return cell;
    }
}

#pragma mark - Delegate
#pragma mark - XPOptionsViewControllerDelegate
-(void)optionsViewController:(XPMoreOptionsViewController *)optionsViewController didSelectRow:(NSInteger)row
{
    self.viewModel.carpoolingItemId = _detailModel.carpoolingItemId;
    switch (row) {
        case 0:{
            //删除
            [self deleteAction];
            break;
        }
        default:
            break;
    }
}

-(void)deleteAction
{
    @weakify(self);
    [UIAlertView alertViewWithTitle:@"提示" message:@"确定删除？" block:^(NSInteger buttonIndex) {
        if(buttonIndex == 0) {
            @strongify(self);
            [[RACObserve(self.viewModel, isDeleteSuccess) ignore:nil] subscribeNext:^(id x) {
                [self hideLoader];
                [self.viewModel.deleteCommand execute:nil];
                if (self.viewModel.isDeleteSuccess) {
                    self.isDelete = YES;
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"MyCarpoolRefreshNotification" object:nil];
                    [self pop];
                }
            }];
            self.viewModel.carpoolingItemId = _detailModel.carpoolingItemId;
            [self.viewModel.deleteCommand execute:nil];
        }
    } cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
}

#pragma mark - Event Responds
- (IBAction)barButtonItemAction:(id)sender
{
    _moreOptions = [[XPMoreOptionsViewController alloc]initWithMoreOptionsWithIcons:@[@"secondhand_cancel_ico"] titles:@[@"删除"]];
    _moreOptions.delegate = self;
    [_moreOptions show];
}

#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end 
