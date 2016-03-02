//
//  LXCfootCt.m
//  healthKit
//
//  Created by 刘小椿 on 16/2/28.
//  Copyright © 2016年 刘小椿. All rights reserved.
//

#import "LXCfootCt.h"
#import "HKHealthStore+LXCExtension.h"
@interface LXCfootCt ()
@property (weak, nonatomic) IBOutlet UILabel *footValueLb;

@property (nonatomic,strong)HKHealthStore* healthStore;


@property (nonatomic,strong)NSMutableArray* footArr;
@end

@implementation LXCfootCt
-(void)viewDidAppear:(BOOL)animated
{
    if ([HKHealthStore isHealthDataAvailable]) {
//        NSSet* writeDataTypes = [NSSet setWithObjects:
//                                 [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned],
//                                 nil];
        NSSet* readDataTypes = [NSSet setWithObjects:
                                [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],
                                nil];
        //由于HealthKit存储了大量的用户敏感信息，App如果需要访问HealthKit中的数据，首先需要请求用户权限。权限分为读取与读写权限（苹果将读写权限称为share）。请求权限还是比较简单的，可以直接使用requestAuthorizationToShareTypes: readTypes: completion: 方法
        NSLog(@"=%@",readDataTypes);
        
        [self.healthStore requestAuthorizationToShareTypes:nil readTypes:readDataTypes completion:^(BOOL success, NSError * _Nullable error) {
            if (!success) {
                NSLog(@"You didn't allow HealthKit to access these read/write data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: %@. If you're using a simulator, try it on a device.", error);
                return;
            }
            //主线程更新界面
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateRealTimeStepCount];
            });
        }];
    }

}
- (void)updateRealTimeStepCount
{
    HKSampleType* sampleType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    HKObserverQuery* query = [[HKObserverQuery alloc]initWithSampleType:sampleType predicate:nil updateHandler:^(HKObserverQuery * _Nonnull query, HKObserverQueryCompletionHandler  _Nonnull completionHandler, NSError * _Nullable error) {
        if (error) {
            NSLog(@"an error occured while setting up stepCount observe.");
            abort();
        }
        
        [self updateUserFootLb];
    }];
    
    [self.healthStore executeQuery:query];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.healthStore = [[HKHealthStore alloc]init];
    self.footArr = [NSMutableArray array];
    
        // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//更新步数
- (void)updateUserFootLb
{
    HKQuantityType* footType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDate* now = [NSDate date];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    NSDate* startDate = [calendar dateFromComponents:components];
    NSDate* endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    
    NSPredicate* predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    
    
    [self.healthStore aapl_mostRecentQuantitySampleOfType:footType predicate:predicate completion:^(HKQuantity *mostRecentQuantity, NSError *error) {
        if (!mostRecentQuantity) {
            NSLog(@"获取步数失败，%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.footValueLb.text = @"0";
            });
            
        }else{
            NSLog(@"获取步数成功");
            NSLog(@"%@",[mostRecentQuantity valueForKey:@"_value"]);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.footValueLb.text = [NSString stringWithFormat:@"%@",[mostRecentQuantity valueForKey:@"_value"]];
            });
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 3;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
