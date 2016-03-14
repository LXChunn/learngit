//
//  XPMyCollectionViewController.m
//  XPApp
//
//  Created by jy on 16/1/8.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPDetailPostViewController.h"
#import "XPEventDetailViewController.h"
#import "XPMyCollectionViewController.h"
#import "XPMyCollectionViewModel.h"
#import "XPMySecondCollecCell.h"
#import "XPSecondHandCell.h"
#import "XPSecondHandOfPostDetailViewController.h"
#import "XPTopicModel.h"
#import "XPVoteDetailViewController.h"
#import "XPVoteTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "XPSecondHandItemsListModel.h"
#import "XPCommonTableViewCell.h"
#import "XPActivityTableViewCell.h"
#import "XPCommonRefreshHeader.h"
#import "XPCommonRefreshFooter.h"
#import "XPMyOtherFavoriteCell.h"
#import "XPOtherFavoriateModel.h"
#import "XPHousekeepingDetailViewController.h"

@interface XPMyCollectionViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
#pragma clang diagnostic push
@property (strong, nonatomic) IBOutlet XPMyCollectionViewModel *viewModel;

@property (nonatomic,strong)XPTopicModel *secondListModel;
#pragma clang diagnostic pop
@end

@implementation XPMyCollectionViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    @weakify(self);
    if(self.pageIndex == 0) {
        self.viewModel.type = @"1";
    } else if(self.pageIndex == 1){
        self.viewModel.type = @"2";
    } else{
        self.viewModel.type = @"5";
    }
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self showFirstHud];
//    [self rac_liftSelector:@selector(cleverLoader:) withSignals:RACObserve(self.viewModel, executing), nil];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hideFirstHud];
        if(self.viewModel.myCollectArray.count < 1) {
            @strongify(self);
            [self showNonetworkViewWithBlock:^{
                @strongify(self);
                [self.viewModel.myfavoritesCommand execute:nil];
            }];
        }
        return [value localizedDescription];
    }], nil];
    [[RACObserve(self.viewModel, myCollectArray) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hideFirstHud];
        if (self.viewModel.myCollectArray.count < 1)
        {
            [self showNoDataViewWithType:NoDataTypeOfCollection];
            return;
        }
        [self.tableView reloadData];
        [self removeNoNetworkView];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"MyCollecRefreshNotification" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.myfavoritesCommand execute:nil];
        if (self.viewModel.myCollectArray.count == 0) {
            [self showNoDataViewWithType:NoDataTypeOfCollection];
        }
    }];
    [self.viewModel.myfavoritesCommand execute:nil];
    [[RACObserve(self.viewModel, isNoMoreDate) ignore:@(NO)] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
    self.tableView.mj_header = [XPCommonRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.myfavoritesCommand execute:nil];
    }];
    self.tableView.mj_footer = [XPCommonRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.morefavoritesCommand execute:nil];
    }];
}

#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.myCollectArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    tableView.separatorColor = [UIColor clearColor];
    if(self.pageIndex == 0) {
            self.secondListModel = self.viewModel.myCollectArray[indexPath.row];
            switch([_secondListModel.type intValue]) {
                case 1: {
                    XPCommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPCommonTableViewCell"];
                    if(!cell) {
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"XPCommonTableViewCell" owner:nil options:nil] firstObject];
                    }
                    [cell bindModel:self.viewModel.myCollectArray[indexPath.row]];
                    return cell;
                }
                    
                case 2: {
                    XPActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPActivityTableViewCell"];
                    if(!cell) {
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"XPActivityTableViewCell" owner:nil options:nil] firstObject];
                    }
                    [cell hideenForNeighborhood];
                    [cell ForMyCollectBindModel:self.viewModel.myCollectArray[indexPath.row]];
                    [cell ForMyCollecconfigureStatus];
                    return cell;
                }
                    
                case 3: {
                    XPVoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPVoteTableViewCell"];
                    if(!cell) {
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"XPVoteTableViewCell" owner:nil options:nil] firstObject];
                    }
                    [cell hiddenForNeighborhood];
                    [cell bindModel:self.viewModel.myCollectArray[indexPath.row]];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
        }        
        return cell;
    } else if(self.pageIndex == 1){
        
        for (UIView *view in cell.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                [view removeFromSuperview];
            }
        }
        XPMySecondCollecCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPMySecondCollecCell"];
        if(!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"XPMySecondCollecCell" owner:nil options:nil]firstObject];
        }
        if (self.viewModel.myCollectArray.count>0) {
            [cell bindModel:self.viewModel.myCollectArray[indexPath.row]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorColor = [UIColor clearColor];
        return cell;
    }else{
        XPMyOtherFavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyotherFavoriteCell" forIndexPath:indexPath];
        if(!cell) {
            cell = [[XPMyOtherFavoriteCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyotherFavoriteCell"];
        }
        if (self.viewModel.myCollectArray.count>0) {
            [cell bindModel:self.viewModel.myCollectArray[indexPath.row]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorColor = [UIColor clearColor];
        return cell;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.pageIndex == 1) {
        XPSecondHandItemsListModel *model = self.viewModel.myCollectArray[indexPath.row];
        return [XPMySecondCollecCell heightForCell:model.picUrls]-10;
    } else if(self.pageIndex == 0){
        XPTopicModel *model = self.viewModel.myCollectArray[indexPath.row];
        switch([model.type intValue]) {
            case 1: {
                return [XPCommonTableViewCell cellHeightWithArray:model.extra.picUrls];
            }
                
            case 2: {
                return [XPActivityTableViewCell cellHeightWithArray:model.extra.picUrls];
            }
                
            case 3: {
                return 121;
            }
        }
    }else{
        XPOtherFavoriateModel *model = self.viewModel.myCollectArray[indexPath.row];
        return [XPMyOtherFavoriteCell heightForCell:model.picUrls];
    }
    return 180;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.pageIndex == 0) {
        XPTopicModel *topicModel = [self.viewModel.myCollectArray objectAtIndex:indexPath.row];
        switch ([topicModel.type integerValue]) {
            case 1:
            {
                XPDetailPostViewController *controller = (XPDetailPostViewController *)[self instantiateViewControllerWithStoryboardName:@"DetailPost" identifier:@"DetailPost"];
                controller.forumtopicId = topicModel.forumTopicId;
                [self pushViewController:controller];
            }
                break;
            case 2:
            {
                XPEventDetailViewController *controller = (XPEventDetailViewController *)[self instantiateViewControllerWithStoryboardName:@"Event" identifier:@"XPEventDetailViewController"];
                controller.forumtopicId = topicModel.forumTopicId;
                [self pushViewController:controller];
            }
                break;
            case 3:
            {
                XPVoteDetailViewController *controller =(XPVoteDetailViewController *)[self instantiateViewControllerWithStoryboardName:@"Vote" identifier:@"XPVoteDetailViewController"];
                controller.forumtopicId = topicModel.forumTopicId;
                [self pushViewController:controller];
            }
                break;
         }
      }else if(self.pageIndex == 1){
              XPSecondHandItemsListModel *model = self.viewModel.myCollectArray[indexPath.row];
              XPSecondHandOfPostDetailViewController *viewController = (XPSecondHandOfPostDetailViewController *)[self instantiateViewControllerWithStoryboardName:@"SecondHand" identifier:@"XPSecondHandOfPostDetailViewController"];
              viewController.secondHandItemId = model.secondhandItemId;
              [self pushViewController:viewController];
      }else{
        XPOtherFavoriateModel *model = self.viewModel.myCollectArray[indexPath.row];
        XPHousekeepingDetailViewController *controller = (XPHousekeepingDetailViewController *)[self instantiateViewControllerWithStoryboardName:@"HousekeepingNews" identifier:@"XPHousekeepingDetailViewController"];
          controller.housekeepingItemId = model.favoriteItemId;
          [[RACObserve(controller, isChange) ignore:@(NO)] subscribeNext:^(id x) {
              [self.viewModel.myfavoritesCommand execute:nil];
          }];
          [self pushViewController:controller];
      }
}

#pragma mark - Event Responds

#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end
