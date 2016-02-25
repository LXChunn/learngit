//
//  XPBaseShareActivity.m
//  XPApp
//
//  Created by xinpinghuang on 12/24/15.
//  Copyright © 2015 ShareMerge. All rights reserved.
//

#import "XPBaseShareActivity.h"

#define xp_LableFont [UIFont systemFontOfSize:9.0]
#define xp_LogoHeight (([UIScreen mainScreen].bounds.size.width - 80) / 5)
#define xp_LableWidth ((([UIScreen mainScreen].bounds.size.width - 80) / 5) + 2)
#define xp_ActivityHeight (LogoHeight + 35)
static const CGFloat xp_LogoTitleSpace = 3;
static const CGFloat xp_LableHeiht = 30;

@interface XPBaseShareActivity ()

@property (nonatomic, strong) UIButton *logo;
@property (nonatomic, strong) UILabel *title;

@end

@implementation XPBaseShareActivity

- (instancetype)init
{
    if(self = [super initWithFrame:(CGRect){0, 0, xp_LableWidth, (xp_LogoHeight + xp_LogoTitleSpace + xp_LableHeiht)}]) {
        [self configUI];
        if([self activityImage]) {
            [self.logo setBackgroundImage:[self activityImage] forState:UIControlStateNormal];
        } else {
            [self.logo setBackgroundImage:[UIImage imageNamed:@"about_ico"] forState:UIControlStateNormal];
        }
        
        self.logo.enabled = [self buttonEnable];
        [self.title setText:[self activityTitle]];
        self.title.textAlignment = NSTextAlignmentCenter;
    }
    
    return self;
}

- (void)configUI
{
    _logo = [[UIButton alloc] initWithFrame:(CGRect){1, 0, xp_LogoHeight, xp_LogoHeight}];
    [_logo addTarget:self action:@selector(logoClick:) forControlEvents:UIControlEventTouchUpInside];
    _logo.layer.cornerRadius = 5.0;
    _logo.userInteractionEnabled = YES;
    
    _title = [[UILabel alloc] initWithFrame:(CGRect){0, xp_LogoHeight + xp_LogoTitleSpace, xp_LableWidth, xp_LableHeiht}];
    _title.font = xp_LableFont;
    _title.textAlignment = NSTextAlignmentCenter;
    _title.numberOfLines = 2;
    
    [self addSubview:_logo];
    [self addSubview:_title];
}

- (void)logoClick:(id)sender
{
    [self performActivity];
    if(self.block) {
        self.block();
    }
}

- (NSString *)activityTitle
{
    return nil;
}

- (UIImage *)activityImage
{
    return nil;
}

- (UIViewController *)activityViewController
{
    return nil;
}

- (void)performActivity
{
}

- (BOOL)buttonEnable
{
    return YES;
}

@end
