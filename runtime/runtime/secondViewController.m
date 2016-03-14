//
//  secondViewController.m
//  runtime
//
//  Created by Mac OS on 16/3/4.
//  Copyright © 2016年 JASON. All rights reserved.
//

#import "secondViewController.h"
#import <objc/runtime.h>
#import "ViewController.h"

@interface secondViewController ()
@property(nonatomic,strong)UILabel* textLb;


@end

@implementation secondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textLb = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 60, self.view.frame.size.height/2 - 30, 120, 20)];
    self.textLb.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.textLb];
    
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 60, self.view.frame.size.height/2 + 100, 120, 120)];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    self.view.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view.
}
- (void)backTo
{
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

- (void)secondVCMethod
{
    NSLog(@"This is secondVC method !");
    
}


-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"text = %@",self.LXC);
//    self.textLb.text = self.LXC;
    ViewController* object = [[ViewController alloc]init];
    self.textLb.text = objc_getAssociatedObject(object, @"key");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
