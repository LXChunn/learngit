//
//  XPActivityTableViewCell.m
//  XPApp
//
//  Created by iiseeuu on 15/12/29.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPActivityTableViewCell.h"
#import "XPTopicModel.h"
#import <DateTools/DateTools.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <UIImageView+WebCache.h>
#import <XPKit/XPKit.h>

@interface XPActivityTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *participantCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statuImage;

@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightLayoutConstraint;

@property (nonatomic, strong) XPTopicModel *model;

@end

@implementation XPActivityTableViewCell

+ (NSInteger)cellHeightWithArray:(NSArray *)images
{
    float imageWidth = ([UIScreen mainScreen].bounds.size.width -20*2 -28*2)/3;
    if(images.count <= 0) {
        return 120;
    }
    
    return imageWidth + 126;
}

- (void)awakeFromNib
{
    self.typeImage.image = [ UIImage imageNamed:@"common_activity_label"];
    RAC(self.titleLabel, text) = [RACObserve(self, model.title) ignore:nil];
    RAC(self.nicknameLabel, text) = [RACObserve(self, model.author.nickname) ignore:nil];
    RAC(self.participantCountLabel, text) = [RACObserve(self, model.participantStr) ignore:nil];
    RAC(self.commentCountLabel, text) = [RACObserve(self, model.commentsCount) ignore:nil];
    RAC(self.timeLabel, text) = [[RACObserve(self, model.createdAt) ignore:nil] map:^id (id value) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.model.createdAt.doubleValue];
        return [date formattedDateWithFormat:@"YYYY-MM-dd hh:mm"];
    }];
    self.typeImage.image = [ UIImage imageNamed:@"common_activity_label"];
    NSDate *createtime = [NSDate dateWithTimeIntervalSince1970:self.model.createdAt.doubleValue];
    NSDate *datestart = [NSDate dateWithTimeIntervalSince1970:self.model.extra.startDate.doubleValue];
    NSDate *dateend = [NSDate dateWithTimeIntervalSince1970:self.model.extra.endDate.doubleValue];
    if(createtime > datestart && createtime < dateend) {
        self.statuImage.image = [UIImage imageNamed:@"common_doing_label"];
    } else if(datestart >= createtime) {
        self.statuImage.image = [UIImage imageNamed:@"common_todo_label"];
    } else if(createtime >= dateend) {
        self.statuImage.image = [UIImage imageNamed:@"common_done_label"];
    }
}

- (void)configureImageView
{
    for(UIImageView *imageView in self.view.subviews) {
        [imageView removeFromSuperview];
    }
    float imageWidth = ([UIScreen mainScreen].bounds.size.width - 28*2 - 20*2)/3;
    self.imageHeightLayoutConstraint.constant = imageWidth;
    if(self.model.extra.picUrls.count > 3) {
        for(int i = 0; i < 3; i++) {
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(i*(imageWidth + 20), 0, imageWidth, imageWidth)];
            image.contentMode = UIViewContentModeScaleAspectFill;
            image.clipsToBounds = YES;
            [image sd_setImageWithURL:[NSURL URLWithString:self.model.extra.picUrls[i]] placeholderImage:[UIImage imageNamed:@"common_list_default"]];
            [self.view addSubview:image];
        }
    } else if(self.model.extra.picUrls.count > 0) {
        for(int i = 0; i < self.model.extra.picUrls.count; i++) {
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(i*imageWidth+i*20, 0, imageWidth, imageWidth)];
            image.contentMode = UIViewContentModeScaleAspectFill;
            image.clipsToBounds = YES;
            [image sd_setImageWithURL:[NSURL URLWithString:self.model.extra.picUrls[i]] placeholderImage:[UIImage imageNamed:@"common_list_default"]];
            [self.view addSubview:image];
        }
    } else {
        self.imageHeightLayoutConstraint.constant = 0;
    }
}


- (void)bindModel:(id)model
{
    NSParameterAssert([model isKindOfClass:[XPTopicModel class]]);
    self.model = model;
    self.model.participantStr = [NSString stringWithFormat:@"%@人参与", self.model.extra.participantsCount];
    [self configureImageView];
    [self configureTipUI];
}

- (void)configureTipUI
{
    NSString *nowTime = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    if(self.model.extra.endDate.length < 1) {
        if([self.model.extra.startDate integerValue] > [nowTime integerValue]) {
            self.statuImage.image = [UIImage imageNamed:@"common_todo_label"];
        } else {
            self.statuImage.image = [UIImage imageNamed:@"common_doing_label"];
        }
    } else {
        if([self.model.extra.endDate integerValue] < [nowTime integerValue]) {
            self.statuImage.image = [UIImage imageNamed:@"common_done_label"];
        } else {
            if([self.model.extra.startDate integerValue] > [nowTime integerValue]) {
                self.statuImage.image = [UIImage imageNamed:@"common_todo_label"];
            } else {
                self.statuImage.image = [UIImage imageNamed:@"common_doing_label"];
            }
        }
    }
}

- (void)hideen
{
    self.nicknameLabel.text = @"";
    self.participantCountLabel.text = @"";
    self.participantCountLabel.hidden = YES;
}

- (void)hideenForNeighborhood
{
    self.participantCountLabel.hidden = YES;
}

- (void)ForMyPostBindModel:(id)model
{
    NSParameterAssert([model isKindOfClass:[XPTopicModel class]]);
    self.model = model;
    self.model.participantStr = [NSString stringWithFormat:@"%@人参与", self.model.extra.participantsCount];
    [self configureImageView];
    [self ForMyPostconfigureStatus];
}

- (void)ForMyCollectBindModel:(id)model
{
    NSParameterAssert([model isKindOfClass:[XPTopicModel class]]);
    self.model = model;
    self.model.participantStr = [NSString stringWithFormat:@"%@人参与", self.model.extra.participantsCount];
    [self configureImageView];
    [self ForMyCollecconfigureStatus];
}


- (void)ForMyPostconfigureStatus
{
    NSString *nowTime = [NSString stringWithFormat:@"%@",[NSDate date]];
    long long now = [[self stringByReplacingOccurrence:nowTime] longLongValue]+800000000;
    long long start = [[self stringByReplacingOccurrence:self.model.extra.startDate] longLongValue];
    long long end = [[self stringByReplacingOccurrence:self.model.extra.endDate] longLongValue];
        if (now > end) {
            self.statusImage.image = [UIImage imageNamed:@"common_done_label"];
        }
        if (now<start) {
            self.statusImage.image = [UIImage imageNamed:@"common_todo_label"];
        }
        if (end==0&&now>start) {
            self.statusImage.image = [UIImage imageNamed:@"common_doing_label"];
        }
        if (now>start) {
            self.statusImage.image = [UIImage imageNamed:@"common_doing_label"];
        }
}

- (void)ForMyCollecconfigureStatus
{
    NSString *nowTime = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    int now = [nowTime intValue];
    int start = [self.model.extra.startDate intValue];
    int end = [self.model.extra.endDate intValue];
    if (end>0) {
        if (now > start||now<end) {
            self.statuImage.image = [UIImage imageNamed:@"common_doing_label"];
        }
        if (now > end) {
            self.statusImage.image = [UIImage imageNamed:@"common_done_label"];
        }
    }else{
        if (now>start) {
            self.statusImage.image = [UIImage imageNamed:@"common_doing_label"];
        }
    }
    if (now<start) {
        self.statusImage.image = [UIImage imageNamed:@"common_todo_label"];
    }
}

- (NSString *)stringByReplacingOccurrence:(NSString *)need
{
    need = [need stringByReplacingOccurrencesOfString:@"-" withString:@""];
    need = [need stringByReplacingOccurrencesOfString:@":" withString:@""];
    need = [need stringByReplacingOccurrencesOfString:@"T" withString:@""];
    need = [need stringByReplacingOccurrencesOfString:@"." withString:@""];
    need = [need stringByReplacingOccurrencesOfString:@"+" withString:@""];
    need = [need stringByReplacingOccurrencesOfString:@" " withString:@""];
    need = [need substringToIndex:18];
    return need;
}

- (BOOL) isBlankString:(NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end
