//
//  XPTransferOrBuyViewController.m
//  XPApp
//
//  Created by jy on 15/12/29.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPTransferOrBuyViewController.h"
#import "XPTransferOrBuyCommonCell.h"
#import "XPTransferOrBuyOfPriceCell.h"
#import "XPTransferOrBuyOfSelectImageCell.h"
#import "XPTransferOrBuyOfDescriptionCell.h"
#import "XPTransferOrBuyViewModel.h"
#import "XPSecondHandViewController.h"

@interface XPTransferOrBuyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic) IBOutlet XPTransferOrBuyViewModel *viewModel;


@end

@implementation XPTransferOrBuyViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self rac_liftSelector:@selector(cleverLoader:) withSignals:RACObserve(self.viewModel, executing), nil];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        return [value localizedDescription];
    }], nil];
    [self configure];
}

- (void)configure
{
    if (!_transferOrBuyModel)
    {
        _transferOrBuyModel = [[XPTransferOrBuyModel alloc] init];
    }
    if (_secondHandGoodsType == SecondHandGoodsTypeOfTransfer)
    {
        _navigationItem.title = @"转让";
        _transferOrBuyModel.type = @"1";
    }
    else if (_secondHandGoodsType == SecondHandGoodsTypeOfBuy)
    {
        _navigationItem.title = @"求购";
        _transferOrBuyModel.type = @"2";
    }
    [_myTableView reloadData];
}

#pragma mark - TableView Delegate and Datasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    switch (indexPath.row)
    {
        case 0:
        {
            XPTransferOrBuyCommonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"XPTransferOrBuyCommonCell"];
            [cell configureUIWithModel:_transferOrBuyModel type:TransferOrBuyCommonTypeOfTitle block:^(NSString *text) {
                weakSelf.transferOrBuyModel.goodsTitle = text;
            }];
            return cell;
        }
        case 1:
        {
            XPTransferOrBuyOfDescriptionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"XPTransferOrBuyOfDescriptionCell"];
            [cell configureUIWithModel:_transferOrBuyModel block:^(NSString *text) {
                weakSelf.transferOrBuyModel.goodsDescriptions = text;
            }];
            return cell;
        }
        case 2:
        {
            XPTransferOrBuyOfPriceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"XPTransferOrBuyOfPriceCell"];
            [cell configureUIWithModel:_transferOrBuyModel block:^(NSString *text) {
                weakSelf.transferOrBuyModel.price = text;
            }];
            return cell;
        }
        case 3:
        {
            XPTransferOrBuyCommonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"XPTransferOrBuyCommonCell"];
            [cell configureUIWithModel:_transferOrBuyModel type:TransferOrBuyCommonTypeOfPhone block:^(NSString *text) {
                weakSelf.transferOrBuyModel.mobile = text;
            }];
            return cell;
        }
        case 4:
        {
            XPTransferOrBuyOfSelectImageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"XPTransferOrBuyOfSelectImageCell"];
            [cell whenUploadFinishImage:^(NSArray *pictures) {
                weakSelf.transferOrBuyModel.pictures = [NSMutableArray arrayWithArray:pictures];
            }];
            return cell;
        }
        default:
            break;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 2|| indexPath.row == 3)
    {
        return 44;
    }
    else if (indexPath.row == 1)
    {
        return 90;
    }
    return 240;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Event Responds
- (IBAction)postSecondHandGoodsAction:(id)sender
{
    [self.view endEditing:YES];
    @weakify(self);
    [[RACObserve(self.viewModel, successMsg) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self showToast:self.viewModel.successMsg];
        [self goSecondHandListAction];
    }];
    self.viewModel.model = _transferOrBuyModel;
    if (_transferOrBuyModel.goodsTitle.length < 1)
    {
        [self showToast:@"请输入宝贝标题"];
        return;
    }
    [self.viewModel.postCommand execute:nil];
}

#pragma mark - Private Methods
#warning 少一个截取返回操作的方法

- (void)goSecondHandListAction
{
    for (UIViewController * vc in self.navigationController.viewControllers)
    {
        if ([vc isKindOfClass:[XPSecondHandViewController class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

#pragma mark - Getter & Setter

@end 
