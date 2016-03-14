//
//  XPDetailConvenienceStoreViewController.m
//  XPApp
//
//  Created by iiseeuu on 16/1/18.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPDetailConvenienceStoreViewController.h"
#import "XPDetailConvenienctStoreTableViewCell.h"
#import "XPConvenienceStoreModel.h"
#import "UIView+HESizeHeight.h"
#import "XPDetailImageConvenienceStoreTableViewCell.h"
#define BoundsWidth [UIScreen mainScreen].bounds.size.width
@interface XPDetailConvenienceStoreViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *touchWithButton;
@property (weak, nonatomic) IBOutlet UIView *linkButtonView;

@property (weak, nonatomic) IBOutlet UIView *middleView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *linkButtonViewNSLayoutConstraint;
@property (nonatomic,assign)CGFloat contentHeight;
@property (nonatomic,assign)CGFloat titleHeight;

@end

@implementation XPDetailConvenienceStoreViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"商品详情";
    UIImage *image = [UIImage imageNamed:@"community_store_button"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_touchWithButton setImage:image forState:UIControlStateNormal];
    _touchWithButton.tintColor = [UIColor colorWithHexString:@"#0468B4"];
    self.linkButtonView.userInteractionEnabled = YES;
    self.middleView.userInteractionEnabled = YES;
    [self.linkButtonView whenTapped:^{
        NSMutableString *phone = [[NSMutableString alloc] initWithFormat:@"telprompt://%@", self.detaiModel.telephone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
    }];

    [self.middleView whenTapped:^{
        NSMutableString *phone = [[NSMutableString alloc] initWithFormat:@"telprompt://%@", self.detaiModel.telephone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
    }];
    
    if ([self.detaiModel.telephone isEqualToString:@""]) {
        self.linkButtonViewNSLayoutConstraint.constant = 0;
    }

}

#pragma mark - Delegate
#pragma mark - UITableView Deleagate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        XPDetailImageConvenienceStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPDetailImageConvenienceStoreTableViewCell" forIndexPath:indexPath];
        cell.detailModel = _detaiModel;
        return cell;
    }else{
        XPDetailConvenienctStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPDetailConvenienctStoreTableViewCell" forIndexPath:indexPath];
        cell.detailModel = _detaiModel;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.contentHeight = [UIView getTextSizeHeight:_detaiModel.content font:14 withSize:CGSizeMake(BoundsWidth - 20, MAXFLOAT)];
    self.titleHeight = [UIView getTextSizeHeight:_detaiModel.title font:16 withSize:CGSizeMake(BoundsWidth - 19, MAXFLOAT)];
    
    if (indexPath.row==0) {
        if (_detaiModel.picUrls.count>0) {
            return BoundsWidth * 2/3;
        }else{
            return 0;
        }
    }else {
        return _titleHeight+_contentHeight+71+13;
    }
}
#pragma mark - Event Responds
#pragma mark - Private Methods
#pragma mark - Getter & Setter

@end 
