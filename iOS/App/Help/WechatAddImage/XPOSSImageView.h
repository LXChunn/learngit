//
//  XPOSSImageView.h
//  XPApp
//
//  Created by xinpinghuang on 12/24/15.
//  Copyright © 2015 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XPOSSImageView;
@protocol XPOSSImageViewDelegate <NSObject>

- (void)deleteTaped:(XPOSSImageView *)ossImageView;
- (void)taped:(XPOSSImageView *)ossImageView;
- (void)uploadFinished:(XPOSSImageView *)ossImageView;

@end

@interface XPOSSImageView : UIImageView

@property (nonatomic, weak) id<XPOSSImageViewDelegate> delegate;
@property (nonatomic, strong) NSString *ossURL;

@end
