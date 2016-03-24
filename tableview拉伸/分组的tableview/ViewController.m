//
//  ViewController.m
//  分组的tableview
//
//  Created by 刘小椿 on 16/3/15.
//  Copyright © 2016年 刘小椿. All rights reserved.
//

#import "ViewController.h"
#import "CExpandHeader.h"
#import "TableViewCell.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    CExpandHeader *_header;
    UIImageView* image;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation ViewController
- (void)tapOne {
    NSLog(@"呵呵");
}
- (IBAction)action:(id)sender {
    NSLog(@"哈哈");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    self.tableView.backgroundColor = [UIColor greenColor];
    self.tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
//    [CExpandHeader expandWithScrollView:self.tableView expandView:image];
//    image.userInteractionEnabled = YES;
    
    image = [[UIImageView alloc]initWithFrame:CGRectMake(0, -200, self.view.frame.size.width, 200)];
    image.image = [UIImage imageNamed:@"1"];
//    [self.view addSubview:image];
//    NSLog(@"%d",self.tableView.subviews.count);
    [self.tableView insertSubview:image atIndex:0];
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if(offsetY < 200 * -1) {
        CGRect currentFrame = image.frame;
        currentFrame.origin.y = offsetY;
        currentFrame.size.height = -1*offsetY;
        image.frame = currentFrame;
    }
}

#pragma mark - delegate datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section = %d row = %d",indexPath.section,indexPath.row);
    if (0 == indexPath.section) {
        return 100;
    }else if (1 == indexPath.section){
        return 50;
    }else{
        return 44;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (1 == section) {
        return 2;
    }else if (2 == section){
        return 3;
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOne)];
//    tap.numberOfTapsRequired = 1;
//    tap.numberOfTouchesRequired = 1;
//    [cell.image addGestureRecognizer:tap];
    
    cell.image.layer.masksToBounds = YES;
    cell.image.layer.cornerRadius = 10;
    
    cell.btn.backgroundColor = [UIColor blueColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = @"LXC";
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
