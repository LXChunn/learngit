//
//  XPNoNetworkView.m
//  XPApp
//
//  Created by jy on 16/1/11.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPNoNetworkView.h"

@interface XPNoNetworkView ()
@property (nonatomic, strong) WhenClickTryBlock block;
@end

@implementation XPNoNetworkView
- (IBAction)tryAgainAction:(id)sender
{
    if(_block) {
        _block();
    }
}

- (void)whenClickTryButtonWith:(WhenClickTryBlock)block
{
    _block = block;
}

@end
