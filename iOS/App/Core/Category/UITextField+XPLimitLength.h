//
//  UITextField+XPLimitLength.h
//  XPApp
//
//  Created by xinpinghuang on 1/8/16.
//  Copyright © 2016 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACSignal;
@interface UITextField (XPLimitLength)

- (void)rac_textSignalWithLimitLength:(NSInteger)limitLength;

@end
