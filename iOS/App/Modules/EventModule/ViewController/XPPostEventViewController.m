//
//  XPPostEventViewController.m
//  XPApp
//
//  Created by jy on 16/1/4.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "NSDate+DateTools.h"
#import "NSString+Verify.h"
#import "UIViewController+BackButtonHandler.h"
#import "XPCommonContentCell.h"
#import "XPCommonTitleCell.h"
#import "XPCreatePostViewModel.h"
#import "XPEventDateCell.h"
#import "XPEventViewModel.h"
#import "XPPostEventModel.h"
#import "XPPostEventViewController.h"
#import "XPSelectDatePicker.h"
#import "XPTopicViewController.h"
#import "XPTransferOrBuyOfSelectImageCell.h"

@interface XPPostEventViewController ()<BackButtonHandlerProtocol>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) XPPostEventModel *postEventModel;
@property (nonatomic, strong) XPSelectDatePicker *selectPicker;
@property (strong, nonatomic) IBOutlet XPEventViewModel *postEventViewModel;

@end

@implementation XPPostEventViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    _postEventModel = [[XPPostEventModel alloc] init];
    _postEventModel.beginDate = [NSString stringWithFormat:@"%ld", (long)[[NSDate date]timeIntervalSince1970]];
    NSString *showBeginDate = [[NSDate date] formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
    _postEventModel.showBeginDate = showBeginDate;
    _postEventModel.endDate = nil;
    _postEventModel.showEndDate = @"长期有效";
    @weakify(self);
    [[RACObserve(self.postEventViewModel, successMsg) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self showToast:self.postEventViewModel.successMsg];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TopicRefreshNotification" object:nil];
        [self goBackNeighborhoodList];
    }];
    self.myTableView.separatorColor = [UIColor clearColor];
}

#pragma mark - Delegate
#pragma mark - UITableViewDelegateAndDatasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    switch(indexPath.row) {
        case 0: {
            XPCommonTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPCommonTitleCell"];
            if(!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XPCommonTitleCell" owner:nil options:nil] firstObject];
            }
            [cell configureUIWithTitle:_postEventModel.title placeholder:@"请输入活动标题（1-20个字）" block:^(NSString *text) {
                weakSelf.postEventModel.title = text;
            }];
            return cell;
        }
        case 1: {
            XPCommonContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPCommonContentCell"];
            if(!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XPCommonContentCell" owner:nil options:nil] firstObject];
            }
            [cell configureUIWithContent:_postEventModel.content placeholder:@"请输入活动内容（至少10个字）" block:^(NSString *text) {
                weakSelf.postEventModel.content = text;
            }];
            return cell;
        }
        case 2: {
            XPEventDateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPEventDateCell"];
            
            [cell configureUIWithtitle:@"开始时间" date:_postEventModel.showBeginDate];
            return cell;
        }
            
        case 3: {
            XPEventDateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPEventDateCell"];
            [cell configureUIWithtitle:@"结束时间" date:_postEventModel.showEndDate];
            return cell;
        }
        case 4: {
            XPTransferOrBuyOfSelectImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPTransferOrBuyOfSelectImageCell"];
            if(!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XPTransferOrBuyOfSelectImageCell" owner:nil options:nil] firstObject];
            }
            [cell whenUploadFinishImage:^(NSArray *pictures) {
                weakSelf.postEventModel.picUrls = [NSMutableArray arrayWithArray:pictures];
            }showUrls:self.postEventModel.picUrls];
            return cell;
        }
        default: {
        }
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
            return 157;
        }
        case 2: {
            return 45;
        }
        case 3: {
            return 45;
        }
        case 4: {
            return 240;
        }
        default: {
        }
            break;
    }
    return 0.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 2) {
        _selectPicker = [[XPSelectDatePicker alloc] init];
        [_selectPicker loadPickerWithselectDateType:SelectDateTypeOfAfter finishSelectDate:^(NSDate *date) {
            _postEventModel.showBeginDate = [date formattedDateWithFormat:@"yyyy-MM-dd HH:mm"];
            _postEventModel.beginDate = [NSString stringWithFormat:@"%ld", (long)date.timeIntervalSince1970];
            [_myTableView reloadData];
        }];
    } else if(indexPath.row == 3) {
        _selectPicker = [[XPSelectDatePicker alloc] init];
        [_selectPicker loadPickerWithselectDateType:SelectDateTypeOfAfter finishSelectDate:^(NSDate *date) {
            _postEventModel.showEndDate = [date formattedDateWithFormat:@"yyyy-MM-dd HH:mm"];
            _postEventModel.endDate = [NSString stringWithFormat:@"%ld", (long)date.timeIntervalSince1970];
            [_myTableView reloadData];
        }];
    }
}

#pragma mark - Event Responds
- (IBAction)postAction:(id)sender
{
    [self.view endEditing:YES];
    self.postEventViewModel.type = @"2";
    self.postEventViewModel.model = _postEventModel;
    if (self.postEventModel.content.length >= 2000) {
        self.postEventModel.content = [self.postEventModel.content substringToIndex:1999];
    }
    if([NSString verifyEventTitleWithTitle:self.postEventModel.title content:self.postEventModel.content]) {
        [self.postEventViewModel.createCommand execute:nil];
    }
}

#pragma mark -
- (BOOL)navigationShouldPopOnBackButton
{
    [self goBackNeighborhoodList];
    return NO;
}

#pragma mark - Private Methods
- (void)goBackNeighborhoodList
{
    for(UIViewController *vc in self.navigationController.viewControllers) {
        if([vc isKindOfClass:[XPTopicViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

#pragma mark - Getter & Setter

@end
