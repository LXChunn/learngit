//
//  XPTransferOrBuyViewController.m
//  XPApp
//
//  Created by jy on 15/12/29.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "NSString+Verify.h"
#import "UIViewController+BackButtonHandler.h"
#import "XPMyCommentViewController.h"
#import "XPSecondHandViewController.h"
#import "XPTransferOrBuyCommonCell.h"
#import "XPTransferOrBuyOfDescriptionCell.h"
#import "XPTransferOrBuyOfPriceCell.h"
#import "XPTransferOrBuyOfSelectImageCell.h"
#import "XPTransferOrBuyViewController.h"
#import "XPTransferOrBuyViewModel.h"

@interface XPTransferOrBuyViewController ()<UITableViewDelegate, UITableViewDataSource, BackButtonHandlerProtocol>
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic) IBOutlet XPTransferOrBuyViewModel *viewModel;
#pragma clang diagnostic pop

@end

@implementation XPTransferOrBuyViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    @weakify(self);
    [self rac_liftSelector:@selector(cleverLoader:) withSignals:RACObserve(self.viewModel, executing), nil];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        @strongify(self);
        [self hideLoader];
        return [value localizedDescription];
    }], nil];
    [[RACObserve(self.viewModel, successMessage) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self showToast:self.viewModel.successMessage];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshSecondHandListNotification" object:nil];
        [self goSecondHandListAction];
    }];
    [self configure];
}

- (void)configure
{
    self.myTableView.separatorColor = [UIColor clearColor];
    if(!_transferOrBuyModel) {
        _transferOrBuyModel = [[XPTransferOrBuyModel alloc] init];
    }
    if(_secondHandGoodsType == SecondHandGoodsTypeOfTransfer) {
        _navigationItem.title = @"转让";
        _transferOrBuyModel.type = @"1";
    } else if(_secondHandGoodsType == SecondHandGoodsTypeOfBuy) {
        _navigationItem.title = @"求购";
        _transferOrBuyModel.type = @"2";
    }
    [_myTableView reloadData];
}

#pragma mark - TableView Delegate and Datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    switch(indexPath.row) {
        case 0: {
            XPTransferOrBuyCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPTransferOrBuyCommonCell"];
            [cell configureUIWithModel:_transferOrBuyModel type:TransferOrBuyCommonTypeOfTitle block:^(NSString *text) {
                weakSelf.transferOrBuyModel.goodsTitle = text;
            }];
            return cell;
        }
        case 1: {
            XPTransferOrBuyOfDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPTransferOrBuyOfDescriptionCell"];
            [cell configureUIWithModel:_transferOrBuyModel block:^(NSString *text) {
                weakSelf.transferOrBuyModel.goodsDescriptions = text;
            }];
            return cell;
        }
        case 2: {
            XPTransferOrBuyOfPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPTransferOrBuyOfPriceCell"];
            [cell configureUIWithModel:_transferOrBuyModel block:^(NSString *text) {
                weakSelf.transferOrBuyModel.price = text;
            }];
            return cell;
        }
        case 3: {
            XPTransferOrBuyCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPTransferOrBuyCommonCell"];
            [cell configureUIWithModel:_transferOrBuyModel type:TransferOrBuyCommonTypeOfPhone block:^(NSString *text) {
                weakSelf.transferOrBuyModel.mobile = text;
            }];
            return cell;
        }
        case 4: {
            XPTransferOrBuyOfSelectImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPTransferOrBuyOfSelectImageCell"];
            if(!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XPTransferOrBuyOfSelectImageCell" owner:nil options:nil] firstObject];
            }
            [cell whenUploadFinishImage:^(NSArray *pictures) {
                weakSelf.transferOrBuyModel.pictures = [NSMutableArray arrayWithArray:pictures];
            }showUrls:self.transferOrBuyModel.pictures];
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
    if(indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 3) {
        return 44;
    } else if(indexPath.row == 1) {
        return 90;
    }
    return 240;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

#pragma mark - BackButtonHandlerProtocol
- (BOOL)navigationShouldPopOnBackButton
{
    [self goSecondHandListAction];
    return NO;
}

#pragma mark - Event Responds
- (IBAction)postSecondHandGoodsAction:(id)sender
{
    [self.view endEditing:YES];
    if(_secondItemId.length > 0) {
        [self updateSecondHand];
    } else {
        [self postSecondHand];
    }
}

- (void)postSecondHand
{
    if (_transferOrBuyModel.goodsDescriptions.length >= 200) {
        _transferOrBuyModel.goodsDescriptions = [_transferOrBuyModel.goodsDescriptions substringToIndex:199];
    }
    self.viewModel.model = _transferOrBuyModel;
    if([NSString verifyPostSecondHandWithTitle:_transferOrBuyModel.goodsTitle price:_transferOrBuyModel.price mobile:_transferOrBuyModel.mobile content:_transferOrBuyModel.goodsDescriptions]) {
        [self.viewModel.postCommand execute:nil];
    }
}

- (void)updateSecondHand
{
    if (_transferOrBuyModel.goodsDescriptions.length >= 200) {
        _transferOrBuyModel.goodsDescriptions = [_transferOrBuyModel.goodsDescriptions substringToIndex:199];
    }
    self.viewModel.model = _transferOrBuyModel;
    if (_transferOrBuyModel.goodsTitle.length>20) {
        [self showToast:@"宝贝标题最长20个字"];
        return;
    }
    if([NSString verifyPostSecondHandWithTitle:_transferOrBuyModel.goodsTitle price:_transferOrBuyModel.price mobile:_transferOrBuyModel.mobile content:_transferOrBuyModel.goodsDescriptions]) {
        self.viewModel.secodnHandItemId = self.secondItemId;
        [self.viewModel.updateCommand execute:nil];
    }
}

#pragma mark - Private Methods
- (void)goSecondHandListAction
{
    for(UIViewController *vc in self.navigationController.viewControllers) {
        if([vc isKindOfClass:[XPSecondHandViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

#pragma mark - Getter & Setter

@end
