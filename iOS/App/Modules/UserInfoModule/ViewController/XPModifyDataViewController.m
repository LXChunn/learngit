//
//  XPModifyDataViewController.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/6.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+XPChangeUserIn.h"
#import "XPLoginModel.h"
#import "XPModifyDataViewController.h"
#import "XPUserViewModel.h"
#import "XPUser.h"

@interface XPModifyDataViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *nikeView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger selectIndex;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic) IBOutlet XPUserViewModel *viewModel;
#pragma clang diagnostic pop
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableArray *messageArray;
@property (nonatomic, strong) XPUser *user;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, assign) NSInteger whiteSpaceLength;
@property (nonatomic, assign) BOOL isChange;
@end

@implementation XPModifyDataViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    switch(self.row) {
        case 0: {
            self.tableView.hidden = YES;
            self.title = @"修改昵称";
        }
            break;
            
        case 1: {
            self.nikeView.hidden = YES;
            self.title = @"修改性别";
        }
    }
    @weakify(self);
    [self rac_liftSelector:@selector(cleverLoader:) withSignals:RACObserve(self.viewModel, executing), nil];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        return [value localizedDescription];
    }], nil];
    [self getUserMessage];
    _user = [[XPUser alloc] init];
    _tableView.tableFooterView = [[UIView alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _array = [NSMutableArray arrayWithObjects:@"男", @"女", @"保密", nil];
    self.selectIndex = [self.array indexOfObject:self.sex];
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    [_textField addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
    _nikeView.layer.cornerRadius = 4;
    [[RACObserve(self.viewModel, successMessage) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        if (self.isChange) {
            [XPLoginModel singleton].nickname = _nickName;
        }
        [XPLoginModel singleton].gender = _array[_selectIndex];
        self.user.nickname = [XPLoginModel singleton].nickname;
        self.user.gender = [XPLoginModel singleton].gender;
        [self showToast:self.viewModel.successMessage];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserInfoDeatailRefreshNotification" object:nil];
        
        if([self.delegate respondsToSelector:@selector(selectMessage:)]) {
            if(_row == 0) {
                [self.delegate selectMessage:_nickName];
            }
            if(_row == 1) {
                [self.delegate selectMessage:_array[_selectIndex]];
            }
        }
        [self pop];
    }];
}

#pragma mark UITableViewDelgegate&DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailcell" forIndexPath:indexPath];
    UILabel *sexlabel = [cell viewWithTag:20];
    UIImageView *iv = [cell viewWithTag:21];
    if(self.selectIndex == indexPath.row) {
        iv.image = [UIImage imageNamed:@"common_radio_selected"];
    } else {
        iv.image = [UIImage imageNamed:@"common_radio_normal"];
    }
    
    sexlabel.text = _array[indexPath.row];
    tableView.separatorColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:_selectIndex inSection:0]];
    UIImageView *laseImgView = [lastCell viewWithTag:21];
    laseImgView.image = [UIImage imageNamed:@"common_radio_normal"];
    
    _selectIndex = indexPath.row;
    
    UITableViewCell *selectCell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *selectImageView = [selectCell viewWithTag:21];
    selectImageView.image = [UIImage imageNamed:@"common_radio_selected"];
}

#pragma mark - Event Responds
- (IBAction)SureRequest:(id)sender
{
    [self.view endEditing:YES];
    self.viewModel.avataUrl = [XPLoginModel singleton].avatarUrl;
    self.viewModel.gender = [self getNuForGender:_array[_selectIndex]];
    if (self.isChange) {
        self.viewModel.nickName = _nickName;
    }else{
        self.viewModel.nickName = _textField.text;
    }
    [self.viewModel.updateCommand execute:nil];
}

- (void)valueChange:(UITextField *)textField
{
    if (textField == self.textField) {
        self.isChange = YES;
        _nickName = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.whiteSpaceLength = self.textField.text.length-_nickName.length;
        if (self.nickName.length>15) {
            textField.text = [textField.text substringToIndex:16+self.whiteSpaceLength];
        }
    }
}

#pragma mark - Private Methods
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

- (NSInteger)getNuForGender:(NSString *)sex
{
    if([sex isEqualToString:@"男"]) {
        return 0;
    }
    if([sex isEqualToString:@"女"]) {
        return 1;
    }
    
    return 2;
}

- (void)getUserMessage
{
    _messageArray = [NSMutableArray array];
    _messageArray[0] = [XPLoginModel singleton].nickname;
    _messageArray[1] = [self getSexForGender:[XPLoginModel singleton].gender];
    _messageArray[2] = [NSString stringWithFormat:@"%@%@%@", [XPLoginModel singleton].household.communityTitle, [XPLoginModel singleton].household.unit, [XPLoginModel singleton].household.room];
    _messageArray[3] = [XPLoginModel singleton].mobile;
    _textField.text = [XPLoginModel singleton].nickname;
}
@end
