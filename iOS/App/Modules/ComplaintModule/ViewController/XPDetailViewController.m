//
//  XPDetailViewController.m
//  XPApp
//
//  Created by Mac OS on 15/12/28.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPDetailViewController.h"
#import <SDWebImage-ProgressView/UIImageView+ProgressView.h>
#import <DateTools/DateTools.h>

@interface XPDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *statusLable;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonType;

@property (nonatomic,strong)NSArray *imageUrlArray;


@end

@implementation XPDetailViewController

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
    self.timeLable.text = [date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
    self.imageUrlArray = self.detailModel.picUrls;
    
    [[RACObserve(self, detailModel.status) ignore:nil] subscribeNext:^(id x) {
        switch ([x intValue]){
            case 1:
                self.statusLable.text = @"待处理";
                [self.buttonType setTitle:@"取消投诉" forState:UIControlStateNormal];
                break;
            case 2:
                self.statusLable.text = @"处理中";
                [self.buttonType setTitle:@"确认完成" forState:UIControlStateNormal];
                break;
            case 3:
                self.statusLable.text = @"已处理";
                [self.buttonType setTitle:@"确认完成" forState:UIControlStateNormal];
                break;
            case 4:
                self.statusLable.text = @"确认";
                [self.buttonType setHidden:YES];
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
