//
//  XPOSSImageView.m
//  XPApp
//
//  Created by xinpinghuang on 12/24/15.
//  Copyright © 2015 ShareMerge. All rights reserved.
//

#import "NSObject+XPDownloadFile.h"
#import "UIImage+XPCompress.h"
#import "XPAlertController.h"
#import "XPLoginModel.h"
#import "XPOSSImageView.h"
#import <AFNetworking/AFNetworking.h>
#import <AliyunOSSiOS/OSSCompat.h>
#import <AliyunOSSiOS/OSSService.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <XPKit/XPKit.h>

@interface XPOSSImageView ()<XPAlertControllerDelegate>

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *retryButton;
@property (nonatomic, strong) UIButton *redownloadButton;
@property (nonatomic, strong) OSSTask *putTask;
@property (nonatomic, strong) XPAlertController *alertController;

@end

@implementation XPOSSImageView

#pragma mark - Life Circle
- (instancetype)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])) {
        [self configUI];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self configUI];
}

- (void)setImage:(UIImage *)image
{
    [super setImage:image];
    
    [self removeBorders];
    if(self.ossURL) {  // 如果在postRemoteImageData之前该字段就有则代表是从外部直接直接传进来，就不要上传到OSS了
        return;
    }
    
    [self postRemoteImageData:[self.image xp_compress]];
}

#pragma mark - Event Responds
- (void)taped
{
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(taped:)]) {
        [self.delegate taped:self];
    }
}

- (void)deleteButtonTaped
{
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(deleteTaped:)]) {
        [self.delegate deleteTaped:self];
    }
}

- (void)retryButtonTaped
{
    self.alertController = [[XPAlertController alloc] initWithActivity:@[@"重新上传", @"删除"]];
    self.alertController.delegate = self;
    [self.alertController show];
}

- (void)redownloadButtonTaped
{
    [self downloadRemoteImageData];
}

#pragma mark - XPAlertControllerDelegate
- (void)alertController:(XPAlertController *)alertController didSelectRow:(NSInteger)row
{
    switch(row) {
        case 0: {//重新上传
            [self postRemoteImageData:[self.image xp_compress]];
            break;
        }
            
        case 1: {//删除
            [self deleteButtonTaped];
            break;
        }
    }
}

#pragma mark - Private Methods
- (void)configUI
{
    [self createBordersWithColor:[UIColor colorWithWhite:0.000 alpha:0.20] withCornerRadius:0 andWidth:1];
    
    [self setUserInteractionEnabled:YES];
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    [self addSubview:self.progressView];
    [self addSubview:self.deleteButton];
    [self addSubview:self.retryButton];
    [self addSubview:self.redownloadButton];
    _deleteButton.hidden = YES;
    _retryButton.hidden = YES;
    _redownloadButton.hidden = YES;
    
    @weakify(self);
    [[self.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self deleteButtonTaped];
    }];
    
    [[self.retryButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self retryButtonTaped];
    }];
    
    [[self.redownloadButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self redownloadButtonTaped];
    }];
    
    [self whenTapped:^{
        @strongify(self);
        [self taped];
    }];
}

- (OSSClient *)ossClient
{
    
    NSString *const AccessKey = @"FkrAMJ0qxjmUFME0";
    NSString *const SecretKey = @"57VYMfwcXm0gXDH8JpstvRKO2mYJrQ";
    NSString *const endPoint = @"oss-cn-hangzhou.aliyuncs.com";
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:AccessKey secretKey:SecretKey];
    OSSClientConfiguration *conf = [OSSClientConfiguration new];
    conf.maxRetryCount = 2;
    conf.timeoutIntervalForRequest = 30;
    conf.timeoutIntervalForResource = 24 * 60 * 60;
    return [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential clientConfiguration:conf];
}

- (void)postRemoteImageData:(NSData *)imageData
{
    NSParameterAssert(imageData);
    OSSClient *client = [self ossClient];
    OSSPutObjectRequest *put = [OSSPutObjectRequest new];
    //    md5(上传图片时时间戳_用户ID_平台类型_获取用户信息或登录时间戳)
    NSString *fileName = [[NSString stringWithFormat:@"%ld_%@_iOS_%@", (long)[[NSDate date] timeIntervalSince1970], [XPLoginModel singleton].userId, [XPLoginModel singleton].timestamp] MD5];
    fileName = [fileName stringByAppendingString:@".jpg"];
    put.bucketName = @"dragonbulter";
    put.objectKey = fileName;
    put.uploadingData = imageData;
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        CGFloat progress = (CGFloat)totalByteSent/(CGFloat)totalBytesExpectedToSend;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressView setProgress:progress];
        });
    };
    put.contentType = @"";
    put.contentMd5 = @"";
    put.contentEncoding = @"";
    put.contentDisposition = @"";
    
    self.putTask = [client putObject:put];
    [self.putTask continueWithBlock:^id (OSSTask *task) {
        if(!task.error) {
            //            NSLog(@"objectKey: %@", put.objectKey);
            //            OSSPutObjectResult *result = task.result;
            //            NSLog(@"%@", [result propertiesDictionary]);
            self.ossURL = [NSString stringWithFormat:@"http://dragonbulter.oss-cn-hangzhou.aliyuncs.com/%@", put.objectKey];
            if(self.delegate &&
               [self.delegate respondsToSelector:@selector(uploadFinished:)]) {
                [self.delegate uploadFinished:self];
            }
            _progressView.hidden = YES;
            _deleteButton.hidden = NO;
            _retryButton.hidden = YES;
        } else {
            _retryButton.hidden = NO;
            _deleteButton.hidden = YES;
        }
        return nil;
    }];
}

- (void)downloadRemoteImageData
{
    @weakify(self);
    [self downloadVideoFromURL:_ossURL withProgress:^(CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            [self.progressView setProgress:progress];
        });
    }
                    completion:^(NSURL *filePath) {
                        @strongify(self);
                        NSData *data = [NSData dataWithContentsOfURL:filePath];
                        UIImage *image = [[UIImage alloc] initWithData:data];
                        [self setImage:image];
                        if(self.delegate && [self.delegate respondsToSelector:@selector(downloadFinished:)]) {
                            [self.delegate downloadFinished:self];
                        }
                        
                        _progressView.hidden = YES;
                        _deleteButton.hidden = NO;
                        _redownloadButton.hidden = YES;
                    }
                       onError:^(NSError *error) {
                           _deleteButton.hidden = YES;
                           _redownloadButton.hidden = NO;
                           [_progressView setHidden:YES];
                       }];
}

#pragma mark - Public Interface
- (void)setOssURL:(NSString *)ossURL
{
    _ossURL = [ossURL copy];
    [self downloadRemoteImageData];
}

#pragma mark - Getter && Setter
- (UIProgressView *)progressView
{
    if(!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        float width = self.frame.size.width;
        float height = _progressView.frame.size.height;
        float x = (self.frame.size.width / 2.0) - width/2;
        float y = (self.frame.size.height / 2.0) - height/2;
        _progressView.frame = CGRectMake(x, y, width, height);
    }
    
    return _progressView;
}

- (UIButton *)deleteButton
{
    if(!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"common_add_image_delete"] forState:UIControlStateNormal];
        float width = self.frame.size.width;
        _deleteButton.frame = ccr(width-30, 0, 30, 30);
    }
    
    return _deleteButton;
}

- (UIButton *)retryButton
{
    if(!_retryButton) {
        _retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_retryButton setImage:[UIImage imageNamed:@"common_add_image_retry"] forState:UIControlStateNormal];
        float width = self.frame.size.width;
        _retryButton.frame = ccr(width-30, 0, 30, 30);
    }
    
    return _retryButton;
}

- (UIButton *)redownloadButton
{
    if(!_redownloadButton) {
        _redownloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_redownloadButton setImage:[UIImage imageNamed:@"common_add_image_redownload"] forState:UIControlStateNormal];
        float width = self.frame.size.width;
        _redownloadButton.frame = ccr((width-30)/2, (width-30)/2, 30, 30);
    }
    
    return _redownloadButton;
}

@end
