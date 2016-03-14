//
//  XPDetailContentTableViewCell.m
//  XPApp
//
//  Created by iiseeuu on 15/12/31.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPDetailContentTableViewCell.h"
#import "XPDetailImageShowView.h"
#import "XPDetailPostModel.h"
#import <DateTools/DateTools.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <XPKit/XPKit.h>

@interface XPDetailContentTableViewCell ()
@property (weak, nonatomic) IBOutlet XPDetailImageShowView *detailImageView;
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *content;
@property (nonatomic, strong) XPDetailPostModel *model;

@end

@implementation XPDetailContentTableViewCell

- (void)awakeFromNib
{
    self.detailImageView.contentMode = UIViewContentModeScaleAspectFill;
    RAC(self.title, text) = [RACObserve(self, model.title) ignore:nil];
    RAC(self.content, text) = [RACObserve(self, model.content) ignore:nil];
    [RACObserve(self, model.extra.picUrls) subscribeNext:^(id x) {
        [_detailImageView loadUIWithImagesArray:x];
    }];
}

- (void)bindModel:(id)model
{
    if(!model) {
        return;
    }
    
    NSParameterAssert([model isKindOfClass:[XPDetailPostModel class]]);
    self.model = model;
}

@end
