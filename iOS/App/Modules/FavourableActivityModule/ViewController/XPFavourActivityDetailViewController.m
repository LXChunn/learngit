//
//  XPFavourActivityDetailViewController.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/18.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width-130
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#import "XPFavourActivityDetailViewController.h"
#import "XPMyFavActivityCell.h"
#import <UIImageView+WebCache.h>
#import "UIView+HESizeHeight.h"
#import "XPFirstFaouActivityCell.h"

@interface XPFavourActivityDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)UIImageView *imageView;
@end

@implementation XPFavourActivityDetailViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.scrollEnabled = NO;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorColor = [UIColor clearColor];
    self.navigationItem.title = @"详情";
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 99+(SCREENWIDTH-42)*11/38;
    }
    return [UIView getTextSizeHeight:self.sourceModel.content font:14 withSize:CGSizeMake(SCREENWIDTH - 25, MAXFLOAT)]+111;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
      XPFirstFaouActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell" forIndexPath:indexPath];
        UILabel *titlelabel = [cell viewWithTag:10];
        titlelabel.text = self.sourceModel.title;
        self.imageView = [cell viewWithTag:12];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.sourceModel.themePicUrl] placeholderImage:[UIImage imageNamed:@"common_ad_default"]];
        cell.imageViewLayout.constant = (SCREENWIDTH-42)*11/38;
        return cell;
    }
    if (indexPath.row == 1) {
        XPMyFavActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XPMyFavActivityCell"];
        if(!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"XPMyFavActivityCell" owner:nil options:nil] firstObject];
        }
        [cell detailBindModel:self.sourceModel];
        return cell;
    }
    return cell;
}
@end
