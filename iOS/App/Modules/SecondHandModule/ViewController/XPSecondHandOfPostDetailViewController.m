//
//  XPSecondHandOfPostDetailViewController.m
//  XPApp
//
//  Created by jy on 15/12/30.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPSecondHandOfPostDetailViewController.h"
#import "XPSecondHandDetailViewModel.h"
#import "MJRefresh.h"
#import "XPSecondHandDetailOfUserCell.h"
#import "XPSecondHandDetailOfDescriptionCell.h"
#import "UIView+HESizeHeight.h"
#import "XPLoginModel.h"
#import "XPMoreOptionsViewController.h"
#import "XPTransferOrBuyViewController.h"
#import "UIAlertView+XPKit.h"
#import "XPTransferOrBuyModel.h"

#define BoundsWidth [UIScreen mainScreen].bounds.size.width
@interface XPSecondHandOfPostDetailViewController ()<UITableViewDelegate,UITableViewDataSource,XPOptionsViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic) IBOutlet XPSecondHandDetailViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightNavigationItem;
@property (nonatomic,strong) XPMoreOptionsViewController *moreOptions;

@end

@implementation XPSecondHandOfPostDetailViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self rac_liftSelector:@selector(cleverLoader:) withSignals:RACObserve(self.viewModel, executing), nil];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        [self.myTableView.mj_header endRefreshing];
        return [value localizedDescription];
    }], nil];
    @weakify(self);
    [[RACObserve(self.viewModel, detailModel) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [XPLoginModel singleton].userId = self.viewModel.detailModel.author.userId;
        [self updateNavigationItemUI];
        [self.myTableView reloadData];
        [self.myTableView.mj_header endRefreshing];
    }];
    self.viewModel.secondHandItemId = _secondHandItemId;
    [self.viewModel.detailCommand execute:nil];
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.detailCommand execute:nil];
    }];
}

#pragma mark - Delegate
#pragma mark - tableviewDelegateAndDatasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            XPSecondHandDetailOfUserCell * cell = [tableView dequeueReusableCellWithIdentifier:@"XPSecondHandDetailOfUserCell"];
            [cell bindModel:self.viewModel.detailModel];
            return cell;
        }
        else if (indexPath.row == 1)
        {
            XPSecondHandDetailOfDescriptionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"XPSecondHandDetailOfDescriptionCell"];
            [cell bindModel:self.viewModel.detailModel];
            return cell;
        }
        else
        {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"XPSecondHandDetailOfContentCell"];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XPSecondHandDetailOfContentCell"];
            }
            UILabel * label = (UILabel *)[cell.contentView viewWithTag:100];
            label.text = self.viewModel.detailModel.content;
            return cell;
        }
    }
    else
    {
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            return 67;
        }
        else if (indexPath.row == 1)
        {
            float titleHeight = [UIView getTextSizeHeight:self.viewModel.detailModel.title font:16 withSize:CGSizeMake(BoundsWidth - 44, MAXFLOAT)];
            if (self.viewModel.detailModel.picUrls.count < 1)
            {
                return 53 + titleHeight;
            }
            return 180 + titleHeight;
        }
        else if (indexPath.row == 2)
        {
            float contentHeight = [UIView getTextSizeHeight:self.viewModel.detailModel.content font:16 withSize:CGSizeMake(BoundsWidth - 40, MAXFLOAT)];
            return 26 + contentHeight;
        }
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (!self.viewModel.detailModel)
        {
            return 0;
        }
        return 3;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

#pragma mark - XPOptionsViewControllerDelegate
- (void)optionsViewWithDidSelectRow:(NSInteger)row
{
    if ([self.viewModel.detailModel.status isEqualToString:@"1"])
    {
        switch (row) {
            case 0:
            {
            //编辑
                [self editeAction];
                break;
            }
            case 1:
            {
            //完成
                [self closeAction];
                break;
            }
            case 2:
            {
                [self deleteAction];
            }
            default:
                break;
        }
    }
    else
    {
        if (row == 0)
        {
            [self deleteAction];
        }
    }
}

#pragma mark - Event Responds
- (void)editeAction
{
    XPTransferOrBuyViewController * viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"XPTransferOrBuyViewController"];
    XPTransferOrBuyModel * model = [[XPTransferOrBuyModel alloc] init];
    model.goodsTitle = self.viewModel.detailModel.title;
    model.goodsDescriptions = self.viewModel.detailModel.content;
    model.price = self.viewModel.detailModel.price;
    model.mobile = self.viewModel.detailModel.mobile;
    model.pictures = [NSMutableArray arrayWithArray:self.viewModel.detailModel.picUrls];
    model.type = self.viewModel.detailModel.type;
    viewController.transferOrBuyModel = model;
    if ([self.viewModel.detailModel.type isEqualToString:@"1"])
    {
        viewController.secondHandGoodsType = SecondHandGoodsTypeOfTransfer;
    }
    else if ([self.viewModel.detailModel.type isEqualToString:@"2"])
    {
        viewController.secondHandGoodsType = SecondHandGoodsTypeOfBuy;
    }

    [self pushViewController:viewController];
}

- (void)deleteAction
{
    @weakify(self);
    [UIAlertView alertViewWithTitle:@"提示" message:@"是否取消交易" block:^(NSInteger buttonIndex) {
        if (buttonIndex == 1)
        {
            @strongify(self);
            [[RACObserve(self.viewModel, isDeleteSuccess) ignore:nil] subscribeNext:^(id x) {
                @strongify(self);
                [self hideLoader];
                if (self.viewModel.isDeleteSuccess)
                {
                    [self pop];
                }
            }];
            self.viewModel.secondHandItemId = _secondHandItemId;
            [self.viewModel.deleteCommand execute:nil];
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
}

- (void)closeAction
{
    @weakify(self);
    [UIAlertView alertViewWithTitle:@"提示" message:@"是否完成交易" block:^(NSInteger buttonIndex) {
        if (buttonIndex == 1)
        {
            @strongify(self);
            [[RACObserve(self.viewModel, isCloseSuccess) ignore:@(NO)] subscribeNext:^(id x) {
                @strongify(self);
                [self hideLoader];
                [self pop];
            }];
            self.viewModel.secondHandItemId = _secondHandItemId;
            [self.viewModel.closeCommand execute:nil];
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
}

- (IBAction)clickRightNavigationItemAction:(id)sender
{
    @weakify(self);
    if ([self.viewModel.detailModel.author.userId isEqualToString:[XPLoginModel singleton].userId])
    {
        if ([self.viewModel.detailModel.status isEqualToString:@"1"])
        {
            _moreOptions = [[XPMoreOptionsViewController alloc] initWithMoreOptionsWithIcons:@[@"secondhand_edit_ico",@"secondhand_complete_ico",@"secondhand_cancel_ico"] titles:@[@"编辑交易",@"完成交易",@"取消交易"]];
            _moreOptions.delegate = self;
            [_moreOptions show];
        }
        else
        {
            _moreOptions = [[XPMoreOptionsViewController alloc] initWithMoreOptionsWithIcons:@[@"secondhand_cancel_ico"] titles:@[@"取消交易"]];
            _moreOptions.delegate = self;
            [_moreOptions show];
        }
    }
    else
    {
        [[RACObserve(self.viewModel, isCollectionSuccess) ignore:@(NO)] subscribeNext:^(id x) {
            @strongify(self);
            [self hideLoader];
            [self updateNavigationItemUI];
        }];
        self.viewModel.type = 2;
        self.viewModel.secondHandItemId = _secondHandItemId;
        [self.viewModel.collectionCommand execute:nil];
        //收藏
    }
}

#pragma mark - Private Methods
- (void)updateNavigationItemUI
{
    if ([self.viewModel.detailModel.author.userId isEqualToString:[XPLoginModel singleton].userId])
    {
        _rightNavigationItem.image = [UIImage imageNamed:@"common_navigation_more"];
    }
    else
    {
        if (self.viewModel.isFavorite)
        {
            _rightNavigationItem.image = [UIImage imageNamed:@"common_collection_selected"];
        }
        else
        {
            _rightNavigationItem.image = [UIImage imageNamed:@"common_collection_normal"];
        }
    }
}

#pragma mark - Getter & Setter

@end 
