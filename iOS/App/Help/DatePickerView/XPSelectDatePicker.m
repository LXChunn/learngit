//
//  XPSelectDatePicker.m
//  XPApp
//
//  Created by jy on 15/12/11.
//  Copyright © 2015年 iiseeuu.com. All rights reserved.
//

#import "XPSelectDatePicker.h"
#define BOUNDWidth      [UIScreen mainScreen].bounds.size.width
#define BOUNDHeight     [UIScreen mainScreen].bounds.size.height
#define kPVH (BOUNDHeight*0.35 > 230 ? 230 : (BOUNDHeight*0.35 < 200 ? 200 : BOUNDHeight *0.35))

@interface XPSelectDatePicker ()
@property (nonatomic, strong) DateSelectBlock selectDateBlock;
@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) UIButton *bgButton;
@property (strong, nonatomic) XPDatePickerView *pickerView;

@end

@implementation XPSelectDatePicker

- (instancetype)init
{
    self = [super init];
    if(self) {
        _view = [[UIApplication sharedApplication].delegate window].rootViewController.view;
        //半透明背景按钮
        _bgButton = [[UIButton alloc] init];
        [_view addSubview:_bgButton];
        [_bgButton addTarget:self action:@selector(dismissDatePicker) forControlEvents:UIControlEventTouchUpInside];
        _bgButton.backgroundColor = [UIColor blackColor];
        _bgButton.alpha = 0.0;
        _bgButton.frame = CGRectMake(0, 0, BOUNDWidth, BOUNDHeight);
        
        //时间选择View
        _pickerView = [[NSBundle mainBundle] loadNibNamed:@"XPDatePickerView" owner:self options:nil].lastObject;
        [_view addSubview:_pickerView];
        _pickerView.frame = CGRectMake(10, BOUNDHeight, BOUNDWidth - 20, 185);
        [_pickerView.cancelButton addTarget:self action:@selector(dismissDatePicker) forControlEvents:UIControlEventTouchUpInside];
        [_pickerView.confirmButton addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _pickerView.datePicker.date = [NSDate date];
        _pickerView.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [self pushDatePicker];
    }
    
    return self;
}

- (void)loadPickerWithselectDateType:(SelectDateType)selectDateType
                    finishSelectDate:(DateSelectBlock)selectDateTimeBlock
{
    _selectDateBlock = selectDateTimeBlock;
    if(selectDateType == SelectDateTypeOfAfter) {
        _pickerView.datePicker.minimumDate = [NSDate date];
    } else if(selectDateType == SelectDateTypeOfBefore) {
        _pickerView.datePicker.maximumDate = [NSDate date];
    }
}

//确定
- (void)confirmBtnClick:(id)sender
{
    if(_selectDateBlock) {
        _selectDateBlock(_pickerView.datePicker.date);
    }
    
    [self dismissDatePicker];
}

//出现
- (void)pushDatePicker
{
    [_view endEditing:YES];
    __weak typeof(self
                  ) weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.pickerView.frame = CGRectMake(10, BOUNDHeight - 185 - 10, BOUNDWidth - 20, 185);
        weakSelf.pickerView.layer.cornerRadius = 8;
        weakSelf.bgButton.alpha = 0.2;
    }];
}

//消失
- (void)dismissDatePicker
{
    __weak typeof(self
                  ) weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.pickerView.frame = CGRectMake(0, BOUNDHeight, BOUNDWidth, 185);
        weakSelf.bgButton.alpha = 0.0;
    }
                     completion:^(BOOL finished) {
                         [weakSelf.pickerView removeFromSuperview];
                         [weakSelf.bgButton removeFromSuperview];
                     }];
}

@end
