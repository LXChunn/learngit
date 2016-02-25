//
//  XPAnnouncementViewController.m
//  XPApp
//
//  Created by iiseeuu on 15/12/19.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPAnnouncementModel.h"
#import "XPAnnouncementViewController.h"
#import "XPAnnouncementViewModel.h"
#import "XPCommnityTableViewCell.h"
#import "XPDetailAnnounceViewController.h"
@interface XPAnnouncementViewController () <UITableViewDelegate, UITableViewDataSource>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic) IBOutlet XPAnnouncementViewModel *viewModel;
#pragma clang diagnostic pop
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *announceTitle;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *noticeButton;

@end

@implementation XPAnnouncementViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self rac_liftSelector:@selector(cleverLoader:) withSignals:RACObserve(self.viewModel, executing), nil];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        return [value localizedDescription];
    }], nil];
    
    @weakify(self);
    [[RACObserve(self.viewModel, list) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    [self.viewModel.listCommand execute:nil];
    [self.tableView hideEmptySeparators];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"embed_detail"]) {
        XPDetailAnnounceViewController *detailViewController = segue.destinationViewController;
        UITableViewCell *cell = [self.tableView selectedCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        detailViewController.detailModel = self.viewModel.list[indexPath.row];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Delegate
#pragma mark - UITableView Deleagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XPCommnityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [cell bindModel:self.viewModel.list[indexPath.row]];
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Community" bundle:nil];
//   XPDetailAnnounceViewController *detail = [mainStoryboard instantiateViewControllerWithIdentifier:@"detail"];
//    detail.detailModel = self.viewModel.list[indexPath.row];
//    [self.navigationController pushViewController:detail animated:YES];
//}
#pragma mark - Event Responds

#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end
