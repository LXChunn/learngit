//
//  XPDatePickerView.h
//  XPApp
//
//  Created by jy on 15/12/11.
//  Copyright © 2015年 iiseeuu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XPDatePickerView : UIView

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end
