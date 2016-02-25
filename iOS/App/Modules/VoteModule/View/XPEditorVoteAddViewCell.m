//
//  XPEditorVoteAddViewCell.m
//  XPApp
//
//  Created by Mac OS on 16/1/4.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPEditorVoteAddViewCell.h"

@interface XPEditorVoteAddViewCell ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation XPEditorVoteAddViewCell

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPEditorVoteAddViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
}

- (IBAction)addChooesButton:(UIButton *)sender
{
    
}

@end
