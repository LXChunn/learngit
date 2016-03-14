//
//  XPJoinEventMemberCell.m
//  XPApp
//
//  Created by jy on 16/1/9.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//


#import "UIView+block.h"
#import "XPAuthorModel.h"
#import "XPDetailModel.h"
#import "XPJoinEventMemberCell.h"
#import <UIImageView+WebCache.h>
@interface XPJoinEventMemberCell ()
@property (weak, nonatomic) IBOutlet UILabel *joinCountLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) XPDetailModel *model;
@property (nonatomic, strong) ClickMemberBlock block;

@end

@implementation XPJoinEventMemberCell

- (void)awakeFromNib
{
    @weakify(self);
    [[RACObserve(self, model.extra.participants) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        if(self.model.extra.participants.count > 0) {
            self.joinCountLabel.text = [NSString stringWithFormat:@"已有%d人参与", self.model.extra.participants.count];
        } else {
            return;
        }
        
        for(UIImageView *imageView in _scrollView.subviews) {
            [imageView removeFromSuperview];
        }
        self.scrollView.contentSize = CGSizeMake((38 + 21) * self.model.extra.participants.count, 0);
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        for(int i = 0; i < [self.model.extra.participants count]; i++) {
            NSDictionary *dic = [self.model.extra.participants objectAtIndex:i];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(38 + 21), 0, 38, 38)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.userInteractionEnabled = YES;
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = 19;
            [imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"avatar_url"]] placeholderImage:[UIImage imageNamed:@"common_default_avatar"]];
            [imageView whenTapped:^{
                if(_block) {
                    XPAuthorModel *authorModel = [[XPAuthorModel alloc] init];
                    authorModel.avatarUrl = dic[@"avatar_url"];
                    authorModel.nickname = dic[@"nickname"];
                    authorModel.userId = dic[@"user_id"];
                    _block(authorModel);
                }
            }];
            [self.scrollView addSubview:imageView];
        }
    }];
}

- (void)whenClickJoinMemberWithBlock:(ClickMemberBlock)block
{
    _block = block;
}

- (void)bindModel:(XPBaseModel *)model
{
    if(!model) {
        return;
    }
    
    NSParameterAssert([model isKindOfClass:[XPDetailModel class]]);
    self.model = (XPDetailModel *)model;
}

@end
