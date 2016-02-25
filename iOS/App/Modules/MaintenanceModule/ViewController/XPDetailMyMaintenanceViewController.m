//
//  XPDetailMyMaintenanceViewController.m
//  XPApp
//
//  Created by iiseeuu on 15/12/25.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPDetailMyMaintenanceViewController.h"
#import <SDWebImage-ProgressView/UIImageView+ProgressView.h>
#import <DateTools/DateTools.h>
#import "XPDetailImageShowView.h"
#import "XPMoreOptionsViewController.h"

@interface XPDetailMyMaintenanceViewController ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *tiemLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet XPDetailImageShowView *detailImageView;
@property (weak, nonatomic) IBOutlet UIButton *buttonText;
@property (nonatomic,strong)NSArray *imageUrlArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightLayoutConstraint;

@end


@implementation XPDetailMyMaintenanceViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"模型中的数据：%@",self.detailModel);
    [self initUI];

}


-(void)initUI
{
    self.contentLabel.text = self.detailModel.content;
  
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.detailModel.createdAt.doubleValue];
     self.tiemLabel.text = [date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
    if ( !_detailModel.picUrls) {
        self.imageHeightLayoutConstraint.constant = 0;
    }else{
        self.imageHeightLayoutConstraint.constant = 110;
    }
    self.imageUrlArray = self.detailModel.picUrls;
    [_detailImageView loadUIWithImagesArray:_imageUrlArray];
    [[RACObserve(self, detailModel.status) ignore:nil] subscribeNext:^(id x) {
        switch ([x intValue]){
            case 1:
                 self.statusLabel.text = @"待处理";
                [self.buttonText setTitle:@"取消报修" forState:UIControlStateNormal];
                break;
            case 2:
                self.statusLabel.text = @"处理中";
                [self.buttonText setTitle:@"确认完成" forState:UIControlStateNormal];
                break;
            case 3:
                self.statusLabel.text = @"已处理";
                [self.buttonText setTitle:@"确认完成" forState:UIControlStateNormal];
                break;
            case 100:
                self.statusLabel.text = @"确认";
                [self.buttonText setHidden:YES];
                break;
            default:
            break;}
    }];
}


#pragma mark - Delegate

#pragma mark - Event Responds

#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end 
