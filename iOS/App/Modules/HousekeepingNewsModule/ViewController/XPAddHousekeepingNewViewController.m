//
//  XPAddHousekeepingNewViewController.m
//  XPApp
//
//  Created by jy on 16/2/22.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPAddHousekeepingNewViewController.h"
#import "XPCommonTitleCell.h"
#import "XPTransferOrBuyOfSelectImageCell.h"
#import "XPTextView.h"
#import "XPAddHousekeepingOfContentCell.h"
#import "NSString+Verify.h"
#import "XPPostHousekeepingViewModel.h"
#import "UIViewController+BackButtonHandler.h"
#import "XPHousekeepingNewsViewController.h"
#import "XPSecondHandViewController.h"

@interface XPAddHousekeepingNewViewController ()<UITableViewDelegate,UITableViewDataSource,BackButtonHandlerProtocol>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet XPPostHousekeepingViewModel *postHousekeepingViewModel;

@end

@implementation XPAddHousekeepingNewViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    @weakify(self);
    [self rac_liftSelector:@selector(cleverLoader:) withSignals:RACObserve(self.postHousekeepingViewModel, executing), nil];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.postHousekeepingViewModel, error) ignore:nil] map:^id (id value) {
        @strongify(self);
        [self hideLoader];
        return [value localizedDescription];
    }], nil];
    [[RACObserve(self.postHousekeepingViewModel, successMessage) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self showToast:self.postHousekeepingViewModel.successMessage];
        self.isChange = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshHousekeepingListNotification" object:nil];
        [self goHousekeepingList];
    }];
    if (!_housekeepingModel) {
        _housekeepingModel = [[XPAddHousekeepingModel alloc] init];
    }
}

#pragma mark - Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.row) {
        case 0: {
            XPCommonTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPCommonTitleCell"];
            if(!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XPCommonTitleCell" owner:nil options:nil] firstObject];
            }
            [cell configureUIWithTitle:_housekeepingModel.title placeholder:@"请输入标题（1-20个字）" block:^(NSString *text) {
                _housekeepingModel.title = text;
            }];
            return cell;
        }
        case 1: {
            XPAddHousekeepingOfContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPAddHousekeepingOfContentCell"];
            cell.contentTextView.text = _housekeepingModel.content;
            cell.contentTextView.font = [UIFont systemFontOfSize:16];
            [cell.contentTextView.rac_textSignal subscribeNext:^(NSString * x) {
                _housekeepingModel.content = x;
            }];
            return cell;
        }
        case 2: {
            XPCommonTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPCommonTitleCell"];
            if(!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XPCommonTitleCell" owner:nil options:nil] firstObject];
            }
            [cell configureUIWithTitle:_housekeepingModel.phone placeholder:@"请输入手机号（选填）" block:^(NSString *text) {
                _housekeepingModel.phone = text;
            }];
            return cell;
        }
        case 3: {
            XPTransferOrBuyOfSelectImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPTransferOrBuyOfSelectImageCell"];
            if(!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XPTransferOrBuyOfSelectImageCell" owner:nil options:nil] firstObject];
            }
            [cell whenUploadFinishImage:^(NSArray *pictures) {
                _housekeepingModel.pictureUrls = [NSMutableArray arrayWithArray:pictures];
            }showUrls:_housekeepingModel.pictureUrls];
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
    if(indexPath.row == 0 || indexPath.row == 2) {
        return 44;
    } else if(indexPath.row == 1) {
        return 153;
    }
    return 240;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

#pragma mark - BackButtonHandlerProtocol
- (BOOL)navigationShouldPopOnBackButton
{
    [self goHousekeepingList];
    return NO;
}

#pragma mark - Event Responds
- (IBAction)postAction:(id)sender {
    [self.view endEditing:YES];
    if (_housekeepingModel.content.length >= 200) {
        _housekeepingModel.content = [_housekeepingModel.content substringToIndex:199];
    }
    self.postHousekeepingViewModel.model = _housekeepingModel;
    if (_housekeepingItemId.length < 1) {
        [self postHousekeeping];
    }else{
        [self updateHousekeeping];
    }
}

#pragma mark - Private Methods
- (void)postHousekeeping{
    if ([NSString verifyHousekeepingWith:_housekeepingModel.title content:_housekeepingModel.content mobile:_housekeepingModel.phone]) {
        [self.postHousekeepingViewModel.postCommand execute:nil];
    }
}

- (void)updateHousekeeping{
    if ([NSString verifyHousekeepingWith:_housekeepingModel.title content:_housekeepingModel.content mobile:_housekeepingModel.phone]) {
        self.postHousekeepingViewModel.housekeepingItemId = _housekeepingItemId;
        [self.postHousekeepingViewModel.updateCommand execute:nil];
    }
}

- (void)goHousekeepingList{
    for(UIViewController *vc in self.navigationController.viewControllers) {
        if([vc isKindOfClass:[XPHousekeepingNewsViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }else if ([vc isKindOfClass:[XPSecondHandViewController class]]){
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

#pragma mark - Getter & Setter

@end 
