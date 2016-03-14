//
//  XPAboutUsViewController.m
//  XPApp
//
//  Created by CaoShunQing on 16/1/12.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import "XPAboutUsViewController.h"

@interface XPAboutUsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *verisonLabel;

@end

@implementation XPAboutUsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"关于我们";
    NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    _verisonLabel.text = [NSString stringWithFormat:@"版本号 V%@",version];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
