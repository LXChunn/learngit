//
//  XPSettingViewController.m
//  XPApp
//
//  Created by jy on 16/1/12.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPSettingViewController.h"
#import <SDWebImage/SDImageCache.h>
#import <UIAlertView+XPKit.h>
#import <UIColor+XPKit.h>
#import <ShareSDK/ShareSDK.h>
#import "XPShareAlertController.h"
#import "XPUser.h"
#import "XPLoginModel.h"
#import "NSObject+XPShareSDK.h"
#import "APService.h"
#import "XPLoginStorage.h"

@interface XPSettingViewController ()<UITableViewDataSource,UITableViewDelegate,XPShareControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *titles;
@property (nonatomic,strong) XPShareAlertController *shareAlertController;


@end

@implementation XPSettingViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    _titles = [NSMutableArray arrayWithObjects:@"意见反馈",@"分享给好友",@"清除图片缓存",@"关于我们", nil];
    _tableView.scrollEnabled = NO;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.separatorColor = [UIColor clearColor];
}

#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titles.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.row <4) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"XPSettingCell" forIndexPath:indexPath];
        UILabel *title = [cell viewWithTag:11];
        UILabel *cacheTitle = [cell viewWithTag:12];
        cacheTitle.textColor = [UIColor colorWithHex:0x474747];
        cacheTitle.font = [UIFont systemFontOfSize:14];
        title.text = _titles[indexPath.row];
        if (indexPath.row == 2)
        {
            cacheTitle.text = [self getCacheSizeWithSize:[[SDImageCache sharedImageCache] getSize]];
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"XPSettingCell2" forIndexPath:indexPath];
        UIButton *exitBtn = [cell viewWithTag:13];
        exitBtn.layer.cornerRadius = 3;
        @weakify(self);
        [[exitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self loginOutAction];
        }];
   }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 0) {
        if (![self isLogin]) {
            [self presentLogin];
        }
        else{
            if ([self isBindHouse]) {
                [self performSegueWithIdentifier:@"XPSuggestionViewController" sender:self];
            }else{
                [self presentBindHouse];
            }
        }
    }
    else if (indexPath.row == 1){
        _shareAlertController = [[XPShareAlertController alloc] initWithActivity:nil];
        _shareAlertController.delegate = self;
        [_shareAlertController show];
    }
    else if (indexPath.row == 2){
        if ([SDImageCache sharedImageCache].getSize == 0) {
            return;
        }
        [UIAlertView alertViewWithTitle:@"提示" message:@"确定清除图片缓存？" block:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                    [_tableView reloadData];
                }];
            }
        } cancelButtonTitle:@"立即" otherButtonTitles:@"取消", nil];
    }
    if (indexPath.row == 3) {
        [self performSegueWithIdentifier:@"aboutUs" sender:self];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) {
        return 169;
    }
    return 50;
}

#pragma mark - ShareDelegate
- (void)shareController:(XPShareAlertController *)shareController didSelectRow:(NSInteger)row
{
    UIImage * iconImage = [UIImage imageNamed:@"common_icon.png"];
    switch (row) {
        case 0:
        {
            [self shareWithTitle:@"社区龙管家" content:@"我的快乐生活，全靠它了! " images:@[iconImage] url:@"http://dragonbutler.memeyin.com/downloads" platformType:SSDKPlatformTypeWechat];
            break;
        }
        case 1:
        {
            [self shareWithTitle:@"社区龙管家——我的快乐生活，全靠它了!" content:@"我的快乐生活，全靠它了! " images:@[iconImage] url:@"http://dragonbutler.memeyin.com/downloads" platformType:SSDKPlatformSubTypeWechatTimeline];
            break;
        }
        case 2:
        {
            [self shareWithTitle:@"社区龙管家" content:@"我的快乐生活，全靠它了! " images:@[iconImage] url:@"http://dragonbutler.memeyin.com/downloads" platformType:SSDKPlatformSubTypeQQFriend];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Event Responds
- (void)loginOutAction
{
    [UIAlertView alertViewWithTitle:@"提示" message:@"确定注销当前账号?" block:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            XPUser * user = [[XPUser alloc] init];
            [XPLoginStorage clearCached];
            [[XPLoginModel singleton] loginOut];
            [APService setAlias:@"" callbackSelector:nil object:nil];
            self.tabBarController.selectedIndex = 0;
            [self presentLogin];
        }
    } cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
}

#pragma mark - Private Methods
- (NSString *)getCacheSizeWithSize:(NSInteger)size
{
    float cacheSize;
    NSString *str;
    if ((size >= 1024) && (size < 1024*1024))
    {
        cacheSize = size/1024.0f;
        str = [NSString stringWithFormat:@"%.02fK",cacheSize];
    }
    else if (size >= 1024*1024)
    {
        cacheSize = size/1024.0/1024.0;
        str = [NSString stringWithFormat:@"%.02fM",cacheSize];
    }
    else
    {
        if (size == 0)
        {
            str = @"0B";
        }
        else
        {
            str = [NSString stringWithFormat:@"%ldB",(long)size];
        }
    }
    return str;
}

#pragma mark - Getter & Setter

@end
