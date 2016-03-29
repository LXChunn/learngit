//
//  secondViewController.m
//  RACdemo
//
//  Created by 刘小椿 on 16/2/26.
//  Copyright © 2016年 JASON. All rights reserved.
//

#import "secondViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ViewController.h"

@interface secondViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textOne;
@property (weak, nonatomic) IBOutlet UITextField *textTwo;
@property (weak, nonatomic) IBOutlet UITextField *textThree;
@property (strong, nonatomic) IBOutlet ViewController *viewC;


@end

@implementation secondViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)backToOne:(id)sender {
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
    NSMutableArray* arr = [NSMutableArray arrayWithArray:@[self.textOne.text,self.textTwo.text,self.textThree.text]];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"postData" object:arr];
//    self.viewC = nil;
    
}
-(id)init
{
    if (self = [super init]) {
        [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"switchChange" object:nil]subscribeNext:^(NSNotification* notification) {
            NSLog(@"switch LXC = %@",notification.object);
            
        }];
    }
    return self;
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
