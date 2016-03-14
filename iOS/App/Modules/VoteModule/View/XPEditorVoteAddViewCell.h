//
//  XPEditorVoteAddViewCell.h
//  XPApp
//
//  Created by Mac OS on 16/1/4.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseTableViewCell.h"

typedef void (^AddOptionBlock)();
@interface XPEditorVoteAddViewCell : XPBaseTableViewCell

- (void)whenClickAddOptionWithBlock:(AddOptionBlock)block;

@end
