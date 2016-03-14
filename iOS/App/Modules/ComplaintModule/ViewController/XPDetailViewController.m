//
//  XPDetailViewController.m
//  XPApp
//
//  Created by Mac OS on 15/12/28.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width


#import "UIAlertView+XPKit.h"
#import "XPComplaintViewModel.h"
#import "XPDetailImageShowView.h"
#import "XPDetailViewController.h"
#import "XPLog.h"
#import <DateTools/DateTools.h>
#import "UIView+HESizeHeight.h"

@interface XPDetailViewController ()

@property (strong, nonatomic) IBOutlet XPComplaintViewModel *complaintViewModel;
@property (weak, nonatomic) IBOutlet UIButton *buttonType;
@property (nonatomic, strong) NSArray *imageUrlArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation XPDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor =[UIColor whiteColor] ;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorColor = [UIColor clearColor];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 46+[UIView getTextSizeHeight:self.detailModel.content font:16 withSize:CGSizeMake(SCREENWIDTH - 25, MAXFLOAT)];
    }
    if (indexPath.row == 1) {
        if (self.detailModel.picUrls.count == 0) {
            return 0;
        }
        return 124;
    }
    return 59;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell" forIndexPath:indexPath];
        UILabel *titleLabel = [cell viewWithTag:11];
        UILabel *linlabel = [cell viewWithTag:21];
        if (self.detailModel.picUrls.count>0) {
            linlabel.hidden = YES;
        }
        titleLabel.text = self.detailModel.content;
    }
    if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"imagesCell" forIndexPath:indexPath];
        XPDetailImageShowView *imagesView = [cell viewWithTag:12];
        self.imageUrlArray = self.detailModel.picUrls;
        [imagesView loadUIWithImagesArray:_imageUrlArray];
    }
    if (indexPath.row == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"timeCell" forIndexPath:indexPath];
        UILabel *timeLabel = [cell viewWithTag:13];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.detailModel.createdAt.doubleValue];
        timeLabel.text = [date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
    }
    if (indexPath.row == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"statusCell" forIndexPath:indexPath];
        UILabel *statuslabel = [cell viewWithTag:14];
        [self initUI:statuslabel];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)initUI:(UILabel *)label
{
        [[RACObserve(self, detailModel.status) ignore:nil] subscribeNext:^(id x) {
        XPLog(@"状态数据：%d", [x intValue]);
        switch([x intValue]) {
            case 1: {
                label.text = @"待处理";
                [self.buttonType setTitle:@"取消投诉" forState:UIControlStateNormal];
                break;
            }
                
            case 2: {
                label.text = @"处理中";
                [self.buttonType setTitle:@"确认完成" forState:UIControlStateNormal];
                break;
            }
                
            case 3: {
                label.text = @"已处理";
                [self.buttonType setTitle:@"确认完成" forState:UIControlStateNormal];
                break;
            }
                
            case 4: {
                label.text = @"确认";
                [self.buttonType setHidden:YES];
                break;
            }
                
            default: {
            }
                break;
        }
    }];
}

#pragma mark - Event Responds
- (IBAction)buttonAction:(id)sender
{
    [self.view endEditing:YES];
    self.complaintViewModel.complaintId = _detailModel.complaintId;
    switch([self.detailModel.status intValue]) {
        case 1: {
            [self cancelAction];
        }
            break;
            
        case 2:
        case 3: {
            
            [self confirmAction];
        }
            break;
            
        default: {
        }
            break;
    }
}

- (void)cancelAction
{
    @weakify(self);
    [UIAlertView alertViewWithTitle:@"提示" message:@"确定取消投诉" block:^(NSInteger buttonIndex) {
        if(buttonIndex == 0) {
            @strongify(self);
            [[RACObserve(self.complaintViewModel, isCancelSuccess) ignore:nil] subscribeNext:^(id x) {
                @strongify(self);
                [self hideLoader];
                 [self.complaintViewModel.cancelCommand execute:nil];
                if(self.complaintViewModel.isCancelSuccess) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ComplaintRefreshNotification" object:nil];
                    [self pop];
                }
            }];
            self.complaintViewModel.complaintId = _detailModel.complaintId;
            [self.complaintViewModel.cancelCommand execute:nil];
        }else if (buttonIndex == 1){

        }
    }
                  cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
}

- (void)confirmAction
{
    @weakify(self);
    [UIAlertView alertViewWithTitle:@"提示" message:@"确定投诉已完成" block:^(NSInteger buttonIndex) {
        if(buttonIndex == 0) {
            @strongify(self);
            [[RACObserve(self.complaintViewModel, isConfirmSuccess) ignore:nil] subscribeNext:^(id x) {
                @strongify(self);
                [self hideLoader];
                [self.complaintViewModel.confirmCommand execute:nil];
                if(self.complaintViewModel.isConfirmSuccess) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ComplaintRefreshNotification" object:nil];
                    [self pop];
                }
            }];
            self.complaintViewModel.complaintId = _detailModel.complaintId;
            [self.complaintViewModel.confirmCommand execute:nil];
        }else if (buttonIndex == 1){
            
        }
    }
                  cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
}


#pragma mark - Private Methods
#pragma mark - Getter & Setter

@end
