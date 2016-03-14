//
//  XPVoteDetailViewController.m
//  XPApp
//
//  Created by jy on 16/1/6.
//  Copyright 2016年 ShareMerge. All rights reserved.
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
#import "XPDetailViewModel.h"
#import "XPLoginModel.h"
#import "XPMoreOptionsViewController.h"
#import "XPOptionModel.h"
#import "XPSecondHandCommentsModel.h"
#import "XPSecondHandReplyModel.h"
#import "XPVoteContentCell.h"
#import "XPVoteDetailViewController.h"
#import "XPVoteModel.h"
#import "XPVoteOfSelectOptionCell.h"
#import "XPVoteResultCell.h"
#import "XPVoteUserInfoCell.h"
#import <UIImageView+WebCache.h>
#import "XPCommonRefreshHeader.h"
#import "XPCommonRefreshFooter.h"
#import "UITextField+XPLimitLength.h"

#define BoundsWidth [UIScreen mainScreen].bounds.size.width
@interface XPVoteDetailViewController ()<UITableViewDelegate, UITableViewDataSource, XPOptionsViewControllerDelegate, UITextFieldDelegate>
{
    NSString *_selectCommentIndexStr;
    BOOL _isMine;
}
@property (nonatomic, strong) XPMoreOptionsViewController *moreOptions;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightNavigationItem;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendViewBottomLayoutConstraint;
@property (weak, nonatomic) IBOutlet UITextField *commentInputTextField;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet XPCommonCommentViewModel *commentViewModel;
@property (strong, nonatomic) IBOutlet XPDetailViewModel *voteDetailViewModel;
@end

@implementation XPVoteDetailViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.commentInputTextField rac_textSignalWithLimitLength:200];
    @weakify(self);
    [self showFirstHud];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.voteDetailViewModel, error) ignore:nil] map:^id (id value) {
        @strongify(self);
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        [self hideFirstHud];
        [self hideLoader];
        return [value localizedDescription];
    }], nil];
    [[RACObserve(self.voteDetailViewModel, model) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        if([self.voteDetailViewModel.model.author.userId isEqualToString:[XPLoginModel singleton].userId]) {
            _isMine = YES;
            _rightNavigationItem.image = [UIImage imageNamed:@"common_navigation_more"];
        }
        [self.myTableView reloadData];
        [self hideFirstHud];
        self.commentViewModel.commentCount = self.voteDetailViewModel.model.commentsCount;
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
    }];
    
    self.voteDetailViewModel.forumtopicId = _forumtopicId;
    [self.voteDetailViewModel.detailCommand execute:nil];
    
    [[RACObserve(self.commentViewModel, commentsList)ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.myTableView reloadData];
        _commentInputTextField.text = @"";
        _commentInputTextField.placeholder = @"评论";
        _selectCommentIndexStr = nil;
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        [self hideFirstHud];
        [self hideLoader];
    }];
    self.commentViewModel.forumtopicId = _forumtopicId;
    [self.commentViewModel.reloadCommentsCommand execute:nil];
    [[RACObserve(self.commentViewModel, isNoMoreDate) ignore:@(NO)] subscribeNext:^(id x) {
        @strongify(self);
        [self.myTableView.mj_footer endRefreshingWithNoMoreData];
    }];
    self.myTableView.mj_header = [XPCommonRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.commentViewModel.reloadCommentsCommand execute:nil];
        [self.voteDetailViewModel.detailCommand execute:nil];
    }];
    self.myTableView.mj_footer = [XPCommonRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.commentViewModel.moreCommentsCommand execute:nil];
    }];
    [[RACObserve(self.voteDetailViewModel, isVoteSuccess) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self hideLoader];
        [self.voteDetailViewModel.detailCommand execute:nil];
    }];
    [[RACObserve(self.voteDetailViewModel, isDeleteSuccess) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self hideLoader];
        if(self.voteDetailViewModel.isDeleteSuccess) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TopicRefreshNotification" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MyPostRefreshNotification" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MyCommentRefreshNotification" object:nil];
            [self pop];
        }
    }];
    [[RACObserve(self.voteDetailViewModel, isCloseSuccess) ignore:@(NO)] subscribeNext:^(id x) {
        @strongify(self);
        [self hideLoader];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TopicRefreshNotification" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyPostRefreshNotification" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyCommentRefreshNotification" object:nil];
        [self.voteDetailViewModel.detailCommand execute:nil];
    }];
    [RACObserve(self.voteDetailViewModel, isFavorit) subscribeNext:^(id x) {
        @strongify(self);
        if (_isMine) {
            return;
        }
        [self hideLoader];
        if(self.voteDetailViewModel.isFavorit) {
            self.rightNavigationItem.image = [[UIImage imageNamed:@"common_collection_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        } else {
            self.rightNavigationItem.image = [[UIImage imageNamed:@"common_collection_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
    }];
    [self registerForKeyboardNotifications];
    self.myTableView.separatorColor = [UIColor clearColor];
}

#pragma mark - Delegate
#pragma mark - tableviewDelegateAndDatasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            XPVoteUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPVoteUserInfoCell"];
            [cell bindModel:self.voteDetailViewModel.model];
            [cell whenClickAvatorWithBlock:^{
                [weakSelf goOtherUserInfoCenterWithModel:weakSelf.voteDetailViewModel.model.author];
            }];
            return cell;
        } else {
            XPVoteContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPVoteContentCell"];
            [cell bindModel:self.voteDetailViewModel.model];
            return cell;
        }
    } else if(indexPath.section == 1) {
        if(self.voteDetailViewModel.model.extra.open && !self.voteDetailViewModel.model.extra.voted) {
            if(indexPath.row < self.voteDetailViewModel.model.extra.options.count) {
                XPOptionModel *model = [self.voteDetailViewModel.model.extra.options objectAtIndex:indexPath.row];
                XPVoteOfSelectOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPVoteOfSelectOptionCell"];
                [cell bindModel:model];
                return cell;
            } else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VoteCell"];
                UIButton *voteButton = [cell viewWithTag:120];
                [[voteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                    for(XPOptionModel *model in self.voteDetailViewModel.model.extra.options) {
                        BOOL isFind = NO;
                        if(model.isSelected) {
                            weakSelf.voteDetailViewModel.voteOptionId = model.voteOptionId;
                            [weakSelf showLoader];
                            [weakSelf.voteDetailViewModel.voteCommand execute:nil];
                            isFind = YES;
                        }
                        if(isFind) {
                            break;
                        }
                    }
                }];
                return cell;
            }
        } else {
            if(indexPath.row == 0) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
                UILabel *label = [cell viewWithTag:100];
                if (self.voteDetailViewModel.model.extra.participantsCount > 0) {
                    label.text = [NSString stringWithFormat:@"已有%@人参与,投票结果:", self.voteDetailViewModel.model.extra.participantsCount];
                }
                return cell;
            } else {
                XPOptionModel *model = [self.voteDetailViewModel.model.extra.options objectAtIndex:indexPath.row - 1];
                XPVoteResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPVoteResultCell"];
                model.totalVoteCount = [self.voteDetailViewModel.model.extra.participantsCount intValue];
                [cell bindModel:model];
                return cell;
            }
        }
    } else if(indexPath.section > 2) {
        XPSecondHandCommentsModel *model = [self.commentViewModel.commentsList objectAtIndex:indexPath.section - 3];
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
            return 50;
        } else {
            return [XPVoteContentCell cellHeightWithModel:self.voteDetailViewModel.model];
        }
    } else if(indexPath.section == 1) {
        if(self.voteDetailViewModel.model.extra.open && !self.voteDetailViewModel.model.extra.voted) {
            if(indexPath.row < self.voteDetailViewModel.model.extra.options.count) {
                XPOptionModel *model = [self.voteDetailViewModel.model.extra.options objectAtIndex:indexPath.row];
                return [XPVoteOfSelectOptionCell cellHeightWithModel:model];
            } else {
                return 66;
            }
        } else {
            if(indexPath.row == 0) {
                return 52;
            } else {
                XPOptionModel *model = [self.voteDetailViewModel.model.extra.options objectAtIndex:indexPath.row - 1];
                return [XPVoteResultCell cellHeightWithModel:model];
            }
        }
    } else if(indexPath.section == 2) {
        return 0.001f;
    } else {
        XPSecondHandCommentsModel *model = [self.commentViewModel.commentsList objectAtIndex:indexPath.section - 3];
        [model loadReplyDictionary];
        XPSecondHandReplyModel *replyModel = [model.replies objectAtIndex:indexPath.row];
        float contentHeight = [UIView getTextSizeHeight:[NSString stringWithFormat:@"%@：%@", replyModel.author.nickname, replyModel.content] font:12 withSize:CGSizeMake(BoundsWidth - 67, MAXFLOAT)];
        return contentHeight + 10;
    }
    
    return 0.001f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return 2;
    } else if(section == 1) {
        return self.voteDetailViewModel.model.extra.options.count + 1;
    } else if(section == 2) {
        return 0;
    } else {
        XPSecondHandCommentsModel *model = [self.commentViewModel.commentsList objectAtIndex:section - 3];
        return model.replies.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.commentViewModel.commentsList.count + 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.voteDetailViewModel.model.extra.open) {
        if(!self.voteDetailViewModel.model.extra.voted) {
            if(indexPath.section == 1) {
                for(XPOptionModel *model in self.voteDetailViewModel.model.extra.options) {
                    model.isSelected = NO;
                }
                XPOptionModel *model = [self.voteDetailViewModel.model.extra.options objectAtIndex:indexPath.row];
                model.isSelected = YES;
                [self.myTableView reloadData];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0 || section == 1) {
        return 0.0001f;
    } else if(section == 2) {
        return 63.0f;
    } else {
        XPSecondHandCommentsModel *model = [self.commentViewModel.commentsList objectAtIndex:section - 3];
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
    __weak typeof(self) weakSelf = self;
    if(section == 2) {
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
    } else if(section > 2) {
        if(self.commentViewModel.commentsList.count < 1) {
            return nil;
        }
        
        XPSecondHandCommentsModel *model = [self.commentViewModel.commentsList objectAtIndex:section - 3];
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
            avatorImageView.contentMode = UIViewContentModeScaleAspectFill;
            avatorImageView.clipsToBounds = YES;
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
                _selectCommentIndexStr = [@(section - 3)stringValue];
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
    if(!_selectCommentIndexStr) {
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
    if(self.voteDetailViewModel.model.extra.open) {
        switch(row) {
            case 0: {
                //关闭
                [self closeAction];
                break;
            }
                
            case 1: {
                [self deleteAction];
                break;
            }
                
            default: {
            }
                break;
        }
    } else {
        if(row == 0) {
            [self deleteAction];
        }
    }
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
    [self hideLoader];
    self.commentViewModel.content = text;
    [self.commentViewModel.replyCommand execute:nil];
}

- (void)closeAction
{
    @weakify(self);
    [UIAlertView alertViewWithTitle:@"提示" message:@"确定关闭？" block:^(NSInteger buttonIndex) {
        if(buttonIndex == 0) {
            @strongify(self);
            [self showLoader];
            [self.voteDetailViewModel.closeCommand execute:nil];
        }
    }cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
}

- (void)deleteAction
{
    @weakify(self);
    [UIAlertView alertViewWithTitle:@"提示" message:@"确定删除？" block:^(NSInteger buttonIndex) {
        if(buttonIndex == 0) {
            @strongify(self);
            [self showLoader];
            [self.voteDetailViewModel.deleteCommand execute:nil];
        }
    }cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
}

- (IBAction)clickRightNavigationItemAction:(id)sender
{
    if([self.voteDetailViewModel.model.author.userId isEqualToString:[XPLoginModel singleton].userId]) {
        if(self.voteDetailViewModel.model.extra.open) {
            _moreOptions = [[XPMoreOptionsViewController alloc] initWithMoreOptionsWithIcons:@[@"secondhand_complete_ico", @"secondhand_cancel_ico"] titles:@[@"关闭", @"删除"]];
            _moreOptions.delegate = self;
            [_moreOptions show];
        } else {
            _moreOptions = [[XPMoreOptionsViewController alloc] initWithMoreOptionsWithIcons:@[@"secondhand_cancel_ico"] titles:@[@"删除"]];
            _moreOptions.delegate = self;
            [_moreOptions show];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyPostRefreshNotification" object:nil];
    } else {
        self.voteDetailViewModel.type = 1;
        [self showLoader];
        if(self.voteDetailViewModel.isFavorit) {
            [self.voteDetailViewModel.cancelCollectionCommand execute:nil];
        } else {
            [self.voteDetailViewModel.collectionCommand execute:nil];
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
    __weak typeof(self) weakSelf = self;
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    [UIView animateWithDuration:duration animations:^{
        weakSelf.sendViewBottomLayoutConstraint.constant = keyboardRect.size.height;
    }completion:^(BOOL finished) {
    }];
}

- (void)handleKeyboardWillHideNote:(NSNotification *)notification
{
    __weak typeof(self) weakSelf = self;
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    [UIView animateWithDuration:duration animations:^{
        weakSelf.sendViewBottomLayoutConstraint.constant = 0;
    }completion:^(BOOL finished) {
         _commentInputTextField.text = @"";
         _commentInputTextField.placeholder = @"评论";
         _selectCommentIndexStr = nil;
    }];
}

#pragma mark - Getter & Setter

@end
