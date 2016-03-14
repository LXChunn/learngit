//
//  XPNoDataView.m
//  XPApp
//
//  Created by jy on 16/1/11.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPNoDataView.h"

@interface XPNoDataView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation XPNoDataView

- (void)configureUIWithType:(NoDataType)type
{
    if (!type) {
        type = NoDataTypeOfDefault;
    }
    switch (type) {
        case NoDataTypeOfPost:{
            _iconImageView.image = [UIImage imageNamed:@"image_data"];
            _titleLabel.text = @"暂无发布";
            break;
        }
        case NoDataTypeOfComment:{
            _iconImageView.image = [UIImage imageNamed:@"image_message"];
            _titleLabel.text = @"暂无评论";
            break;
        }
        case NoDataTypeOfCollection:{
            _iconImageView.image = [UIImage imageNamed:@"image_collect"];
            _titleLabel.text = @"暂无收藏";
            break;
        }
        case NoDataTypeOfPrivateMessage:{
            _iconImageView.image = [UIImage imageNamed:@"image_message"];
            _titleLabel.text = @"暂无私信";
            break;
        }
        case NoDataTypeOfDefault:{
            _iconImageView.image = [UIImage imageNamed:@"image_data"];
            _titleLabel.text = @"暂无数据";
            break;
        }
        default:
            break;
    }
}

@end
