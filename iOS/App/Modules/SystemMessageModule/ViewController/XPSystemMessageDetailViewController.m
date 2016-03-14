//
//  XPSystemMessageDetailViewController.m
//  XPApp
//
//  Created by jy on 16/1/18.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPSystemMessageDetailViewController.h"
#import "UIView+HESizeHeight.h"
#import <NSDate+DateTools.h>

@interface XPSystemMessageDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation XPSystemMessageDetailViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myTableView.separatorColor = [UIColor clearColor];
}

#pragma mark - Delegate
#pragma mark - UITableViewDelegateAndDatasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
    if(!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailCell" owner:nil options:nil] lastObject];
    }
    UILabel * contentLabel = [cell viewWithTag:21];
    contentLabel.text = _systemMessageModel.content;
    UILabel * dateLabel = [cell viewWithTag:22];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_systemMessageModel.createdAt.doubleValue];
    dateLabel.text = [date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float contentHeight = [UIView getTextSizeHeight:_systemMessageModel.content font:14 withSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 30, MAXFLOAT)];
    return contentHeight + 54;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


#pragma mark - Event Responds

#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end 
