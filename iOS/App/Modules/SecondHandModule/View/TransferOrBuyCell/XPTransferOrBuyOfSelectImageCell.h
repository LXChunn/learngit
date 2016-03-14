//
//  XPTransferOrBuyOfSelectImageCell.h
//  XPApp
//
//  Created by jy on 15/12/30.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseTableViewCell.h"

typedef void (^UploadFinishedImageBlock)(NSArray *pictures
                                         );

@interface XPTransferOrBuyOfSelectImageCell : XPBaseTableViewCell

- (void)whenUploadFinishImage:(UploadFinishedImageBlock)block showUrls:(NSArray *)showUrls;

@end
