//
//  XPMeViewController.m
//  XPApp
//
//  Created by huangxinping on 15/10/17.
//  Copyright © 2015年 iiseeuu.com. All rights reserved.
//

#import "XPMeViewController.h"
#import <XPKit/XPKit.h>

@interface XPMeViewController ()<UITableViewDelegate, UITableViewDataSource>
{
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation XPMeViewController

#pragma mark - LifeCircle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView hideEmptySeparators];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - Delegate
#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 2) {
        return 2;
    }
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return 1.0f;
    }
    
    return 10.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell_%ld_%ld", (long)indexPath.section, (long)indexPath.row] forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
