//
//  XPJFZDViewController.m
//  XPApp
//
//  Created by Mac OS on 15/12/19.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPPropertyBillModel.h"
#import "XPPropertyBillTableViewCell.h"
#import "XPPropertyBillViewController.h"
#import "XPPropertyBillViewModel.h"

@interface XPPropertyBillViewController () <UITableViewDelegate, UITableViewDataSource>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic) IBOutlet XPPropertyBillViewModel *viewModel;
#pragma clang diagnostic pop
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UILabel *swipeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightStateLable;
@property (weak, nonatomic) IBOutlet UILabel *leftStateLable;
@property (weak, nonatomic) IBOutlet UIImageView *commonImage;
@property (weak, nonatomic) IBOutlet UILabel *longCommonLable;

@property (assign, nonatomic) NSInteger stutaType;

@end

@implementation XPPropertyBillViewController

@synthesize leftSwipeGestureRecognizer, rightSwipeGestureRecognizer;

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.stutaType = 0;
    [self rac_liftSelector:@selector(cleverLoader:) withSignals:RACObserve(self.viewModel, executing), nil];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        return [value localizedDescription];
    }], nil];
    
    @weakify(self);
    [[RACObserve(self.viewModel, list) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    self.leftView.backgroundColor = [UIColor blueColor];
    self.rightView.backgroundColor = [UIColor whiteColor];
    self.leftStateLable.textColor = [UIColor blueColor];
    self.rightStateLable.textColor = [UIColor blackColor];
    self.commonImage.image = [UIImage imageNamed:@"login_right_line"];
    [self.viewModel.listCommand execute:nil];
    
    /*
     *添加左右滑动手势
     *
     */
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
    [self.tableView hideEmptySeparators];
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
    XPPropertyBillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell bindModel:self.viewModel.list[indexPath.row]];
    
    XPPropertyBillModel *model = self.viewModel.list[self.stutaType];
    if(![model.status intValue] == 0) {
        cell.amountLabel.text = model.amount;
        cell.titleLabel.text = model.title;
    } else {
        cell.amountLabel.text = model.amount;
        cell.titleLabel.text = model.title;
    }
    if([model.type intValue] == 1) {
        cell.iconImageView.image = [UIImage imageNamed:@"propertyill_global_type"];
    } else if([model.type intValue] == 2) {
        cell.iconImageView.image = [UIImage imageNamed:@"propertyill_park_type"];
    } else if([model.type intValue] == 3) {
        cell.iconImageView.image = [UIImage imageNamed:@"propertyill_water_type"];
    } else if([model.type intValue] == 4) {
        cell.iconImageView.image = [UIImage imageNamed:@"propertyill_health_type"];
    } else if([model.type intValue] == 100) {
        cell.iconImageView.image = [UIImage imageNamed:@"propertyill_health_type"];
    }
    
    return cell;
}

#pragma mark - Event Responds
#pragma mark - Swipe Gestures
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if(sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        self.leftView.backgroundColor = [UIColor whiteColor];
        self.rightView.backgroundColor = [UIColor blueColor];
        self.stutaType = 1;
        self.leftStateLable.textColor = [UIColor blackColor];
        self.rightStateLable.textColor = [UIColor blueColor];
        [self.tableView reloadData];
    }
    if(sender.direction == UISwipeGestureRecognizerDirectionRight) {
        self.leftView.backgroundColor = [UIColor blueColor];
        self.rightView.backgroundColor = [UIColor whiteColor];
        self.stutaType = 0;
        self.leftStateLable.textColor = [UIColor blueColor];
        self.rightStateLable.textColor = [UIColor blackColor];
        [self.tableView reloadData];
    }
}

#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end
