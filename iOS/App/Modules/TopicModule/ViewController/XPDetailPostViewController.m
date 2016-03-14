//
//  XPDetailPostViewController.m
//  XPApp
//
//  Created by iiseeuu on 15/12/30.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "MJRefresh.h"
#import "NSDate+DateTools.h"
#import "NSString+Category.h"
#import "NSString+Verify.h"
#import "UIAlertView+XPKit.h"
#import "UIColor+XPKit.h"
#import "UIView+HESizeHeight.h"
#import "UIView+block.h"
#import "XPCommonCommentCell.h"
#import "XPCommonCommentViewModel.h"
#import "XPCreatePostViewModel.h"
#import "XPDetailContentTableViewCell.h"
#import "XPDetailPostModel.h"
#import "XPDetailPostViewController.h"
#import "XPDetailPostViewModel.h"
#import "XPDetailTitleTableViewCell.h"
#import "XPLoginModel.h"
#import "XPMoreOptionsViewController.h"
#import "XPSecondHandCommentsModel.h"
#import "XPSecondHandReplyModel.h"
#import <UITableView+XPKit.h>
#import <UIImageView+WebCache.h>
#import "XPCommonRefreshHeader.h"
#import "XPCommonRefreshFooter.h"
#import "UITextField+XPLimitLength.h"

#define BoundsWidth [UIScreen mainScreen].bounds.size.width

@interface XPDetailPostViewController ()<UITableViewDelegate, UITableViewDataSource, XPOptionsViewControllerDelegate, UITextFieldDelegate>
{
    BOOL _isMine;
    NSString *_selectCommentIndexStr;
}
@property (strong, nonatomic) IBOutlet XPCommonCommentViewModel *commentViewModel;
@property (strong, nonatomic) IBOutlet XPDetailPostViewModel *detailPostViewModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *navigaitonBarButtonItem;
@property (nonatomic, strong) XPMoreOptionsViewController *moreOptions;
@property (weak, nonatomic) IBOutlet UITextField *commentInputTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendViewBottomLayoutConstraint;

@end

@implementation XPDetailPostViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showFirstHud];
    [self.commentInputTextField rac_textSignalWithLimitLength:200];
    @weakify(self);
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.detailPostViewModel, error) ignore:nil] map:^id (id value) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hideFirstHud];
        [self hideLoader];
        return [value localizedDescription];
    }], nil];
    [[RACObserve(self.detailPostViewModel, model) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        if([[XPLoginModel singleton].userId isEqualToString:self.detailPostViewModel.model.author.userId]) {
            _isMine = YES;
            _navigaitonBarButtonItem.image = [UIImage imageNamed:@"common_navigation_more"];
        }
        [self.tableView reloadData];
        [self hideFirstHud];
        self.commentViewModel.commentCount = self.detailPostViewModel.model.commentsCount;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    self.detailPostViewModel.forumtopicId = _forumtopicId;
    [self.detailPostViewModel.detailCommand execute:nil];
    [[RACObserve(self.commentViewModel, commentsList)ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
        [self hideFirstHud];
        [self hideLoader];
        _commentInputTextField.text = @"";
        _commentInputTextField.placeholder = @"评论";
        _selectCommentIndexStr = nil;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    self.commentViewModel.forumtopicId = _forumtopicId;
    [self.commentViewModel.reloadCommentsCommand execute:nil];
    [[RACObserve(self.commentViewModel, isNoMoreDate) ignore:@(NO)] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
    self.tableView.mj_header = [XPCommonRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.commentViewModel.reloadCommentsCommand execute:nil];
        [self.detailPostViewModel.detailCommand execute:nil];
    }];
    self.tableView.mj_footer = [XPCommonRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.commentViewModel.moreCommentsCommand execute:nil];
    }];
    [[RACObserve(self.detailPostViewModel, isDeleteSuccess) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self hideLoader];
        if(self.detailPostViewModel.isDeleteSuccess) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TopicRefreshNotification" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MyPostRefreshNotification" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MyCommentRefreshNotification" object:nil];
            [self pop];
        }
    }];
    [RACObserve(self.detailPostViewModel, isFavorit) subscribeNext:^(id x)
     {
         @strongify(self);
         if (_isMine) {
             return;
         }
         [self hideLoader];
         if(self.detailPostViewModel.isFavorit) {
             self.navigaitonBarButtonItem.image = [[UIImage imageNamed:@"common_collection_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
         } else {
             self.navigaitonBarButtonItem.image = [[UIImage imageNamed:@"common_collection_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
         }
     }];
    [self registerForKeyboardNotifications];
    self.tableView.separatorColor = [UIColor clearColor];
}

#pragma mark - Delegate
#pragma mark - UITableView Deleagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return 2;
    } else if(section == 1) {
        return 0;
    } else {
        XPSecondHandCommentsModel *model = [self.commentViewModel.commentsList objectAtIndex:section - 2];
        return model.replies.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            XPDetailTitleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"XPDetailTitleTableViewCell"];
            [cell bindModel:self.detailPostViewModel.model];
            [cell whenClickAvatorWithBlock:^{
                [weakSelf goOtherUserInfoCenterWithModel:self.detailPostViewModel.model.author];
            }];
            return cell;
        } else {
            XPDetailContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPDetailContentTableViewCell"];
            [cell bindModel:self.detailPostViewModel.model];
            return cell;
        }
    } else if(indexPath.section > 1) {
        XPSecondHandCommentsModel *model = [self.commentViewModel.commentsList objectAtIndex:indexPath.section - 2];
        [model loadReplyDictionary];
        XPSecondHandReplyModel *replyModel = [model.replies objectAtIndex:indexPath.row];
        XPCommonCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPCommonCommentCell"];
        if(!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"XPCommonCommentCell" owner:nil options:nil] firstObject];
        }
        [cell configureUIWithName:replyModel.author.nickname content:replyModel.content];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            return 59;
        } else if(indexPath.row == 1) {
            float titleHeight = [UIView getTextSizeHeight:self.detailPostViewModel.model.title font:16 withSize:CGSizeMake(BoundsWidth - 25, MAXFLOAT)];
            float contentHeight = [UIView getTextSizeHeight:self.detailPostViewModel.model.content font:14 withSize:CGSizeMake(BoundsWidth - 25, MAXFLOAT)];
            if(self.detailPostViewModel.model.extra.picUrls.count < 1) {
                return 9 + 15 + 16 + titleHeight + contentHeight;
            }
            return titleHeight +contentHeight + 9 + 15 + 110 + 16 + 15;
        }
    } else if(indexPath.section == 1) {
        return 0.001f;
    } else {
        XPSecondHandCommentsModel *model = [self.commentViewModel.commentsList objectAtIndex:indexPath.section - 2];
        [model loadReplyDictionary];
        XPSecondHandReplyModel *replyModel = [model.replies objectAtIndex:indexPath.row];
        float contentHeight = [UIView getTextSizeHeight:[NSString stringWithFormat:@"%@：%@", replyModel.author.nickname, replyModel.content] font:12 withSize:CGSizeMake(BoundsWidth - 67, MAXFLOAT)];
        return contentHeight + 10;
    }
    
    return 0.001f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.commentViewModel.commentsList.count + 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return 0.0001f;
    } else if(section == 1) {
        return 63.0f;
    } else {
        XPSecondHandCommentsModel *model = [self.commentViewModel.commentsList objectAtIndex:section - 2];
        float contentHeight = [UIView getTextSizeHeight:model.content font:14 withSize:CGSizeMake(BoundsWidth - 66, MAXFLOAT)];
        return 73 + contentHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BoundsWidth, 63)];
        view.backgroundColor = [UIColor colorWithHex:0xececec];
        UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, BoundsWidth, 48)];
        commentView.backgroundColor = [UIColor whiteColor];
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 30, 48)];
        commentLabel.textColor = [UIColor colorWithHex:0x474747];
        commentLabel.font = [UIFont systemFontOfSize:14];
        commentLabel.text = @"评论";
        [commentView addSubview:commentLabel];
        UILabel *commentsCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, 0, 100, 48)];
        commentsCountLabel.textColor = [UIColor colorWithHex:0x949494];
        commentsCountLabel.text = [@(self.commentViewModel.commentCount)stringValue];
        commentsCountLabel.font = [UIFont systemFontOfSize:14];
        [commentView addSubview:commentsCountLabel];
        [view addSubview:commentView];
        return view;
    } else if(section > 1) {
        __weak typeof(self
                      ) weakSelf = self;
        if(self.commentViewModel.commentsList.count < 1) {
            return nil;
        }
        
        XPSecondHandCommentsModel *model = [self.commentViewModel.commentsList objectAtIndex:section - 2];
        float contentHeight = [UIView getTextSizeHeight:model.content font:14 withSize:CGSizeMake(BoundsWidth - 66, MAXFLOAT)];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BoundsWidth, 73 + contentHeight)];
        view.backgroundColor = [UIColor whiteColor];
        {
            UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, BoundsWidth - 26, 1)];
            lineLabel.backgroundColor = [UIColor colorWithHex:0xD4D4D4];
            [view addSubview:lineLabel];
        }
        {
            UIImageView *avatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(19, 10, 34, 34)];
            avatorImageView.layer.masksToBounds = YES;
            avatorImageView.layer.cornerRadius = 17;
            avatorImageView.userInteractionEnabled = YES;
            avatorImageView.clipsToBounds = YES;
            avatorImageView.contentMode = UIViewContentModeScaleAspectFill;
            [avatorImageView whenTapped:^{
                [weakSelf goOtherUserInfoCenterWithModel:model.author];
            }];
            [avatorImageView sd_setImageWithURL:[NSURL URLWithString:model.author.avatarUrl] placeholderImage:[UIImage imageNamed:@"common_default_avatar"]];
            [view addSubview:avatorImageView];
        }
        {
            UILabel *nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(57, 10, 200, 16)];
            nickNameLabel.textColor = [UIColor colorWithHex:0x474747];
            nickNameLabel.text = model.author.nickname;
            nickNameLabel.font = [UIFont systemFontOfSize:12];
            [view addSubview:nickNameLabel];
        }
        {
            UILabel *timelabel = [[UILabel alloc] initWithFrame:CGRectMake(57, 34, 200, 16)];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.createdAt doubleValue]];
            timelabel.text = [date formattedDateWithFormat:@"YYYY-MM-dd  hh:mm"];
            timelabel.font = [UIFont systemFontOfSize:12];
            timelabel.textColor = [UIColor colorWithHex:0x878787];
            [view addSubview:timelabel];
        }
        {
            UIButton *replyButon = [[UIButton alloc] initWithFrame:CGRectMake(BoundsWidth - 60, -10, 60, 60)];
            [replyButon setImage:[UIImage imageNamed:@"common_comment_normal"] forState:UIControlStateNormal];
            [replyButon setImage:[UIImage imageNamed:@"common_comment_clicked"] forState:UIControlStateHighlighted];
            __weak typeof(self) weakSelf = self;
            [[replyButon rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                _selectCommentIndexStr = [@(section - 2)stringValue];
                [weakSelf.commentInputTextField becomeFirstResponder];
            }];
            [view addSubview:replyButon];
        }
        {
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, 55, BoundsWidth - 66, contentHeight)];
            contentLabel.text = model.content;
            contentLabel.numberOfLines = 0;
            contentLabel.textColor = [UIColor colorWithHex:0x474747];
            contentLabel.font = [UIFont systemFontOfSize:14];
            [view addSubview:contentLabel];
        }
        return view;
    }
    
    return nil;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(!_selectCommentIndexStr){
        _commentInputTextField.placeholder = @"评论";
    } else {
        _commentInputTextField.placeholder = @"回复评论";
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_commentInputTextField resignFirstResponder];
    [self sendActionWithText:textField.text];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [_commentInputTextField resignFirstResponder];
    [self sendActionWithText:textField.text];
}

#pragma mark - XPOptionsViewControllerDelegate
- (void)optionsViewController:(XPMoreOptionsViewController *)optionsViewController didSelectRow:(NSInteger)row
{
    switch(row) {
        case 0: {
            //编辑
            [self editAction];
            break;
        }
            
        case 1: {
            //删除
            [self deleteAction];
            break;
        }
            
        default: {
        }
            break;
    }
}

//传参数 编辑
- (void)editAction
{
    UIViewController *viewController = [self instantiateViewControllerWithStoryboardName:@"Topic" identifier:@"XPCreatePostViewController"];
    XPCreatePostViewController *createVC = (XPCreatePostViewController *)viewController;
    XPTransferOrBuyModel *model = [[XPTransferOrBuyModel alloc] init];
    model.goodsTitle = self.detailPostViewModel.model.title;
    model.goodsDescriptions = self.detailPostViewModel.model.content;
    model.pictures = [NSMutableArray arrayWithArray:self.detailPostViewModel.model.extra.picUrls];
    createVC.pushFromType = _pushFromType;
    createVC.forumTopicModel = model;
    createVC.forumTopicId = _forumtopicId;
    [self pushViewController:createVC];
}

//删除
- (void)deleteAction
{
    @weakify(self);
    [UIAlertView alertViewWithTitle:@"提示" message:@"确定删除？" block:^(NSInteger buttonIndex) {
        if(buttonIndex == 0) {
            @strongify(self);
            [self showLoader];
            [self.detailPostViewModel.deleteCommand execute:nil];
        }
    } cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
}

#pragma mark - Event Responds
- (void)sendActionWithText:(NSString *)text{
    if(![NSString verifyComment:text]) {
        return;
    }
    if([text isBlank]) {
        _selectCommentIndexStr = nil;
        return;
    }
    if(!_selectCommentIndexStr) {
        self.commentViewModel.replyOf = nil;
    } else {
        XPSecondHandCommentsModel *model = [self.commentViewModel.commentsList objectAtIndex:[_selectCommentIndexStr integerValue]];
        self.commentViewModel.replyOf = model.forumCommentId;
    }
    [self showLoader];
    self.commentViewModel.content = text;
    [self.commentViewModel.replyCommand execute:nil];
}

- (IBAction)navigationButtonAction:(id)sender
{
    if([[XPLoginModel singleton].userId isEqualToString:self.detailPostViewModel.model.author.userId]) {
        _moreOptions = [[XPMoreOptionsViewController alloc] initWithMoreOptionsWithIcons:@[@"secondhand_edit_ico", @"secondhand_cancel_ico"] titles:@[@"编辑", @"删除"]];
        _moreOptions.delegate = self;
        [_moreOptions show];
    } else {
        [self showLoader];
        if(self.detailPostViewModel.isFavorit) {
            [self.detailPostViewModel.cancelCollectionCommand execute:nil];
        } else {
            [self.detailPostViewModel.collectionCommand execute:nil];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyCollecRefreshNotification" object:nil];
    }
}

#pragma mark - Private Methods

#pragma mark - 键盘 (created by jy time:2015-3-16)
- (void)registerForKeyboardNotifications
{
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        [self handleKeyboardWillShowNote:nil];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(id x) {
        [self handleKeyboardWillHideNote:nil];
    }];
}

- (void)handleKeyboardWillShowNote:(NSNotification *)notification
{
    __weak typeof(self
                  ) weakSelf = self;
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    [UIView animateWithDuration:duration animations:^{
        weakSelf.sendViewBottomLayoutConstraint.constant = keyboardRect.size.height;
    }
                     completion:^(BOOL finished) {
                     }];
}

- (void)handleKeyboardWillHideNote:(NSNotification *)notification
{
    __weak typeof(self
                  ) weakSelf = self;
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    [UIView animateWithDuration:duration animations:^{
        weakSelf.sendViewBottomLayoutConstraint.constant = 0;
    }
                     completion:^(BOOL finished) {
                         _commentInputTextField.text = @"";
                         _commentInputTextField.placeholder = @"评论";
                         _selectCommentIndexStr = nil;
                     }];
}

#pragma mark - Getter & Setter

@end
