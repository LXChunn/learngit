//
//  XPCarpoolingsTableViewCell.m
//  XPApp
//
//  Created by iiseeuu on 16/2/22.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPCarpoolingsTableViewCell.h"
#import "XPCarpoolModel.h"
#import <DateTools/DateTools.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <XPKit/XPKit.h>
#import <UIImageView+WebCache.h>

@interface XPCarpoolingsTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *starPointLabel;
@property (weak, nonatomic) IBOutlet UILabel *endPointLabel;
@property (weak, nonatomic) IBOutlet UILabel *starTimeLabel;
@property (nonatomic, strong) XPCarpoolModel *model;

@end



@implementation XPCarpoolingsTableViewCell


-(void)awakeFromNib
{
     @weakify(self);

     RAC(self.nickNameLabel, text) = [RACObserve(self, model.author.nickname) ignore:nil];
     RAC(self.starPointLabel, text) = [RACObserve(self, model.startPoint) ignore:nil];
     RAC(self.endPointLabel, text) = [RACObserve(self, model.endPoint) ignore:nil];
 
     RAC(self.starTimeLabel, text) = [[RACObserve(self, model.time) ignore:nil] map:^id (id value) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        return [date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
    }];
    
    [[RACObserve(self, model.author.avatarUrl) ignore:nil] subscribeNext:^(id x) {
    @strongify(self);
        self.iconImageView.clipsToBounds = YES;
        self.iconImageView.layer.cornerRadius = 19;
      [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:x]placeholderImage:[UIImage imageNamed:@"common_default_avatar"]];
    }];
    
}





- (void)bindModel:(id)model
{
    NSParameterAssert([model isKindOfClass:[XPCarpoolModel class]]);
    self.model = model;
}

@end
