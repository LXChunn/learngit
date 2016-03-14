//
//  XPLoadingHudView.m
//  XPApp
//
//  Created by jy on 16/1/15.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPLoadingHudView.h"

#define BoundWidth          [UIScreen mainScreen].bounds.size.width
#define BoundHeight         [UIScreen mainScreen].bounds.size.height

@interface XPLoadingHudView ()

@property (nonatomic,strong) UIView *hudView;
@property (nonatomic,strong) UIImageView *loadingImageView;

@end

@implementation XPLoadingHudView

+ (XPLoadingHudView*)sharedView {
    static dispatch_once_t once;
    static XPLoadingHudView *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    return sharedView;
}

- (UIView *)hudView{
    if (!_hudView) {
        _hudView = [[UIView alloc] initWithFrame:CGRectMake(BoundWidth/2 - 68, BoundHeight/2 - 48,136, 96)];
        if (!_loadingImageView) {
            _loadingImageView = [[UIImageView alloc] initWithFrame:_hudView.bounds];
            NSMutableArray *images = [NSMutableArray array];
            for (int i = 1; i < 17; i++){
                NSString *imageName = [NSString stringWithFormat:@"hud_loading_%d", i];
                [images addObject:[UIImage imageNamed:imageName]];
            }
            _loadingImageView.animationImages = images;
            _loadingImageView.animationRepeatCount = 0;
            _loadingImageView.animationDuration = 1.0;
        }
        [_hudView addSubview:_loadingImageView];
    }
    if (!_hudView.superview) {
        [self addSubview:_hudView];
    }
    return _hudView;
}

- (void)showHud{
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows){
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        
        if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            [window addSubview:self];
            break;
        }
    }
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        self.hudView.alpha = 1;
        [self.loadingImageView startAnimating];
    }];
}

- (void)dismissHud{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hudView.alpha = 0;
        [self.loadingImageView stopAnimating];
    }];
}

@end
