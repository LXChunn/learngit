//
//  XPOSSImageView.m
//  XPApp
//
//  Created by xinpinghuang on 12/24/15.
//  Copyright © 2015 ShareMerge. All rights reserved.
//

#import "UIImage+XPCompress.h"
#import "XPLoginModel.h"
#import "XPOSSImageView.h"
#import <AliyunOSSiOS/OSSCompat.h>
#import <AliyunOSSiOS/OSSService.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <XPKit/XPKit.h>
#import "XPAlertController.h"

@interface XPOSSImageView ()<XPAlertControllerDelegate>

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic,strong) UIButton *retryButton;
@property (nonatomic, strong) OSSTask *putTask;
@property (nonatomic,strong) XPAlertController *alertController;

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

- (void)retruButtonTaped
{
    self.alertController = [[XPAlertController alloc] initWithActivity:@[@"重新上传", @"删除"]];
    self.alertController.delegate = self;
    [self.alertController show];
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
    [self setUserInteractionEnabled:YES];
//    self.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.progressView];
    [self addSubview:self.deleteButton];
    [self addSubview:self.retryButton];
    _deleteButton.hidden = YES;
    _retryButton.hidden = YES;
    
    @weakify(self);
    [[self.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self deleteButtonTaped];
    }];
    
    [[self.retryButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self retruButtonTaped];
    }];
    
    [self whenTapped:^{
        @strongify(self);
        [self taped];
    }];
}

- (OSSClient *)ossClient
{
    NSString *const AccessKey = @"GSMD6g3etoSqEzdr";
    NSString *const SecretKey = @"SDMNhVDY5LEcUwzAqFTMQWsP90Yhrm";
    NSString *const endPoint = @"http://oss-cn-shanghai.aliyuncs.com";
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
    put.bucketName = @"sharemerge-images";
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
            self.ossURL = [NSString stringWithFormat:@"http://sharemerge-images.oss-cn-shanghai.aliyuncs.com/%@", put.objectKey];
            if(self.delegate &&
               [self.delegate respondsToSelector:@selector(uploadFinished:)]) {
                [self.delegate uploadFinished:self];
            }
            _progressView.hidden = YES;
            _deleteButton.hidden = NO;
            _retryButton.hidden = YES;
            NSLog(@"upload object success!");
        } else {
            NSLog(@"upload object failed, error: %@", task.error);
            _retryButton.hidden = NO;
            _deleteButton.hidden = YES;
        }
        
        return nil;
    }];
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
    if (!_retryButton)
    {
        _retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_retryButton setImage:[UIImage imageNamed:@"common_add_image_retry"] forState:UIControlStateNormal];
        float width = self.frame.size.width;
        _retryButton.frame = ccr(width-30, 0, 30, 30);
    }
    return _retryButton;
}

@end
