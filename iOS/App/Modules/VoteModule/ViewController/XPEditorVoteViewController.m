//
//  XPEditorVoteViewController.m
//  XPApp
//
//  Created by Mac OS on 15/12/30.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "NSString+Verify.h"
#import "UIAlertView+RACSignalSupport.h"
#import "XPEditorVoteAddViewCell.h"
#import "XPEditorVoteTableViewCell.h"
#import "XPEditorVoteViewController.h"
#import "XPReleaseVoteViewController.h"
#import "XPReleaseVoteViewController.h"
#import "XPTopicViewController.h"
#import "XPVoteModel.h"
#import "XPVoteViewModel.h"
#import "XPVoteViewModel.h"

@interface XPEditorVoteViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *optionsArray;
@property (strong, nonatomic) IBOutlet XPVoteViewModel *voteViewModel;

@end

@implementation XPEditorVoteViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    _optionsArray = [NSMutableArray arrayWithArray:@[@"", @"", @""]];
    @weakify(self);
    [[RACObserve(self.voteViewModel, successMessage) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TopicRefreshNotification" object:nil];
        [self backToList];
    }];
    self.tableView.separatorColor = [UIColor clearColor];
}

#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _optionsArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    if(indexPath.row < _optionsArray.count) {
        XPEditorVoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        [cell configureUIWithContent:[_optionsArray objectAtIndex:indexPath.row] deleteBlock:^{
            [weakSelf.view endEditing:YES];
            if(weakSelf.optionsArray.count > 2) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if ([[_optionsArray objectAtIndex:indexPath.row] length] > 0) {
                    [UIAlertView alertViewWithTitle:@"提示" message:@"确定删除当前选项" block:^(NSInteger buttonIndex) {
                        if(buttonIndex == 0) {
                            [strongSelf.optionsArray removeObjectAtIndex:indexPath.row];
                            [strongSelf.tableView reloadData];
                        }
                    }cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                }else{
                    [strongSelf.optionsArray removeObjectAtIndex:indexPath.row];
                    [strongSelf.tableView reloadData];
                }
            } else {
                [self showToast:@"选项不得少于两个"];
            }
        }
                      textInputBlock:^(NSString *text) {
                          if(_optionsArray.count <= 12) {
                              [_optionsArray replaceObjectAtIndex:indexPath.row withObject:text];
                          }
                      }];
        return cell;
    } else {
        XPEditorVoteAddViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPEditorVoteAddViewCell"];
        [cell whenClickAddOptionWithBlock:^{
            if(_optionsArray.count < 12) {
                [_optionsArray addObject:@""];
                [_tableView reloadData];
            } else {
                [self showToast:@"选项最多为12个"];
            }
        }];
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - Event Responds
- (IBAction)postAction:(id)sender
{
    [self.view endEditing:YES];
    if([NSString verifyPostVoteWithOptions:_optionsArray]) {
        self.voteViewModel.title = _voteTitle;
        self.voteViewModel.content = _voteContent;
        self.voteViewModel.type = @"3";
        self.voteViewModel.options = _optionsArray;
        [self.voteViewModel.voteCommand execute:nil];
    }
}

#pragma mark - Private Methods
- (void)backToList
{
    for(UIViewController *vc in self.navigationController.viewControllers) {
        if([vc isKindOfClass:[XPTopicViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

#pragma mark - Getter & Setter

@end