//
//  XPAddImageView.m
//  XPApp
//
//  Created by xinpinghuang on 12/23/15.
//  Copyright © 2015 ShareMerge. All rights reserved.
//

#import "XPAddImageView.h"
#import "XPAlertController.h"
#import "XPDeleteActivity.h"
#import "XPOSSImageView.h"
#import "XPSaveActivity.h"
#import "XPShareActivityViewController.h"
#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <XPKit/XPKit.h>

@interface XPAddImageView ()<UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, XPOSSImageViewDelegate, MWPhotoBrowserDelegate, XPAlertControllerDelegate>

@property (nonatomic, strong) NSMutableArray<XPOSSImageView *> *addedImageView;
@property (nonatomic, strong) UIButton *addButton;
@property (strong, nonatomic) UILabel *tipLabel;
@property (nonatomic, strong) NSMutableArray *photoBrowsers;
@property (nonatomic, strong) XPShareActivityViewController *activityViewController;
@property (nonatomic, strong) XPAlertController *alertController;

@property (nonatomic, assign, readwrite) BOOL uploadFinshed;

@end

@implementation XPAddImageView
{
    CGFloat slicingValue;  /**< 左边距、右边距、行距、列距 */
    NSInteger rowMax; /**< 每行最多个数 */
    CGFloat elementWidth, elementHeight; /**< 元素宽或高（图片和添加按钮） */
    NSInteger elementMax; /**< 元素最大值 */
}

#pragma mark - Life Circle
- (instancetype)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])) {
        [self calculateUIParameter];
        [self configUI];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self calculateUIParameter];
    [self configUI];
}

- (void)relayoutUI
{
    if(self.addedImageView.count <= 0) {
        self.addButton.frame = ccr(slicingValue, 0, elementWidth, elementHeight);
        [self.tipLabel setHidden:NO];
        return;
    }
    
    for(NSInteger i = 0; i < self.addedImageView.count; i++) {
        XPOSSImageView *imageView = [self viewWithTag:900+i];
        imageView.frame = ccr(slicingValue+(i%rowMax*(elementWidth+slicingValue)), 0+(i/rowMax*(elementHeight+slicingValue)), elementWidth, elementHeight);
        [self.tipLabel setHidden:YES];
    }
    if(self.addedImageView.count == elementMax) {
        self.addButton.hidden = YES;
    } else {
        self.addButton.hidden = NO;
    }
    
    // add's button moved
    NSInteger currentColumn = self.addedImageView.count%rowMax;
    NSInteger currentRow = 0;
    if(self.addedImageView.count >= rowMax) {
        currentRow = 1;
    }
    
    self.addButton.frame = ccr(slicingValue+currentColumn*(elementWidth+slicingValue), 0+currentRow*(elementHeight+slicingValue), elementWidth, elementHeight);
    if(currentRow == 1) {
        self.frame = ccr(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, (elementHeight+20)*2);
    } else {
        self.frame = ccr(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, (elementHeight+20));
    }
}

#pragma mark - Delete
#pragma mark - XPAlertControllerDelegate
- (void)alertController:(XPAlertController *)alertController didSelectRow:(NSInteger)row
{
    switch(row) {
        case 0: {//拍照
#if TARGET_IPHONE_SIMULATOR
            [self pickImageIfTakeNew:NO];//模拟器不支持拍照
#else
            [self pickImageIfTakeNew:YES];
#endif
            break;
        }
            
        case 1: {//相册
            [self pickImageIfTakeNew:NO];
            break;
        }
    }
}

#pragma mark - XPOSSImageViewDelegate
- (void)uploadFinished:(XPOSSImageView *)ossImageView
{
    if(_urls) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.urls];
        [array addObject:ossImageView.ossURL];
        _urls = [array copy];
    } else {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:ossImageView.ossURL];
        _urls = [array copy];
    }
    if(_urls.count == self.addedImageView.count) {
        self.uploadFinshed = YES;
    } else {
        self.uploadFinshed = NO;
    }
}

- (void)downloadFinished:(XPOSSImageView *)ossImageView
{
    //   编辑的时候其实不用管到底有没有下载完全，所以该处的业务逻辑可去掉
    //   2016-01-06
    
    //    static NSInteger downloadCount = 1; // 该处仅仅为判断下载是否全部成功，所以只做了static的局部变量
    //    if(self.urls.count == downloadCount) {
    //        self.uploadFinshed = YES;
    //    } else {
    //        self.uploadFinshed = NO;
    //    }
    
    [self relayoutUI];
    
    //    downloadCount++;
}

- (void)deleteTaped:(XPOSSImageView *)ossImageView
{
    [self removeImageContainerWithTag:ossImageView.tag];
}

- (void)taped:(XPOSSImageView *)ossImageView
{
    self.photoBrowsers = [NSMutableArray array];
    for(NSInteger i = 0; i < self.addedImageView.count; i++) {
        [self.photoBrowsers addObject:[MWPhoto photoWithImage:self.addedImageView[i].image]];
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
    [browser setCurrentPhotoIndex:ossImageView.tag-900];
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
    XPSaveActivity *save = [[XPSaveActivity alloc] init];
    XPDeleteActivity *delete = [[XPDeleteActivity alloc] init];
    self.activityViewController = [[XPShareActivityViewController alloc] initWithASharedActivity:nil actionActivities:@[save, delete]];
    [self.activityViewController show];
}

#pragma mark - UIImagePickerDelegate
- (void)pickImageIfTakeNew:(BOOL)takeNew
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = takeNew ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [[self belongViewController] presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info
{
    UIImage *editedImage = (UIImage *)[info valueForKey:UIImagePickerControllerEditedImage];
    if(!editedImage) {
        editedImage = (UIImage *)[info valueForKey:UIImagePickerControllerOriginalImage];
    }
    
    [self processAddedImage:editedImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)processAddedImage:(UIImage *)image
{
    [self addImageContainerWithImage:image];
    [self relayoutUI];
}

#pragma mark - Event Response
- (void)addImageTaped
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    self.alertController = [[XPAlertController alloc] initWithActivity:@[@"拍照", @"从手机相册选择"]];
    self.alertController.delegate = self;
    [self.alertController show];
}

#pragma mark - Public Interface
- (void)setOSSURLs:(NSArray *)urls
{
    if(!urls || !urls.count) {
        return;
    }
    
    _urls = [urls copy];
    
    for(NSInteger i = 0; i < _urls.count; i++) {
        NSString *url = _urls[i];
        XPOSSImageView *imageView = [[XPOSSImageView alloc] initWithFrame:ccr(slicingValue+(i%rowMax*(elementWidth+slicingValue)), 0+(i/rowMax*(elementHeight+slicingValue)), elementWidth, elementHeight)];
        imageView.delegate = self;
        imageView.ossURL = url;
        [self addSubview:imageView];
        imageView.tag = 900+i;
        
        [self.addedImageView addObject:imageView];
    }
    
    [self.tipLabel setHidden:YES];
    if(_urls.count == elementMax) {
        self.addButton.hidden = YES;
    } else {
        self.addButton.hidden = NO;
    }
    
    // add's button moved
    NSInteger currentColumn = _urls.count%rowMax;
    NSInteger currentRow = 0;
    if(_urls.count >= rowMax) {
        currentRow = 1;
    }
    
    self.addButton.frame = ccr(slicingValue+currentColumn*(elementWidth+slicingValue), 0+currentRow*(elementHeight+slicingValue), elementWidth, elementHeight);
    if(currentRow == 1) {
        self.frame = ccr(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, (elementHeight+20)*2);
    } else {
        self.frame = ccr(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, (elementHeight+20));
    }
    
    self.uploadFinshed = YES;
}

#pragma mark - Private Method
- (void)calculateUIParameter
{
    self.uploadFinshed = NO;
    self.urls = nil;
    slicingValue = 20;
    rowMax = 3;
    elementMax = 5;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    // 如果每行是3个图片，元素宽度就是：屏幕宽度-列距*(3+1)/3，如下图共4个间隙
    /*
     
     1  2   3  4
     | 口⃣ 口⃣ 口⃣ |
     
     */
    elementHeight = elementWidth = (screenWidth-slicingValue*(rowMax+1))/rowMax;
}

- (void)configUI
{
    self.addedImageView = [@[] mutableCopy];
    
    [self addSubview:self.addButton];
    @weakify(self);
    [[self.addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self addImageTaped];
    }];
    [self addSubview:self.tipLabel];
}

- (void)addImageContainerWithImage:(UIImage *)image
{
    self.uploadFinshed = NO;
    
    NSInteger i = self.addedImageView.count;
    XPOSSImageView *imageView = [[XPOSSImageView alloc] initWithFrame:ccr(slicingValue+(i%rowMax*(elementWidth+slicingValue)), 0+(i/rowMax*(elementHeight+slicingValue)), elementWidth, elementHeight)];
    imageView.delegate = self;
    imageView.image = image;
    [self addSubview:imageView];
    imageView.tag = 900+i;
    
    [self.addedImageView addObject:imageView];
}

- (void)removeImageContainerWithTag:(NSInteger)tag
{
    XPOSSImageView *imageView = [self viewWithTag:tag];
    if(imageView) {
        [imageView removeFromSuperview];
    }
    
    for(NSInteger i = 0; i < self.addedImageView.count; i++) {
        if(i < tag-900) {
            continue;
        } else {
            XPOSSImageView *imageView = [self viewWithTag:900+i];
            imageView.tag = 900+i-1;
        }
    }
    
    // 移除缓存好的UIImageView
    [self.addedImageView removeObject:imageView];
    
    // 移除缓存好的url
    NSMutableArray *arrayUrls = [NSMutableArray arrayWithArray:self.urls];
    if(arrayUrls.count <= 0) {
        _urls = nil;
        self.uploadFinshed = NO;
    } else {
        [arrayUrls removeObjectAtIndex:tag-900];
        _urls = [arrayUrls copy];
        self.uploadFinshed = self.uploadFinshed;
    }
    
    [self relayoutUI];
}

#pragma mark - Getter && Setter
- (UIButton *)addButton
{
    if(!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setBackgroundImage:[UIImage imageNamed:@"common_add_image_button"] forState:UIControlStateNormal];
        _addButton.frame = ccr(slicingValue, 0, elementWidth, elementHeight);
    }
    
    return _addButton;
}

- (UILabel *)tipLabel
{
    if(!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"最多添加5张照片";
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.textColor = [UIColor colorWithRed:0.780 green:0.780 blue:0.804 alpha:1.000];
        _tipLabel.font = [UIFont systemFontOfSize:16];
        _tipLabel.frame = ccr(slicingValue+elementWidth+15, (elementHeight-21)/2, 186, 21);
    }
    
    return _tipLabel;
}

@end
