//
//  XPSecondHandOfPostDetailViewController.m
//  XPApp
//
//  Created by jy on 15/12/30.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "MJRefresh.h"
#import "UIView+HESizeHeight.h"
#import "XPLoginModel.h"
#import "XPMoreOptionsViewController.h"
#import "XPSecondHandDetailOfDescriptionCell.h"
#import "XPSecondHandDetailOfUserCell.h"
#import "XPSecondHandDetailViewModel.h"
#import "XPSecondHandOfPostDetailViewController.h"
#import "XPCommonRefreshHeader.h"
#import "XPCommonRefreshFooter.h"
#import "IQKeyboardManager.h"
#import "NSDate+DateTools.h"
#import "NSString+Category.h"
#import "NSString+Verify.h"
#import "UIAlertView+XPKit.h"
#import "UIColor+XPKit.h"
#import "UIImageView+AFNetworking.h"
#import "UIView+block.h"
#import "XPCommonCommentCell.h"
#import "XPSecondHandReplyModel.h"
#import "XPTransferOrBuyModel.h"
#import <UIImageView+WebCache.h>
#import "UITextField+XPLimitLength.h"

#define BoundsWidth [UIScreen mainScreen].bounds.size.width
@interface XPSecondHandOfPostDetailViewController ()<UITableViewDelegate, UITableViewDataSource, XPOptionsViewControllerDelegate, UITextFieldDelegate>
{
    NSString *_selectCommentIndexStr;
    BOOL _isMine;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightNavigationItem;
@property (nonatomic, strong) XPMoreOptionsViewController *moreOptions;
@property (weak, nonatomic) IBOutlet UITextField *commentInputTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendViewBottomLayoutConstraint;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic) IBOutlet XPSecondHandDetailViewModel *viewModel;
#pragma clang diagnostic pop
@end

@implementation XPSecondHandOfPostDetailViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.commentInputTextField rac_textSignalWithLimitLength:200];
    @weakify(self);
    [self showFirstHud];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        @strongify(self);
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        [self hideFirstHud];
        [self hideLoader];
        return [value localizedDescription];
    }], nil];
    [[RACObserve(self.viewModel, detailModel) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        if([self.viewModel.detailModel.author.userId isEqualToString:[XPLoginModel singleton].userId]) {
            _isMine = YES;
            _rightNavigationItem.image = [UIImage imageNamed:@"common_navigation_more"];
        }
        if ([self.viewModel.detailModel.type isEqualToString:@"1"]) {
            self.navigationItem.title = @"转让详情";
        }else{
            self.navigationItem.title = @"求购详情";
        }
        [self.myTableView reloadData];
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        [self hideFirstHud];
    }];
    self.viewModel.secondHandItemId = _secondHandItemId;
    [self.viewModel.detailCommand execute:nil];
    
    [[RACObserve(self.viewModel, isNoMoreDate) ignore:@(NO)] subscribeNext:^(id x) {
        @strongify(self);
       [self.myTableView.mj_footer endRefreshingWithNoMoreData];
    }];
    [[RACObserve(self.viewModel, commentsList)ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.myTableView reloadData];
        [self hideFirstHud];
        [self hideLoader];
        [self.myTableView.mj_footer endRefreshing];
        [self.myTableView.mj_header endRefreshing];
    }];
    [self.viewModel.reloadCommentsCommand execute:nil];
    self.myTableView.mj_header = [XPCommonRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.detailCommand execute:nil];
        [self.viewModel.reloadCommentsCommand execute:nil];
    }];
    self.myTableView.mj_footer = [XPCommonRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.moreCommentsCommand execute:nil];
    }];
    [RACObserve(self.viewModel, isFavorite) subscribeNext:^(id x) {
        @strongify(self);
        if (_isMine) {
            return;
        }
        [self hideLoader];
        if(self.viewModel.isFavorite) {
            self.rightNavigationItem.image = [[UIImage imageNamed:@"common_collection_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        } else {
            self.rightNavigationItem.image = [[UIImage imageNamed:@"common_collection_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
    }];
    [[RACObserve(self.viewModel, isCloseSuccess) ignore:@(NO)] subscribeNext:^(id x) {
        @strongify(self);
        [self hideLoader];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshSecondHandListNotification" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyPostRefreshNotification" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyCommentRefreshNotification" object:nil];
        [self pop];
    }];
    [[RACObserve(self.viewModel, isDeleteSuccess) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self hideLoader];
        if(self.viewModel.isDeleteSuccess) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshSecondHandListNotification" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MyPostRefreshNotification" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MyCommentRefreshNotification" object:nil];
            [self pop];
        }
    }];

    [self registerForKeyboardNotifications];
    self.myTableView.separatorColor = [UIColor clearColor];
}

#pragma mark - Delegate
#pragma mark - tableviewDelegateAndDatasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self
                  ) weakSelf = self;
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            XPSecondHandDetailOfUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPSecondHandDetailOfUserCell"];
            if(!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XPSecondHandDetailOfUserCell" owner:nil options:nil] firstObject];
            }
            [cell bindModel:self.viewModel.detailModel];
            [cell whenClickAvatorWithBlock:^{
                [weakSelf goOtherUserInfoCenterWithModel:self.viewModel.detailModel.author];
            }];
            return cell;
        } else if(indexPath.row == 1) {
            XPSecondHandDetailOfDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPSecondHandDetailOfDescriptionCell"];
            [cell bindModel:self.viewModel.detailModel];
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPSecondHandDetailOfContentCell"];
            if(!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XPSecondHandDetailOfContentCell"];
            }
            
            UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
            label.text = self.viewModel.detailModel.content;
            return cell;
        }
    } else if(indexPath.section > 1) {
        XPSecondHandCommentsModel *model = [self.viewModel.commentsList objectAtIndex:indexPath.section - 2];
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
            return 67;
        } else if(indexPath.row == 1) {
            float titleHeight = [UIView getTextSizeHeight:self.viewModel.detailModel.title font:16 withSize:CGSizeMake(BoundsWidth - 44, MAXFLOAT)];
            if(self.viewModel.detailModel.picUrls.count < 1) {
                return 53 + titleHeight;
            }
            
            return 180 + titleHeight;
        } else if(indexPath.row == 2) {
            if(self.viewModel.detailModel.content.length < 1) {
                return 0.0f;
            }
            
            float contentHeight = [UIView getTextSizeHeight:self.viewModel.detailModel.content font:16 withSize:CGSizeMake(BoundsWidth - 40, MAXFLOAT)];
            return 26 + contentHeight;
        }
    } else if(indexPath.section == 1) {
        return 0.01f;
    } else {
        XPSecondHandCommentsModel *model = [self.viewModel.commentsList objectAtIndex:indexPath.section - 2];
        [model loadReplyDictionary];
        XPSecondHandReplyModel *replyModel = [model.replies objectAtIndex:indexPath.row];
        float contentHeight = [UIView getTextSizeHeight:[NSString stringWithFormat:@"%@：%@", replyModel.author.nickname, replyModel.content] font:12 withSize:CGSizeMake(BoundsWidth - 67, MAXFLOAT)];
        return contentHeight + 10;
    }
    
    return 0.01f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        if(!self.viewModel.detailModel) {
            return 0;
        }
        
        return 3;
    } else if(section == 1) {
        return 0;
    } else {
        XPSecondHandCommentsModel *model = [self.viewModel.commentsList objectAtIndex:section - 2];
        return model.replies.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.viewModel.commentsList.count + 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return 0.0001f;
    } else if(section == 1) {
        return 63.0f;
    } else {
        XPSecondHandCommentsModel *model = [self.viewModel.commentsList objectAtIndex:section - 2];
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
        commentsCountLabel.text = [@(self.viewModel.detailModel.commentsCount)stringValue];
        commentsCountLabel.font = [UIFont systemFontOfSize:14];
        [commentView addSubview:commentsCountLabel];
        [view addSubview:commentView];
        return view;
    } else if(section > 1) {
        if(self.viewModel.commentsList.count < 1) {
            return nil;
        }
        
        XPSecondHandCommentsModel *model = [self.viewModel.commentsList objectAtIndex:section - 2];
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
            [avatorImageView sd_setImageWithURL:[NSURL URLWithString:model.author.avatarUrl] placeholderImage:[UIImage imageNamed:@"common_default_avatar"]];
            [avatorImageView whenTapped:^{
                [self goOtherUserInfoCenterWithModel:model.author];
            }];
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

#pragma mark - XPOptionsViewControllerDelegate
- (void)optionsViewController:(XPMoreOptionsViewController *)optionsViewController didSelectRow:(NSInteger)row
{
    if([self.viewModel.detailModel.status isEqualToString:@"1"]) {
        switch(row) {
            case 0: {
                //编辑
                [self editeAction];
                break;
            }
                
            case 1: {
                //完成
                [self closeAction];
                break;
            }
                
            case 2: {
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
    
    [self.view endEditing:YES];
    [self sendActionWithText:textField.text];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.view endEditing:YES];
    [self sendActionWithText:textField.text];
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
        self.viewModel.replyOf = nil;
    } else {
        XPSecondHandCommentsModel *model = [self.viewModel.commentsList objectAtIndex:[_selectCommentIndexStr integerValue]];
        self.viewModel.replyOf = model.secondhandCommentId;
    }
    [self showLoader];
    self.viewModel.content = text;
    [self.viewModel.replyCommand execute:nil];
}

- (void)editeAction
{
    XPTransferOrBuyViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"XPTransferOrBuyViewController"];
    XPTransferOrBuyModel *model = [[XPTransferOrBuyModel alloc] init];
    model.goodsTitle = self.viewModel.detailModel.title;
    model.goodsDescriptions = self.viewModel.detailModel.content;
    model.price = self.viewModel.detailModel.price;
    model.mobile = self.viewModel.detailModel.mobile;
    model.pictures = [NSMutableArray arrayWithArray:self.viewModel.detailModel.picUrls];
    model.type = self.viewModel.detailModel.type;
    viewController.transferOrBuyModel = model;
    viewController.secondItemId = _secondHandItemId;
    if([self.viewModel.detailModel.type isEqualToString:@"1"]) {
        viewController.secondHandGoodsType = SecondHandGoodsTypeOfTransfer;
    } else if([self.viewModel.detailModel.type isEqualToString:@"2"]) {
        viewController.secondHandGoodsType = SecondHandGoodsTypeOfBuy;
    }
    [self pushViewController:viewController];
}

- (void)deleteAction
{
    @weakify(self);
    [UIAlertView alertViewWithTitle:@"提示" message:@"确定删除？" block:^(NSInteger buttonIndex) {
        if(buttonIndex == 0) {
            @strongify(self);
            [self showLoader];
            self.viewModel.secondHandItemId = _secondHandItemId;
            [self.viewModel.deleteCommand execute:nil];
        }
    }cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
}

- (void)closeAction
{
    @weakify(self);
    [UIAlertView alertViewWithTitle:@"提示" message:@"确定交易已完成？" block:^(NSInteger buttonIndex) {
        if(buttonIndex == 0) {
            @strongify(self);
            [self showLoader];
            self.viewModel.secondHandItemId = _secondHandItemId;
            [self.viewModel.closeCommand execute:nil];
        }
    }cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
}

- (IBAction)clickRightNavigationItemAction:(id)sender
{
    if([self.viewModel.detailModel.author.userId isEqualToString:[XPLoginModel singleton].userId]) {
        if([self.viewModel.detailModel.status isEqualToString:@"1"]) {
            _moreOptions = [[XPMoreOptionsViewController alloc] initWithMoreOptionsWithIcons:@[@"secondhand_edit_ico", @"secondhand_complete_ico", @"secondhand_cancel_ico"] titles:@[@"编辑交易", @"完成交易", @"取消交易"]];
            _moreOptions.delegate = self;
            [_moreOptions show];
        } else {
            _moreOptions = [[XPMoreOptionsViewController alloc] initWithMoreOptionsWithIcons:@[@"secondhand_cancel_ico"] titles:@[@"取消交易"]];
            _moreOptions.delegate = self;
            [_moreOptions show];
        }
    } else {
        self.viewModel.type = 2;
        self.viewModel.secondHandItemId = _secondHandItemId;
        [self showLoader];
        if(self.viewModel.isFavorite) {
            [self.viewModel.cancelCollectionCommand execute:nil];
        } else {
            [self.viewModel.collectionCommand execute:nil];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyCollecRefreshNotification" object:nil];
    }
}

#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end
