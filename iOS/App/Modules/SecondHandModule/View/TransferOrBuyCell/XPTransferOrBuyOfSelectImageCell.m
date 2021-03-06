//
//  XPTransferOrBuyOfSelectImageCell.m
//  XPApp
//
//  Created by jy on 15/12/30.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPAddImageView.h"
#import "XPTransferOrBuyOfSelectImageCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface XPTransferOrBuyOfSelectImageCell ()

@property (weak, nonatomic) IBOutlet XPAddImageView *selectImageView;
@property (nonatomic, strong) UploadFinishedImageBlock uploadFinishedImageBlock;
@end

@implementation XPTransferOrBuyOfSelectImageCell

- (void)whenUploadFinishImage:(UploadFinishedImageBlock)block showUrls:(NSArray *)showUrls
{
    _uploadFinishedImageBlock = block;
    @weakify(self);
    [_selectImageView setOSSURLs:showUrls];
    [RACObserve(self, selectImageView.uploadFinshed) subscribeNext:^(id x) {
        @strongify(self);
        self.uploadFinishedImageBlock(self.selectImageView.urls);
    }];
}

@end
