//
//  XPJoinEventMemberCell.h
//  XPApp
//
//  Created by jy on 16/1/9.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPAuthorModel.h"
#import "XPBaseModel.h"
#import "XPBaseTableViewCell.h"

typedef void (^ClickMemberBlock)(XPAuthorModel *model
                                 );

@interface XPJoinEventMemberCell : XPBaseTableViewCell

- (void)bindModel:(XPBaseModel *)model;

- (void)whenClickJoinMemberWithBlock:(ClickMemberBlock)block;

@end
