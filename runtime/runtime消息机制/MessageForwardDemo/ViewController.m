//
//  ViewController.m
//  消息转发Demo
//
//  Created by zhangyafeng on 15/5/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "ViewController.h"
#import "Car.h"
#import "Person.h"
#import "animal.h"

typedef NS_ENUM(NSInteger, UIForwardingMethod)  {
    UIForwardingMethodOne,
    UIForwardingMethodTwo,
    UIForwardingMethodThree
};

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic) NSArray *forwardingArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.forwardingArray = [NSArray arrayWithObjects:@"方式1", @"方式2", @"方式3", nil];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.forwardingArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.forwardingArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case UIForwardingMethodOne: {
            Person *person = [[Person alloc] init];
            [person run];
            break;
        }
        case UIForwardingMethodTwo:{
            Car *car = [[Car alloc] init];
//            [car performSelector:@selector(run)];
            [car run];
            break;
        }
        case UIForwardingMethodThree: {
            animal* ani = [[animal alloc]init];
            [ani performSelector:@selector(run)];
            break;
        }
        default:
            break;
    }
}



@end
