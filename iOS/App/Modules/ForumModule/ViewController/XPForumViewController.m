//
//  XPForumViewController.m
//  XPApp
//
//  Created by jy on 15/12/28.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPForumViewController.h"
#import "XPSecondHandViewController.h"
#import "XPForumViewModel.h"

#define BoundsWidth         [UIScreen mainScreen].bounds.size.width
#define BoundsHeight        [UIScreen mainScreen].bounds.size.height

@interface XPForumViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (nonatomic,strong) XPForumViewModel *forumViewModel;
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
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ForunCollectionViewCell" forIndexPath:indexPath];
    UIImageView * imageView = [cell viewWithTag:11];
    imageView.image = [UIImage imageNamed:[_forumViewModel.imageArray objectAtIndex:indexPath.row]];
    UILabel * titleLabel = [cell viewWithTag:1];
    titleLabel.text = [_forumViewModel.titleArray objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _forumViewModel.titleArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((BoundsWidth - 24)/3, 95);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(6, 6, 6, 6);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            UIViewController * viewController = [self instantiateInitialViewControllerWithStoryboardName:@"SecondHand"];
            [self pushViewController:viewController];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Event Responds

#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end 
