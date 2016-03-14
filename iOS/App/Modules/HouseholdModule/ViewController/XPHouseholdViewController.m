//
//  XPHouseholdViewController.m
//  XPApp
//
//  Created by xinpinghuang on 12/15/15.
//  Copyright 2015 ShareMerge. All rights reserved.
//

#import "XPHouseholdViewController.h"
#import "XPHouseholdViewModel.h"
#import "XPLoginModel.h"

@interface XPHouseholdViewController ()

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (strong, nonatomic) IBOutlet XPHouseholdViewModel *viewModel;
#pragma clang diagnostic pop
@property (weak, nonatomic) IBOutlet UITextField *verificationTextField;
@property (weak, nonatomic) IBOutlet UIButton *bindButton;
@property (weak, nonatomic) IBOutlet UILabel *bindTipLabel;

@end

@implementation XPHouseholdViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    @weakify(self);
    self.navigationItem.rightBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id < RACSubscriber > subscriber) {
            @strongify(self);
            [subscriber sendNext:@(1)];
            [subscriber sendCompleted];
            [self dismissViewControllerAnimated:YES completion:nil];
            return nil;
        }];
    }];
    
    RAC(self.viewModel, verificationCode) = self.verificationTextField.rac_textSignal;
    self.bindButton.rac_command = self.viewModel.bindCommand;
    
    [self rac_liftSelector:@selector(cleverLoader:) withSignals:RACObserve(self.viewModel, executing), nil];
    [self rac_liftSelector:@selector(showToast:) withSignals:[[RACObserve(self.viewModel, error) ignore:nil] map:^id (id value) {
        return [value localizedDescription];
    }], nil];
    [[RACObserve(self.viewModel, model) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TopicRefreshNotification" object:nil];
        }];
    }];
    if ([XPLoginModel singleton].isBound) {
        _bindTipLabel.hidden = YES;
    }
}

#pragma mark - Delegate

#pragma mark - Event Responds

#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end
