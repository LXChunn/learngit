//
//  XPCommunityViewController.m
//  XPApp
//
//  Created by jy on 16/1/14.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPCommunityViewController.h"
#import <XPKit.h>
#import "XPListComplaintViewController.h"
#import "XPConvenienceStoreViewController.h"
#import "XPYellowPageViewController.h"
#import "XPCommonWebViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "UIViewController+XPCurrentViewController.h"

#define BoundsWidth         [UIScreen mainScreen].bounds.size.width
#define BoundsHeight        [UIScreen mainScreen].bounds.size.height
@interface XPCommunityViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,CLLocationManagerDelegate>
{
    float lng;
    float lat;
}
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (nonatomic,strong) NSArray *iconImages;
@property (nonatomic,strong) NSArray *titlesArray;
@property (nonatomic,strong) CLLocationManager *locationManager;


@end

@implementation XPCommunityViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = 1000.0f;
    _iconImages = @[@"community_complaint_button",@"community_store_button",@"community_webpoint_button",@"community_pages_button"];
    _titlesArray = @[@"投诉",@"便利店",@"周边网点",@"黄页"];
}

#pragma mark - Delegate
#pragma mark - UICollectionViewDelegateAndDatasource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UIImageView *imageView = [cell viewWithTag:10];
    imageView.image = [UIImage imageNamed:[_iconImages objectAtIndex:indexPath.row]];
    UILabel *titleLabel = [cell viewWithTag:20];
    titleLabel.textColor = [UIColor colorWithHex:0x474747];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = [_titlesArray objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark - Event Responds
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _titlesArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = (BoundsWidth/4.0f);
    float height = width;
    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//cell与cell之间的最小距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//行与行之间的最小间距
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
            switch(indexPath.row) {
                case 0: {
                    //投诉
                    [self pushViewController:[self instantiateInitialViewControllerWithStoryboardName:@"Complaint"]];
                    break;
                }
                case 1:{
                    //便利店
                    [self pushViewController:[self instantiateInitialViewControllerWithStoryboardName:@"ConvenienceStore"]];
                    break;
                }
                case 2:{
                    //周边网点
                    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
                        [self goOutlets];
                    }else{
                        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
                            [self.locationManager requestWhenInUseAuthorization];
                        }
                        [self.locationManager startUpdatingLocation];
                    }
                    break;
                }
                case 3:{
                    //黄页
                    XPYellowPageViewController *controller = (XPYellowPageViewController *)[self instantiateViewControllerWithStoryboardName:@"YellowPage" identifier:@"XPYellowPageViewController"];
                    [controller setHidesBottomBarWhenPushed:YES];
                    [self pushViewController:controller];
                    break;
                }
                default: {
                }
                    break;
            }
        }
    }

}

#pragma mark - CLLocationManagerDelegate
// 地理位置发生改变时触发
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // 获取经纬度
    lat = newLocation.coordinate.latitude;
    lng = newLocation.coordinate.longitude;
    [manager stopUpdatingLocation];
    [self goOutlets];
}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self goOutlets];
}

#pragma mark - Event Responds
- (void)goOutlets{
    if ([[UIViewController getCurrentVC] isKindOfClass:[XPCommonWebViewController class]]) {
        return;
    }
    XPCommonWebViewController * webViewController = (XPCommonWebViewController *)[self instantiateViewControllerWithStoryboardName:@"Forum" identifier:@"XPCommonWebViewController"];
    webViewController.webUrl = [self loacationUrl];
    webViewController.navTitle = @"周边网点";
    [self pushViewController:webViewController];
}

#pragma mark - Private Methods
- (NSString *)loacationUrl
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSString * url = [NSString stringWithFormat:@"http://dragonbutler.memeyin.com/h5/bank_outlets?lng=%f&lat=%f",lng,lat];
        return url;
    }else{
        return @"http://dragonbutler.memeyin.com/h5/bank_outlets";
    }
}

#pragma mark - Getter & Setter

@end 
