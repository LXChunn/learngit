
//  XPDetailImageShowView.m
//  XPApp
//
//  Created by jy on 15/12/28.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "UIView+block.h"
#import "XPDetailImageShowView.h"
#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import <XPKit/XPKit.h>
#import <UIImageView+WebCache.h>
static const CGFloat xp_detailImageView_spacing = 10;
static const CGFloat xp_detailImageWidth = 110;
static const CGFloat xp_detailImageHeight = 110;

@interface XPDetailImageShowView ()<MWPhotoBrowserDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *myScrollView;
@property (nonatomic, strong) NSMutableArray *photoBrowsers;
@property (nonatomic, strong) NSArray *imagesArray;

@end

@implementation XPDetailImageShowView

- (void)loadUIWithImagesArray:(NSArray *)imagesArray
{
    _imagesArray = imagesArray;
    [self configureUI];
}

- (void)configureUI
{
    if (!_myScrollView) {
        _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, xp_detailImageHeight)];
        _myScrollView.contentSize = CGSizeMake(110 * _imagesArray.count + (_imagesArray.count + 1) * xp_detailImageView_spacing, 0);
        _myScrollView.showsVerticalScrollIndicator = NO;
        _myScrollView.showsHorizontalScrollIndicator = NO;
        _myScrollView.delegate = self;
        [self addSubview:_myScrollView];
    }
    for (UIImageView *imageView in _myScrollView.subviews) {
        [imageView removeFromSuperview];
    }
    for(int i = 0; i < [_imagesArray count]; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(xp_detailImageWidth *i + xp_detailImageView_spacing *(i + 1), 0, xp_detailImageWidth, xp_detailImageHeight)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[_imagesArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"common_list_default"]];
        imageView.userInteractionEnabled = YES;
        __weak typeof(self) weakSelf = self;
        [imageView whenTapped:^{
            [weakSelf tapImageWithIndex:i];
        }];
        [_myScrollView addSubview:imageView];
    }
}

- (void)tapImageWithIndex:(NSInteger)index;
{
    self.photoBrowsers = [NSMutableArray array];
    for(NSInteger i = 0; i < _imagesArray.count; i++) {
        [self.photoBrowsers addObject:[MWPhoto photoWithURL:[NSURL URLWithString:_imagesArray[i]]]];
    }
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.zoomPhotosToFill = YES;
    browser.alwaysShowControls = NO;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.autoPlayOnAppear = NO;
    [browser setCurrentPhotoIndex:index];
    [[self belongViewController].navigationController pushViewController:browser animated:YES];
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
}

#pragma mark - MWPhotoBrowerDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.photoBrowsers.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if(index < self.photoBrowsers.count) {
        return [self.photoBrowsers objectAtIndex:index];
    }
    
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index
{
}

@end
