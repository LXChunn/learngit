//
//  XPEditorVoteViewController.m
//  XPApp
//
//  Created by Mac OS on 15/12/30.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPEditorVoteViewController.h"
#import "XPEditorVoteTableViewCell.h"
#import "XPVoteViewModel.h"
#import "XPVoteModel.h"
#import "XPReleaseVoteViewController.h"

@interface XPEditorVoteViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation XPEditorVoteViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView hideEmptySeparators];

}
#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPEditorVoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:YES animated:YES];
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:NO animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark - Event Responds

#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end