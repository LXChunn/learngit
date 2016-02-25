//
//  XPMaintenanceViewController.m
//  XPApp
//
//  Created by xinpinghuang on 12/23/15.
//  Copyright 2015 ShareMerge. All rights reserved.
//

#import "XPAddImageView.h"
#import "XPAlertController.h"
#import "XPMaintenanceSubmitViewController.h"
#import "XPMaintenanceViewModel.h"
#import <ARAlertController/ARAlertController.h>
#import <Masonry/Masonry.h>
#import <XPTextView/XPTextView.h>

@interface XPMaintenanceViewController ()<XPAlertControllerDelegate>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic) IBOutlet XPMaintenanceViewModel *viewModel;
#pragma clang diagnostic pop

@property (weak, nonatomic) IBOutlet XPTextView *textView;
@property (weak, nonatomic) IBOutlet XPAddImageView *addImageView;
@property (weak, nonatomic) IBOutlet UIButton *typeButton;
@property (nonatomic, strong) XPAlertController *alertController;
@property (nonatomic, strong) NSArray *typeArray;

@end

@implementation XPMaintenanceViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textView.placeholder = @"请描述您需要报修的状况";
    self.typeArray = @[@"供水报修", @"供电报修", @"燃气报修", @"其他报修"];
    
    RAC(self.viewModel, content) = self.textView.rac_textSignal;
    self.navigationItem.rightBarButtonItem.rac_command = self.viewModel.submitCommand;
    
    @weakify(self);
    RAC(self.viewModel, picUrls) = [RACObserve(self, addImageView.uploadFinshed) map:^id (id value) {
        return [value boolValue] ? self.addImageView.urls : nil;
    }];
    
    [self rac_liftSelector:@selector(cleverLoader:) withSignals:RACObserve(self.viewModel, executing), nil];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        return [value localizedDescription];
    }], nil];
    
    [[self.typeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self typeButtonTaped];
    }];
    
    [[RACObserve(self, viewModel.submitFinished) ignore:@(NO)] subscribeNext:^(id x) {
        @strongify(self);
        [self pop];
    }];
}

#pragma mark - Delegate
#pragma mark - XPAlertControllerDelegate
- (void)alertController:(XPAlertController *)alertController didSelectRow:(NSInteger)row
{
    [self.typeButton setTitle:self.typeArray[row] forState:UIControlStateNormal];
    switch(row) {
        case 0:
        case 1:
        case 2: {
            self.viewModel.type = [NSString stringWithFormat:@"%ld", (long)row+1];
        }
            break;
            
        case 3: {
            self.viewModel.type = @"100";
        }
            break;
            
        default: {
        }
            break;
    }
}

#pragma mark - Event Responds
- (void)typeButtonTaped
{
    self.alertController = [[XPAlertController alloc] initWithActivity:self.typeArray];
    self.alertController.delegate = self;
    [self.alertController show];
}

#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end
