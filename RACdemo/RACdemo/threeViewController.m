//
//  threeViewController.m
//  RACdemo
//
//  Created by 刘小椿 on 16/2/26.
//  Copyright © 2016年 JASON. All rights reserved.
//

#import "threeViewController.h"

@interface threeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textRed;

@end

@implementation threeViewController
- (IBAction)backToBlue:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    NSMutableArray* arr = [NSMutableArray arrayWithArray:@[self.textRed.text]];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"postDataRed" object:arr];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
