//
//  XPEditorVoteTableViewCell.h
//  XPApp
//
//  Created by Mac OS on 15/12/31.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseTableViewCell.h"
typedef void (^DeleteOptionBlock)();
typedef void (^TextInputBlock)(NSString *text
                               );
@interface XPEditorVoteTableViewCell : XPBaseTableViewCell

- (void)configureUIWithContent:(NSString *)content deleteBlock:(DeleteOptionBlock)deleteBlock textInputBlock:(TextInputBlock)textInputBlock;

@end
