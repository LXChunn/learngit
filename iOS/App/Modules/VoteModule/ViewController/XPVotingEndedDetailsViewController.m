//
//  XPVotingEndedDetailsViewController.m
//  XPApp
//
//  Created by Mac OS on 15/12/30.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPVotingEndedDetailsViewController.h"
#import "XPDetailViewModel.h"
#import "XPVoteModel.h"
#import <UITableView+XPKit.h>
#import "XPInTheVoteTitleViewCell.h"
#import "XPInTheVoteContentViewCell.h"
#import "XPReleaseVoteViewController.h"
#import "XPMoreOptionsViewController.h"
#import "XPVoteViewModel.h"
#import "XPLoginModel.h"
#import "UIAlertView+XPKit.h"


@interface XPVotingEndedDetailsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonItem;
@property (strong, nonatomic) IBOutlet XPDetailViewModel *detailViewModel;

@end

@implementation XPVotingEndedDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self rac_liftSelector:@selector(cleverLoader:) withSignals:RACObserve(self.detailViewModel, executing), nil];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.detailViewModel, error) ignore:nil] map:^id (id value) {
        return [value localizedDescription];
    }], nil];
    
    @weakify(self);
    [[RACObserve(self.detailViewModel, model) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        NSLog(@"数据模型%@",_detailViewModel.model );
        [XPLoginModel singleton].userId = self.detailViewModel.model.author.userId;
        [self updateNavigationItemUI];
        
        [self.tableView reloadData];
    }];
    
    self.detailViewModel.forumtopicId = _forumtopicId;
    [self.detailViewModel.detailCommand execute:nil];
    [self.tableView hideEmptySeparators];

}
#pragma mark - Delegate

#pragma mark - Event Responds
- (IBAction)navigationButtonAction:(UIButton *)sender
{
    [[RACObserve(self.detailViewModel, isCollectionSuccess) ignore:nil] subscribeNext:^(id x) {
//        @strongify(self);
        [self hideLoader];
        if (self.detailViewModel.isCollectionSuccess)
        {
            [self updateNavigationItemUI];
        }
    }];
    self.detailViewModel.forumtopicId = _forumtopicId;
    [self.detailViewModel.collectionCommand execute:nil];
    

}

#pragma mark - Private Methods
-(void)updateNavigationItemUI
{
    if ([[XPLoginModel singleton].userId isEqualToString:self.detailViewModel.model.author.userId])
    {
        _barButtonItem.image = [UIImage imageNamed:@"common_navigation_more"];
    }
    else
    {
        if (self.detailViewModel.isFavorit)
        {
            _barButtonItem.image = [UIImage imageNamed:@"common_collection_selected"];
        }
        else
        {
            _barButtonItem.image = [UIImage imageNamed:@"common_collection_normal"];
        }
    }
}
#pragma mark - Getter & Setter

@end
