//
//  XPForumViewController.m
//  XPApp
//
//  Created by jy on 15/12/28.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPForumViewController.h"
#import "XPForumViewModel.h"
#import "XPSecondHandViewController.h"
#import "XPUser.h"
#import <XPKit.h>
#import "XPFavouActivityViewController.h"
#import "XPCommonWebViewController.h"
#import "XPLoginModel.h"
#import "XPHousekeepingNewsViewController.h"

#define BoundsWidth         [UIScreen mainScreen].bounds.size.width
#define BoundsHeight        [UIScreen mainScreen].bounds.size.height

@interface XPForumViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (nonatomic, strong) XPForumViewModel *forumViewModel;
@end

@implementation XPForumViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    _forumViewModel = [[XPForumViewModel alloc] init];
}

#pragma mark - UICollectionViewDelegateAndDatasource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ForunCollectionViewCell" forIndexPath:indexPath];
    UIImageView *imageView = [cell viewWithTag:1];
    imageView.image = [UIImage imageNamed:[_forumViewModel.imageArray objectAtIndex:indexPath.row]];
    UILabel *titleLabel = [cell viewWithTag:11];
    titleLabel.textColor = [UIColor colorWithHex:0x474747];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = [_forumViewModel.titleArray objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _forumViewModel.titleArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = BoundsWidth/4.0f;
    float height = width;
    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(![self isLogin]) {
        [self presentLogin];
    } else {
        if(![self isBindHouse]) {
            [self presentBindHouse];
        } else {
            XPCommonWebViewController * webViewController = (XPCommonWebViewController *)[self instantiateViewControllerWithStoryboardName:@"Forum" identifier:@"XPCommonWebViewController"];
            switch(indexPath.row) {
                case 0: {
                    //二手市场
                    UIViewController *viewController = [self instantiateInitialViewControllerWithStoryboardName:@"SecondHand"];
                    XPSecondHandViewController *controller = (XPSecondHandViewController *)viewController;
                    controller.mineType = MineTypeOfSecondHand;
                    [self pushViewController:viewController];
                    break;
                }
                case 1:{
                    //悦生活
                    [self pushViewController:[self instantiateViewControllerWithStoryboardName:@"Forum" identifier:@"XPHappyLifeViewController"]];
                    break;
                }
                case 2:{
                    //优惠活动
                    XPFavouActivityViewController *controller =(XPFavouActivityViewController *) [self instantiateViewControllerWithStoryboardName:@"FavouActivity" identifier:@"XPFavouActivityViewController"];
                    [self pushViewController:controller];
                    break;
                }
                case 3:{
                    //楼盘
                    if ([XPLoginModel singleton].household.cityCode.length < 1) {
                        webViewController.webUrl = @"http://dragonbutler.memeyin.com/h5/buildings";
                    }else{
                        webViewController.webUrl = [NSString stringWithFormat:@"http://dragonbutler.memeyin.com/h5/buildings?city_code=%@",[XPLoginModel singleton].household.cityCode];
                    }
                    webViewController.navTitle = @"楼盘";
                    [self pushViewController:webViewController];
                    break;
                }
                case 6:{
                    //家政资讯
                    [self pushViewController:[self instantiateInitialViewControllerWithStoryboardName:@"HousekeepingNews"]];
                    break;
                }
                case 7:{
                    //业主拼车
                    [self pushViewController:[self instantiateInitialViewControllerWithStoryboardName:@"Carpoolings"]];
                    break;
                }
                case 4:{
                    //快递查询
                    webViewController.webUrl = @"http://m.kuaidi100.com/";
                    webViewController.navTitle = @"快递查询";
                    [self pushViewController:webViewController];
                    break;
                }
                case 5:{
                    //天气查询
                    webViewController.webUrl = @"http://m.weather.com.cn/mweather";
                    webViewController.navTitle = @"天气查询";
                    [self pushViewController:webViewController];
                    break;
                }
                default: {
                }
                    break;
            }
        }
    }
}

#pragma mark - Event Responds

#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end
