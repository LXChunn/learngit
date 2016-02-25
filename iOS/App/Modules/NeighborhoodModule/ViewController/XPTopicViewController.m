//
//  XPTopicViewController.m
//  XPApp
//
//  Created by iiseeuu on 15/12/29.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPTopicViewController.h"
#import "XPMoreOptionsViewController.h"
#import "XPTopicModel.h"
#import "XPTopicViewModel.h"
#import <UITableView+XPKit.h>
#import <MJRefresh/MJRefresh.h>
#import "XPCommonTableViewCell.h"
#import "XPActivityTableViewCell.h"
#import "XPVoteTableViewCell.h"
#import "XPCreatePostViewController.h"
#import "XPDetailPostViewController.h"
#import "XPReleaseVoteViewController.h"

@interface XPTopicViewController ()<XPOptionsViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic) IBOutlet XPTopicViewModel *topicViewModel;
#pragma clang diagnostic pop
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)XPTopicModel *topicModel;
@property(nonatomic,strong)XPMoreOptionsViewController *optionsViewController;

@end


@implementation XPTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
//    [self rac_liftSelector:@selector(cleverLoader:) withSignals:RACObserve(self.viewModel, executing), nil];
//    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
//        return [value localizedDescription];
//    }], nil];
    
    @weakify(self);
    [[RACObserve(self.topicViewModel, forumTopic) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    [self.topicViewModel.topicCommand execute:nil];
    [self.tableView hideEmptySeparators];
    

}


#pragma mark - Delegate
-(void)optionsViewWithDidSelectRow:(NSInteger)row
{
    switch (row) {
        case 0:
        {
            UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Topic" bundle:nil];
            XPCreatePostViewController * viewcontroller = [storyBoard instantiateViewControllerWithIdentifier:@"XPCreatePostViewController"];
            
            [self pushViewController:viewcontroller];
            break;
        }
        case 1:
        {
            break;
        }

        case 2:
        {
            UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Vote" bundle:nil];
            XPReleaseVoteViewController * viewcontroller = [storyBoard instantiateViewControllerWithIdentifier:@"XPReleaseVoteViewController"];
            
            [self pushViewController:viewcontroller];
            break;
        }
        default:
            break;
    }
}

#pragma mark - UITableView Deleagate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"数组的长度:%ld",self.topicViewModel.forumTopic.count);
    return self.topicViewModel.forumTopic.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  self.topicModel = self.topicViewModel.forumTopic[indexPath.row];
    
    switch ([_topicModel.type intValue]) {
        case 1:{
            XPCommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CoCell" forIndexPath:indexPath];
            [cell bindModel:self.topicViewModel.forumTopic[indexPath.row]];
            return cell;}
           
        case 2:
        {
            XPActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AcCell" forIndexPath:indexPath];
            [cell bindModel:self.topicViewModel.forumTopic[indexPath.row]];
            return  cell;}
           
        case 3:
        {
            XPVoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VoCell" forIndexPath:indexPath];
            [cell bindModel:self.topicViewModel.forumTopic[indexPath.row]];
               cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return  cell;
        }
           
        default:
            break;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch ([_topicModel.type intValue]) {
        case 1:{
            return 188;}
            break;
        case 2:
        {
            return 221 ;}
            break;
        case 3:
        {
            return  121;}
            break;
    }

    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"DetailPost" bundle:nil];
    XPDetailPostViewController * detailViewController = [storyBoard instantiateViewControllerWithIdentifier:@"DetailPost"];
    
    detailViewController.forumtopicId = self.topicModel.forumTopicId;
    detailViewController.userId = self.topicModel.author.userId;
    
    [self pushViewController:detailViewController];
}

#pragma mark - Event Responds
- (IBAction)addMoreAction:(id)sender
{
    _optionsViewController = [[XPMoreOptionsViewController alloc]initWithMoreOptionsWithIcons:@[@"neighborhood_publish_ico",@"neighborhood_activity_ico",@"neighborhood_vote_ico"] titles:@[@"发起帖子",@"发起活动",@"发起投票"]];
    _optionsViewController.delegate = self;
    [_optionsViewController show];
}

#pragma mark - Private Methods

#pragma mark - Getter & Setter

#pragma mark - Getter & Setter

@end
