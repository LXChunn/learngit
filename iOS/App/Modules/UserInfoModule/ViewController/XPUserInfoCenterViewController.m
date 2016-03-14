//
//  XPUserInfoCenterViewController.m
//  XPApp
//
//  Created by jy on 16/1/6.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "CExpandHeader.h"
#import "UIImage+XPCompress.h"
#import "UIView+block.h"
#import "XPAlertController.h"
#import "XPHeadView.h"
#import "XPLoginModel.h"
#import "XPModifyDataViewController.h"
#import "XPUserInfoCenterViewController.h"
#import "XPUserViewModel.h"
#import <AFNetworking/AFNetworking.h>
#import <AliyunOSSiOS/OSSCompat.h>
#import <AliyunOSSiOS/OSSService.h>
#import <XPKit/XPKit.h>
#import <UIImageView+WebCache.h>
#import "XPChangeUserMobileViewController.h"
#import "XPUser.h"

@interface XPUserInfoCenterViewController ()<UITableViewDataSource, UITableViewDelegate, selectdelegate, XPAlertControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    CExpandHeader *header;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) XPHeadView *headView;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) XPModifyDataViewController *mode;
@property (nonatomic, strong) NSMutableArray *messageArray;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) OSSTask *putTask;
@property (nonatomic, strong) XPAlertController *alertViewController;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *ossUrl;
@property (nonatomic,strong) XPUser * user;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic) IBOutlet XPUserViewModel *viewModel;
#pragma clang diagnostic pop

@end

@implementation XPUserInfoCenterViewController
{
    NSTimer *timer;
}
#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    @weakify(self);
    [self rac_liftSelector:@selector(cleverLoader:) withSignals:RACObserve(self.viewModel, executing), nil];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        return [value localizedDescription];
    }], nil];
    _user = [[XPUser alloc] init];
    [self getUserMessage];
    _tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.delaysContentTouches = NO;
    _headView = [[[NSBundle mainBundle]loadNibNamed:@"XPHeadView" owner:nil options:nil]lastObject];
    _headView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 250);
    header = [CExpandHeader expandWithScrollView:_tableView expandView:_headView];
    [self.tableView bringSubviewToFront:self.headView];
    self.imageView = [_headView viewWithTag:9];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[XPLoginModel singleton].avatarUrl] placeholderImage:[UIImage imageNamed:@"common_default_avatar"]];
    [[[_headView viewWithTag:11] rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self pop];
    }];
    [self.imageView whenTapped:^{
        _alertViewController = [[XPAlertController alloc]initWithActivity:@[@"拍照", @"从相册上传"]];
        _alertViewController.delegate = self;
        [_alertViewController show];
    }];
    [[RACObserve(self.viewModel, successMessage) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self hideLoader];
        [XPLoginModel singleton].avatarUrl = self.ossUrl;
        _user.avatarUrl = self.ossUrl;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.ossUrl] placeholderImage:[UIImage imageNamed:@"common_default_avatar"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserInfoDeatailRefreshNotification" object:nil];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"UserInfoDeatailRefreshNotification" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"XPModifyDataViewController"]) {
        XPModifyDataViewController *mode = segue.destinationViewController;
        mode.row = _selectIndex;
        mode.sex = _messageArray[1];
        mode.delegate = self;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - UITableViewDataSource&Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UILabel *detailLa = [cell viewWithTag:10];
    UILabel *messageLa = [cell viewWithTag:11];
    if (indexPath.row<4) {
        messageLa.text = [_messageArray objectAtIndex:indexPath.row];
    }else{
        messageLa.text = [NSString stringWithFormat:@"%ld",(long)[XPLoginModel singleton].point];
    }
    if (indexPath.row==3) {
        messageLa.text = [[_messageArray lastObject] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    detailLa.text = [self loadTitleForIndexPathRow:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectIndex = indexPath.row;
    if(indexPath.row == 0 || indexPath.row == 1) {
        [self performSegueWithIdentifier:@"XPModifyDataViewController" sender:self];
    } else if(indexPath.row == 2) {
        [self presentBindHouse];
    }else if(indexPath.row==3){
        [self performSegueWithIdentifier:@"XPChangeUserMobileViewController" sender:self];
    }else{
    [self pushViewController:[self instantiateViewControllerWithStoryboardName:@"IntegralExchange" identifier:@"XPIntegralExchangeViewController"]];
    }
}

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

#pragma mark - UIImagePickerDelegate
- (void)pickImageIfTakeNew:(BOOL)takeNew
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = takeNew ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [[self.view belongViewController] presentViewController:picker animated:YES completion:nil];
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
    
    [self postRemoteImageData:editedImage.xp_compress];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UpLoad
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
    [self showLoader];
    OSSClient *client = [self ossClient];
    OSSPutObjectRequest *put = [OSSPutObjectRequest new];
    //    md5(上传图片时时间戳_用户ID_平台类型_获取用户信息或登录时间戳)
    NSString *fileName = [[NSString stringWithFormat:@"%ld_%@_iOS_%@", (long)[[NSDate date] timeIntervalSince1970], [XPLoginModel singleton].userId, [XPLoginModel singleton].timestamp] MD5];
    fileName = [fileName stringByAppendingString:@".jpg"];
    put.bucketName = @"sharemerge-images";
    put.objectKey = fileName;
    put.uploadingData = imageData;
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    };
    put.contentType = @"";
    put.contentMd5 = @"";
    put.contentEncoding = @"";
    put.contentDisposition = @"";
    
    self.putTask = [client putObject:put];
    __weak typeof(self
                  ) weakSelf = self;
    [self.putTask continueWithBlock:^id (OSSTask *task) {
        if(!task.error) {

            [self hideLoader];
            weakSelf.ossUrl = [NSString stringWithFormat:@"http://sharemerge-images.oss-cn-shanghai.aliyuncs.com/%@", put.objectKey];
            weakSelf.viewModel.avataUrl = weakSelf.ossUrl;
            weakSelf.viewModel.nickName = [XPLoginModel singleton].nickname;
            weakSelf.viewModel.gender = [[XPLoginModel singleton].gender integerValue];
            [weakSelf.viewModel.updateCommand execute:nil];
        } else {
            [self showToast:@"头像上传失败"];
            [self hideLoader];
        }
        
        return nil;
    }];
}

#pragma mark - Event Responds

#pragma mark - SelectDelegate
- (void)selectMessage:(NSString *)text
{
    if(text.length == 0) {
        return;
    }
    if(_selectIndex == 0) {
        _messageArray[0] = text;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        _messageArray[1] = text;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Private Methods
- (NSString *)loadTitleForIndexPathRow:(NSInteger)row
{
    switch(row) {
        case 0: {
            return @"昵称";
        }
            break;
            
        case 1: {
            return @"性别";
        }
            break;
            
        case 2: {
            return @"房屋信息";
        }
            break;
            
        case 3: {
            return @"手机";
        }
        case 4:{
            return @"积分兑换";
        }
            break;
    }
    return nil;
}

- (NSString *)getSexForGender:(NSString *)number
{
    if([number isEqualToString:@"0"]) {
        return @"男";
    }
    if([number isEqualToString:@"1"]) {
        return @"女";
    }
    if([number isEqualToString:@"2"]) {
        return @"保密";
    }
    
    return @"";
}

- (void)getUserMessage
{
    _messageArray = [NSMutableArray array];
    _messageArray[0] = [XPLoginModel singleton].nickname;
    _messageArray[1] = [self getSexForGender:[XPLoginModel singleton].gender];
    _messageArray[2] = [NSString stringWithFormat:@"%@%@",[XPLoginModel singleton].household.unit, [XPLoginModel singleton].household.room];
    _messageArray[3] = [XPLoginModel singleton].mobile;
}

#pragma mark - Getter & Setter

@end
