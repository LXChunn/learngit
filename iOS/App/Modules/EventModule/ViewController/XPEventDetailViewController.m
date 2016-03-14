//
//  XPEventDetailViewController.m
//  XPApp
//
//  Created by jy on 16/1/4.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "MJRefresh.h"
#import "NSDate+DateTools.h"
#import "NSString+Category.h"
#import "NSString+Verify.h"
#import "UIAlertView+XPKit.h"
#import "UIColor+XPKit.h"
#import "UIColor+XPKit.h"
#import "UIView+HESizeHeight.h"
#import "UIView+block.h"
#import "UIView+block.h"
#import "XPCommonCommentCell.h"
#import "XPCommonCommentViewModel.h"
#import "XPCommonCommentViewModel.h"
#import "XPEventContentCell.h"
#import "XPEventDetailViewController.h"
#import "XPEventDetailViewModel.h"
#import "XPEventUserInfoCell.h"
#import "XPJoinEventMemberCell.h"
#import "XPLoginModel.h"
#import "XPMoreOptionsViewController.h"
#import "XPSecondHandCommentsModel.h"
#import "XPSecondHandReplyModel.h"
#import <UIImageView+WebCache.h>
#import "XPCommonRefreshHeader.h"
#import "XPCommonRefreshFooter.h"
#import "UITextField+XPLimitLength.h"

#define BoundsWidth [UIScreen mainScreen].bounds.size.width
@interface XPEventDetailViewController ()<UITableViewDelegate, UITableViewDataSource, XPOptionsViewControllerDelegate, UITextFieldDelegate>
{
    NSString *_selectCommentIndexStr;
    BOOL _isMine;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendViewBottomLayoutConstraint;
@property (nonatomic, strong) XPMoreOptionsViewController *moreOptions;
@property (nonatomic, strong) NSString *secondCommentId;
@property (strong, nonatomic) IBOutlet XPEventDetailViewModel *detailViewModel;
@property (strong, nonatomic) IBOutlet XPCommonCommentViewModel *commentViewModel;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightNavigationItem;
@property (weak, nonatomic) IBOutlet UITextField *commentInputTextField;

@end

@implementation XPEventDetailViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.commentInputTextField rac_textSignalWithLimitLength:200];
    @weakify(self);
    [self showFirstHud];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.detailViewModel, error) ignore:nil] map:^id (id value) {
        @strongify(self);
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        [self hideFirstHud];
        [self hideLoader];
        return [value localizedDescription];
    }], nil];
    [[RACObserve(self.detailViewModel, model) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        if([self.detailViewModel.model.author.userId isEqualToString:[XPLoginModel singleton].userId]) {
            _isMine = YES;
            _rightNavigationItem.image = [UIImage imageNamed:@"common_navigation_more"];
        }
        [self.myTableView reloadData];
        [self hideFirstHud];
        self.commentViewModel.commentCount = self.detailViewModel.model.commentsCount;
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
    }];
    self.detailViewModel.forumtopicId = _forumtopicId;
    [self.detailViewModel.detailCommand execute:nil];
    
    [[RACObserve(self.commentViewModel, commentsList)ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.myTableView reloadData];
        [self hideFirstHud];
        [self hideLoader];
        _commentInputTextField.text = @"";
        _commentInputTextField.placeholder = @"评论";
        _selectCommentIndexStr = nil;
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
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
        [self.detailViewModel.detailCommand execute:nil];
    }];
    self.myTableView.mj_footer = [XPCommonRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.commentViewModel.moreCommentsCommand execute:nil];
    }];
    [[RACObserve(self.detailViewModel, isJoinSuccess) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self hideLoader];
        [self.detailViewModel.detailCommand execute:nil];
    }];
    [RACObserve(self.detailViewModel, isFavorit) subscribeNext:^(id x) {
        @strongify(self);
        [self hideLoader];
        if (_isMine) {
            return ;
        }
        if(self.detailViewModel.isFavorit) {
            self.rightNavigationItem.image = [[UIImage imageNamed:@"common_collection_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        } else {
            self.rightNavigationItem.image = [[UIImage imageNamed:@"common_collection_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
    }];
    [[RACObserve(self.detailViewModel, isDeleteSuccess) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self hideLoader];
        if(self.detailViewModel.isDeleteSuccess) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TopicRefreshNotification" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MyactivityRefreshNotification" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MyPostRefreshNotification" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MyCommentRefreshNotification" object:nil];
            [self pop];
        }
    }];
    [self registerForKeyboardNotifications];
    self.myTableView.separatorColor = [UIColor clearColor];
}

#pragma mark - Delegate
#pragma mark - tableview deleagte datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    if(indexPath.section == 0) {
        switch(indexPath.row) {
            case 0: {
                XPEventUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPEventUserInfoCell"];
                [cell bindModel:self.detailViewModel.model];
                [cell whenClickAvatorWithBlock:^{
                    [weakSelf goOtherUserInfoCenterWithModel:weakSelf.detailViewModel.model.author];
                }];
                return cell;
            }
                
            case 1: {
                XPEventContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPEventContentCell"];
                [cell bindModel:self.detailViewModel.model];
                return cell;
            }
                
            case 2: {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventTimeCell"];
                UILabel *beginTimeLabel = [cell viewWithTag:110];
                NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[self.detailViewModel.model.extra.startDate doubleValue]];
                beginTimeLabel.text = [startDate formattedDateWithFormat:@"YYYY-MM-dd"];
                UILabel *endTimeLabel = [cell viewWithTag:111];
                if(self.detailViewModel.model.extra.endDate.length < 1) {
                    endTimeLabel.text = @"长期有效";
                } else {
                    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[self.detailViewModel.model.extra.endDate doubleValue]];
                    endTimeLabel.text = [endDate formattedDateWithFormat:@"YYYY-MM-dd"];
                }
                return cell;
            }
                
            case 3: {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JoinEventCell"];
                UIButton *joinButton = [cell viewWithTag:120];
                [[joinButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                    [self showLoader];
                    [self.detailViewModel.joinEventCommand execute:nil];
                }];
                return cell;
            }
                
            default: {
            }
                break;
        }
    } else if(indexPath.section == 1) {
        XPJoinEventMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPJoinEventMemberCell"];
        [cell bindModel:self.detailViewModel.model];
        [cell whenClickJoinMemberWithBlock:^(XPAuthorModel *model) {
            [weakSelf goOtherUserInfoCenterWithModel:model];
        }];
        return cell;
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
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            return 59;
        } else if(indexPath.row == 1) {
            return [XPEventContentCell cellHeightWithModel:self.detailViewModel.model];
        } else if(indexPath.row == 2) {
            return 66;
        } else {
            return [self cellOfJoinEventHeight];
        }
    } else if(indexPath.section == 1) {
        if(self.detailViewModel.model.extra.participants.count < 1) {
            return 0.001f;
        }
        return 99;
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
        return 4;
    } else if(section == 1) {
        return 1;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return 0.0001f;
    } else if(section == 1) {
        if(self.detailViewModel.model.extra.participants.count < 1) {
            return 0.001f;
        }
        return 15;
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
    if(section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BoundsWidth, 15)];
        view.backgroundColor = [UIColor colorWithHex:0xececec];
        return view;
    } else if(section == 2) {
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
            __weak typeof(self) weakSelf = self;
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
- (void)textFieldDidBeginEditing:(UITextField *)textField{
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

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [_commentInputTextField resignFirstResponder];
    [self sendActionWithText:textField.text];
}

#pragma mark - XPOptionsViewControllerDelegate
- (void)optionsViewController:(XPMoreOptionsViewController *)optionsViewController didSelectRow:(NSInteger)row
{
    if(row == 0) {
        [self deleteAction];
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
    [self showLoader];
    self.commentViewModel.content = text;
    [self.commentViewModel.replyCommand execute:nil];
}

- (void)deleteAction
{
    @weakify(self);
    [UIAlertView alertViewWithTitle:@"提示" message:@"确定删除？" block:^(NSInteger buttonIndex) {
        if(buttonIndex == 0) {
            @strongify(self);
            [self showLoader];
            [self.detailViewModel.deleteCommand execute:nil];
        }
    }cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
}

- (IBAction)clickNavigationItemAction:(id)sender
{
    if([self.detailViewModel.model.author.userId isEqualToString:[XPLoginModel singleton].userId]) {
        if(self.detailViewModel.model.extra.open) {
            _moreOptions = [[XPMoreOptionsViewController alloc] initWithMoreOptionsWithIcons:@[@"secondhand_cancel_ico"] titles:@[@"删除"]];
            _moreOptions.delegate = self;
            [_moreOptions show];
        } else {
            _moreOptions = [[XPMoreOptionsViewController alloc] initWithMoreOptionsWithIcons:@[@"secondhand_cancel_ico"] titles:@[@"删除"]];
            _moreOptions.delegate = self;
            [_moreOptions show];
        }
    } else {
        [self showLoader];
        if(self.detailViewModel.isFavorit) {
            [self.detailViewModel.cancelCollectionCommand execute:nil];
        } else {
            [self.detailViewModel.collectionCommand execute:nil];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyCollecRefreshNotification" object:nil];
    }
}

#pragma mark - Private Methods
- (float)cellOfJoinEventHeight
{
    if(self.detailViewModel.model.extra.joined) {
        return 0.001f;
    } else {
        NSString *nowTime = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        if(self.detailViewModel.model.extra.endDate.length < 1) {
            if([self.detailViewModel.model.extra.startDate integerValue] > [nowTime integerValue]) {
                return 0.0001f;
            } else {
                return 66.0f;
            }
        } else {
            if([self.detailViewModel.model.extra.endDate integerValue] < [nowTime integerValue]) {
                return 0.001f;
            } else {
                if([self.detailViewModel.model.extra.startDate integerValue] > [nowTime integerValue]) {
                    return 0.0001f;
                } else {
                    return 66.0f;
                }
            }
        }
    }
}

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
