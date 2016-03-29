//
//  ViewController.m
//  FaceView
//
//  Created by mac on 16/1/12.
//  Copyright © 2016年 YF_S. All rights reserved.
//

#import "ViewController.h"
#import "FaceView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    FaceView *faceView = [[FaceView alloc]initWithFrame:CGRectMake(0, 120, 375, 375*4/7) withReturnBlock:^(NSString *itemName) {
        
        NSLog(@"itemName is %@",itemName);
    }];
    
    [self.view addSubview:faceView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
