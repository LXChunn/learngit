//
//  XPCreateCarpoolViewController.m
//  XPApp
//
//  Created by iiseeuu on 16/2/22.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPCreateCarpoolViewController.h"
#import "XPCommonTitleCell.h"
#import "XPCarpoolingsViewModel.h"
#import "XPSelectDatePicker.h"
#import "XPCarpoolModel.h"
#import "XPCarpoolingsListViewController.h"
#import <XPTextView/XPTextView.h>
#import <NSDate+DateTools.h>
#import "NSString+Verify.h"
#import "UIView+HESizeHeight.h"
#define BoundsWidth [UIScreen mainScreen].bounds.size.width

@interface XPCreateCarpoolViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    float remarkHeight;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet XPCarpoolingsViewModel *createViewModel;
@property (nonatomic, strong) XPSelectDatePicker *selectPicker;
@property (nonatomic, strong) XPCarpoolModel *createModel;

@end

@implementation XPCreateCarpoolViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!_createModel) {
        _createModel = [[XPCarpoolModel alloc]init];
    }
    @weakify(self);
    [self rac_liftSelector:@selector(cleverLoader:) withSignals:RACObserve(self.createViewModel, executing), nil];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.createViewModel, error) ignore:nil] map:^id (id value) {
        @strongify(self);
        [self hideLoader];
        return [value localizedDescription];
    }], nil];
    [[RACObserve(self.createViewModel, successMessage)ignore:nil] subscribeNext:^(id x) {
       @strongify(self)
        [self showToast:self.createViewModel.successMessage];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CarpoolRefreshNotification" object:nil];
        self.isAdd = YES;
        [self goBackCarpoolingsList];
    }];
}

#pragma mark - Delegate
#pragma mark - UITableViewDelegateAndDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPCommonTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPCommonTitleCell"];
    if(!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XPCommonTitleCell" owner:nil options:nil] lastObject];
    }
    switch (indexPath.row) {
        case 0:{
            
         [cell configureUIWithTitle:_createModel.startPoint placeholder:@"请输入起点（1-20个字）" block:^(NSString *text) {
             self.createModel.startPoint = text;
         }];
            return cell;
        }
        case 1:{
            [cell configureUIWithTitle:_createModel.endPoint placeholder:@"请输入终点（1-20个字）" block:^(NSString *text) {
                self.createModel.endPoint = text;
            }];
            return cell;
        }
        case 2:{
            
            [cell configureUIWithTitle:_createModel.showTime placeholder:@"请选择出发时间" block:^(NSString *text) {
                self.createModel.time = text;
            }];
            return cell;
        }
        case 3:{
            
            [cell configureUIWithTitle:_createModel.mobile placeholder:@"请输入联系电话" block:^(NSString *text) {
                self.createModel.mobile = text;
            }];
            return cell;
        }
        case 4:{
            UITableViewCell *cell  = nil;
            if (indexPath.row ==4) {
                cell = [_tableView dequeueReusableCellWithIdentifier:@"textViewCell" forIndexPath:indexPath];
                XPTextView *textView = [cell viewWithTag:20];
                textView.placeholder = @"备注（选填）";
                textView.font = [UIFont systemFontOfSize:16];
                 @weakify(self);
                [textView.rac_textSignal subscribeNext:^(NSString * x) {
                    @strongify(self);
                    self.createModel.remark = x;
                }];
            }
            return cell;
        }
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.row) {
        case 0: {
            return 45;
        }
        case 1: {
            return 45;
        }
        case 2: {
            return 45;
        }
        case 3: {
            return 45;
        }
        case 4: {
            return 110;
        }
        default: {
        }
            break;
    }
    return 0.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 2) {
        _selectPicker = [[XPSelectDatePicker alloc] init];
        [_selectPicker loadPickerWithselectDateType:SelectDateTypeOfAfter finishSelectDate:^(NSDate *date) {
            _createModel.time = [NSString stringWithFormat:@"%ld", (long)date.timeIntervalSince1970];
            _createModel.showTime = [date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
            [tableView reloadData];
        }];
    }
}

#pragma mark - Event Responds
- (IBAction)postCarpoolItemAction:(id)sender
{
    [self.view endEditing:YES];
    self.createViewModel.model = _createModel;
    if (self.createViewModel.model.remark.length >=100) {
        self.createViewModel.model.remark = [self.createViewModel.model.remark substringToIndex:99];
    }
    if ([NSString verifyStartPoint:self.createViewModel.model.startPoint endPoint:self.createViewModel.model.endPoint mobilePhone:self.createViewModel.model.mobile startTime:self.createViewModel.model.time remark:self.createViewModel.model.remark]) {
         [self.createViewModel.createCommand execute:nil];
    }
}

#pragma mark - Private Methods
#pragma mark -
- (BOOL)navigationShouldPopOnBackButton
{
    [self goBackCarpoolingsList];
    return NO;
}

- (void)goBackCarpoolingsList
{
    for(UIViewController *vc in self.navigationController.viewControllers) {
        if([vc isKindOfClass:[XPCarpoolingsListViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

#pragma mark - Getter & Setter

@end 
