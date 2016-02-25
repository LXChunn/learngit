//
//  XPCommonTableViewCell.m
//  XPApp
//
//  Created by iiseeuu on 15/12/29.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPCommonTableViewCell.h"
#import "XPTopicModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <XPKit/XPKit.h>
#import <DateTools/DateTools.h>
#import <UIImageView+AFNetworking.h>
@interface XPCommonTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightLayoutConstraint;

@property(nonatomic,strong)XPTopicModel*model;

@end

@implementation XPCommonTableViewCell

-(void)awakeFromNib
{
    RAC(self.titleLabel,text) = [RACObserve(self, model.title) ignore:nil];
    RAC(self.nicknameLabel,text) = [RACObserve(self, model.author.nickname) ignore:nil];
    RAC(self.commentCountLabel,text) = [RACObserve(self, model.commentsCount) ignore:nil];
    RAC(self.timeLabel,text) = [[RACObserve(self, model.createdAt) ignore:nil] map:^id(id value) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.model.createdAt.doubleValue];
        return[date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
    }];
}

- (void)configureImageView
{
    for (UIImageView * imageView in self.view.subviews)
    {
        [imageView removeFromSuperview];
    }
    self.imageHeightLayoutConstraint.constant = 94;
    if (self.model.extra.picUrls.count>3) {
        for (int i = 0; i<3; i++){
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(i*94+i*20, 0, 94, 94)];
            [image setImageWithURL:[NSURL URLWithString:self.model.extra.picUrls[i]]];
            [self.view addSubview:image];
        }
        
    }else if(self.model.extra.picUrls.count>0){
        for (int i = 0; i<self.model.extra.picUrls.count; i++){
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(i*94+i*20, 0, 94, 94)];
            [image setImageWithURL:[NSURL URLWithString:self.model.extra.picUrls[i]]];
            [self.view addSubview:image];
        }
    }else{
        self.imageHeightLayoutConstraint.constant = 0;
    }
}

-(void)bindModel:(id )model
{
    NSParameterAssert([model isKindOfClass:[XPTopicModel class]]);
    self.model = model;
    [self configureImageView];
}


@end
