//
//  XPDetailMyMaintenanceViewController.m
//  XPApp
//
//  Created by iiseeuu on 15/12/25.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "UIAlertView+XPKit.h"
#import "UIViewController+BackButtonHandler.h"
#import "XPDetailImageShowView.h"
#import "XPDetailMyMaintenanceViewController.h"
#import "XPMaintenanceViewModel.h"
#import "XPMoreOptionsViewController.h"
#import "XPMyMaintenanceViewController.h"
#import <DateTools/DateTools.h>
#import <SDWebImage-ProgressView/UIImageView+ProgressView.h>
#import "UIView+HESizeHeight.h"
#define BoundsWidth [UIScreen mainScreen].bounds.size.width

@interface XPDetailMyMaintenanceViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet XPMaintenanceViewModel *maintenanceviewModel;
@property (weak, nonatomic) IBOutlet UIButton *buttonText;

@property (nonatomic,assign)CGFloat contentHeight;

@end

@implementation XPDetailMyMaintenanceViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.row==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ContentCell" forIndexPath:indexPath];
        UILabel *content = [ cell viewWithTag:11];
       content.text = self.detailModel.content;
        return cell;
    }
    
    if (indexPath.row==1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell" forIndexPath:indexPath];
        XPDetailImageShowView *view = [cell viewWithTag:12];
            [view loadUIWithImagesArray:self.detailModel.picUrls];
        return cell;
    }
    if (indexPath.row==2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TimeStatusCell" forIndexPath:indexPath];
         UILabel *time = [ cell viewWithTag:13];
         UILabel *status = [ cell viewWithTag:14];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.detailModel.createdAt.doubleValue];
       time.text = [date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
        switch([self.detailModel.status intValue]) {
            case 1: {
              status.text = @"待处理";
                [self.buttonText setTitle:@"取消报修" forState:UIControlStateNormal];
            }
                break;
                
            case 2: {
               status.text = @"处理中";
                [self.buttonText setTitle:@"确认完成" forState:UIControlStateNormal];
            }
                break;
                
            case 3: {
                status.text = @"已处理";
                [self.buttonText setTitle:@"确认完成" forState:UIControlStateNormal];
            }
                break;
                
            case 100: {
              status.text = @"确认";
                [self.buttonText setHidden:YES];
            }
                break;
                
            default: {
            }
                break;
        }
        
        return cell;
    }

    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     self.contentHeight = [UIView getTextSizeHeight:_detailModel.content font:16 withSize:CGSizeMake(BoundsWidth - 60, MAXFLOAT)];
    if (indexPath.row == 0) {
      
        return 16+_contentHeight+16+2;
    }
   
    if (indexPath.row == 1) {
        if (self.detailModel.picUrls.count>0) {
            return 110+24+22;
        }else{
            return 0;
        }
    }
    if (indexPath.row == 2) {
        
        return 160;
    }
    return 100;
}




#pragma mark - Delegate

#pragma mark - Event Responds
- (IBAction)buttonAction:(id)sender
{
    [self.view endEditing:YES];
    self.maintenanceviewModel.maintenanceorderId = _detailModel.maintenanceOrderId;
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
    [UIAlertView alertViewWithTitle:@"提示" message:@"确定取消报修" block:^(NSInteger buttonIndex) {
        if(buttonIndex == 0) {
            @strongify(self);
            [[RACObserve(self.maintenanceviewModel, isCancelSuccess) ignore:nil] subscribeNext:^(id x) {
                @strongify(self);
                [self hideLoader];
                 [self.maintenanceviewModel.cancelCommand execute:nil];
                if(self.maintenanceviewModel.isCancelSuccess) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"MyMaintenanceRefreshNotification" object:nil];
                    [self pop];
                }
            }];
            self.maintenanceviewModel.maintenanceorderId = _detailModel.maintenanceOrderId;
            [self.maintenanceviewModel.cancelCommand execute:nil];
        }else if (buttonIndex == 1){
        }
    }
                  cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
}

-(void)confirmAction
{
    @weakify(self);
    [UIAlertView alertViewWithTitle:@"提示" message:@"确定报修已完成" block:^(NSInteger buttonIndex) {
        if(buttonIndex == 0) {
            @strongify(self);
            [[RACObserve(self.maintenanceviewModel, isConfirmSuccess) ignore:nil] subscribeNext:^(id x) {
                @strongify(self);
                [self hideLoader];
                [self.maintenanceviewModel.confirmCommand execute:nil];
                if(self.maintenanceviewModel.isConfirmSuccess) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"MyMaintenanceRefreshNotification" object:nil];
                    [self pop];
                }
            }];
            self.maintenanceviewModel.maintenanceorderId = _detailModel.maintenanceOrderId;
            [self.maintenanceviewModel.confirmCommand execute:nil];
        }else if (buttonIndex == 1){
        }
    }
                  cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
}




#pragma mark - Private Methods
#pragma mark - Getter & Setter

@end
