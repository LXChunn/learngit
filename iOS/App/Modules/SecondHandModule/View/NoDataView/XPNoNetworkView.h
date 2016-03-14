//
//  XPNoNetworkView.h
//  XPApp
//
//  Created by jy on 16/1/11.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^WhenClickTryBlock)();
@interface XPNoNetworkView : UIView

- (void)whenClickTryButtonWith:(WhenClickTryBlock)block;

@end
