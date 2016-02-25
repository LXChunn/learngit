//
//  XPDetailPostViewController.m
//  XPApp
//
//  Created by iiseeuu on 15/12/30.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPDetailPostViewController.h"
#import "XPDetailPostViewModel.h"
#import "XPDetailPostModel.h"
#import <UITableView+XPKit.h>
#import "XPDetailTitleTableViewCell.h"
#import "XPDetailContentTableViewCell.h"
#import "XPMoreOptionsViewController.h"
#import "XPCreatePostViewController.h"
#import "XPCreatePostViewModel.h"
#import "UIAlertView+XPKit.h"
#import "XPLoginModel.h"

@interface XPDetailPostViewController ()<UITableViewDelegate,UITableViewDataSource,XPOptionsViewControllerDelegate>

@property (strong, nonatomic) IBOutlet XPDetailPostViewModel *detailPostViewModel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *navigaitonBarButtonItem;

@property (nonatomic,strong) XPMoreOptionsViewController *moreOptions;

@end

@implementation XPDetailPostViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self rac_liftSelector:@selector(cleverLoader:) withSignals:RACObserve(self.detailPostViewModel, executing), nil];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.detailPostViewModel, error) ignore:nil] map:^id (id value) {
        return [value localizedDescription];
    }], nil];
    
    @weakify(self);
    [[RACObserve(self.detailPostViewModel, model) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        NSLog(@"数据模型%@",_detailPostViewModel.model );
        [XPLoginModel singleton].userId = self.detailPostViewModel.model.author.userId;
        [self updateNavigationItemUI];
        
        [self.tableView reloadData];
    }];
    
    self.detailPostViewModel.forumtopicId = _forumtopicId;
    [self.detailPostViewModel.detailCommand execute:nil];
    [self.tableView hideEmptySeparators];
}

#pragma mark - Delegate
#pragma mark - UITableView Deleagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            XPDetailTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell" forIndexPath:indexPath];
            [cell bindModel:self.detailPostViewModel.model];
            return cell;
        }else
        {
            XPDetailContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContentCell" forIndexPath:indexPath];
            [cell bindModel:self.detailPostViewModel.model];
            return cell;
        }
    }
    else
    {
        return nil;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 59;
        }else if (indexPath.row == 1){
            return 217;
        }
    }
    
    return 120;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

#pragma mark - XPOptionsViewControllerDelegate

-(void)optionsViewWithDidSelectRow:(NSInteger)row
{
    switch (row) {
        case 0:
        {
            //编辑
            [self editAction];
            break;
        }
       case 1:
        {
            //删除
            [self deleteAction];
            break;
        }
        default:
            break;
    }

}

//传参数 编辑
-(void)editAction
{
    
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Topic" bundle:nil];
    XPCreatePostViewController * viewcontroller = [storyBoard instantiateViewControllerWithIdentifier:@"XPCreatePostViewController"];
    viewcontroller.topicTitle = self.detailPostViewModel.model.title;
    viewcontroller.topicContent = self.detailPostViewModel.model.content;
    NSLog( @"显示内容：%@",self.detailPostViewModel.model.content);
    [self pushViewController:viewcontroller];
}

//删除
-(void)deleteAction
{
    @weakify(self);
    [UIAlertView alertViewWithTitle:@"提示" message:@"是否删除" block:^(NSInteger buttonIndex) {
        if (buttonIndex == 1)
        {
            @strongify(self);
            [[RACObserve(self.detailPostViewModel, isDeleteSuccess) ignore:nil] subscribeNext:^(id x) {
                @strongify(self);
                if (self.detailPostViewModel.isCloseSuccess)
                {
                    [self pop];
                }
            }];
            self.detailPostViewModel.forumtopicId = _forumtopicId;
            [self.detailPostViewModel.detailCommand execute:nil];
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
}

#pragma mark - Event Responds

- (IBAction)navigationButtonAction:(id)sender {
    
    
    if ([[XPLoginModel singleton].userId isEqualToString:self.detailPostViewModel.model.author.userId]) {

        _moreOptions = [[XPMoreOptionsViewController alloc] initWithMoreOptionsWithIcons:@[@"secondhand_edit_ico",@"secondhand_cancel_ico"] titles:@[@"编辑",@"删除"]];
        _moreOptions.delegate = self;
        [_moreOptions show];
        
    }else{
        
        [[RACObserve(self.detailPostViewModel, isCollectionSuccess) ignore:nil] subscribeNext:^(id x) {
//            @strongify(self);
            [self hideLoader];
            if (self.detailPostViewModel.isCollectionSuccess)
            {
                [self updateNavigationItemUI];
            }
        }];
        self.detailPostViewModel.forumtopicId = _forumtopicId;
        [self.detailPostViewModel.collectionCommand execute:nil];
        //收藏

        
    }
    
}

#pragma mark - Private Methods

-(void)updateNavigationItemUI
{
    
    
    if ([[XPLoginModel singleton].userId isEqualToString:self.detailPostViewModel.model.author.userId])
    {
       _navigaitonBarButtonItem.image = [UIImage imageNamed:@"common_navigation_more"];
    }
    else
    {
        if (self.detailPostViewModel.isFavorit)
        {
            _navigaitonBarButtonItem.image = [UIImage imageNamed:@"common_collection_selected"];
        }
        else
        {
            _navigaitonBarButtonItem.image = [UIImage imageNamed:@"common_collection_normal"];
        }
    }

    
    
}


#pragma mark - Getter & Setter

@end 
