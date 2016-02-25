//
//  XPComplaintViewController.m
//  XPApp
//
//  Created by xinpinghuang on 12/23/15.
//  Copyright 2015 ShareMerge. All rights reserved.
//

#import "XPAddImageView.h"
#import "XPComplaintViewController.h"
#import <Masonry/Masonry.h>
#import <XPTextView/XPTextView.h>

@interface XPComplaintViewController ()

@property (nonatomic, weak) IBOutlet XPTextView *textView;
@property (nonatomic, weak) IBOutlet XPAddImageView *addImageView;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@end

@implementation XPComplaintViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textView.placeholder = @"请描述您需要投诉的状况";
    
//    RAC(self.navigationItem.rightBarButtonItem, enabled) = [RACObserve(self, addImageView.uploadFinshed) map:^id (id value) {
//        return value;
//    }];
    [RACObserve(self, addImageView.uploadFinshed) subscribeNext:^(id x) {
        if([x boolValue]) {
            NSLog(@"全部上传成功后的文件URL：%@", self.addImageView.urls);
        }
    }];
}

#pragma mark - Delegate

#pragma mark - Event Responds

#pragma mark - Private Methods

#pragma mark - Getter & Setter

@end
