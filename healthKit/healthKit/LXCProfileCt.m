//
//  LXCProfileCt.m
//  healthKit
//
//  Created by 刘小椿 on 16/2/27.
//  Copyright © 2016年 刘小椿. All rights reserved.
//

#import "LXCProfileCt.h"
#import "HKHealthStore+LXCExtension.h"

typedef void (^LXC)(NSString* str);

@interface LXCProfileCt ()
@property (weak, nonatomic) IBOutlet UILabel *ageLb;
@property (weak, nonatomic) IBOutlet UILabel *ageValueLb;

@property (weak, nonatomic) IBOutlet UILabel *heightLb;
@property (weak, nonatomic) IBOutlet UILabel *heightValueLb;

@property (weak, nonatomic) IBOutlet UILabel *weightLb;
@property (weak, nonatomic) IBOutlet UILabel *weightValueLb;

@property (nonatomic,strong)HKHealthStore* healthStore;
@end

@implementation LXCProfileCt
-(void)viewDidAppear:(BOOL)animated
{

//    NSLog(@"111");
//    void (^LXC)(int) = ^(int num){
//        NSLog(@"222");
//    };
//    NSOperationQueue* operation = [[NSOperationQueue alloc]init];
//    [operation addOperationWithBlock:^{
//        LXC(3);
//        NSLog(@"%@",[NSThread currentThread]);
//    }];
//    
//    NSLog(@"333");
    
//    NSLog(@"%@",[NSHomeDirectory() stringByAppendingString:@""]);
    
    self.healthStore = [[HKHealthStore alloc]init];
    if ([HKHealthStore isHealthDataAvailable]) {
        NSSet* writeDataTypes = [NSSet setWithObjects:
                                 [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed],
                                 [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight],
                                 [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],
                                 nil];
        NSSet* readDataTypes = [NSSet setWithObjects:
                                [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed],
                                [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight],
                                [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],
                                [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth],
                                [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex],
                                nil];
        //由于HealthKit存储了大量的用户敏感信息，App如果需要访问HealthKit中的数据，首先需要请求用户权限。权限分为读取与读写权限（苹果将读写权限称为share）。请求权限还是比较简单的，可以直接使用requestAuthorizationToShareTypes: readTypes: completion: 方法
        NSLog(@"write=%@ read=%@",writeDataTypes,readDataTypes);
        
        [self.healthStore requestAuthorizationToShareTypes:writeDataTypes readTypes:readDataTypes completion:^(BOOL success, NSError * _Nullable error) {
            if (!success) {
                NSLog(@"You didn't allow HealthKit to access these read/write data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: %@. If you're using a simulator, try it on a device.", error);
                return;
            }
            //主线程更新界面
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateUsersAgeLb];
                [self updateUsersHeightLb];
                [self updateUsersWeightLb];
            });
        }];
    }
}
#pragma mmark - 更新Lb
- (void)updateUsersWeightLb
{
    //格式化器
    NSMassFormatter *massFormatter = [[NSMassFormatter alloc] init];
    massFormatter.unitStyle = NSFormattingUnitStyleLong;
    NSMassFormatterUnit weightFormatterUnit = NSMassFormatterUnitPound;
    NSString *weightUnitString = [massFormatter unitStringFromValue:10 unit:weightFormatterUnit];
    NSString *localizedWeightUnitDescriptionFormat = @"体重(%@)";
    self.weightLb.text = [NSString stringWithFormat:localizedWeightUnitDescriptionFormat, weightUnitString];

    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    
    [self.healthStore aapl_mostRecentQuantitySampleOfType:weightType predicate:nil completion:^(HKQuantity *mostRecentQuantity, NSError *error) {
        if (!mostRecentQuantity) {
            NSLog(@"Either an error occured fetching the user's weight information or none has been stored yet.");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.weightValueLb.text = @"默认";
            });
        }
        
        else {
            
            HKUnit *weightUnit = [HKUnit poundUnit];
            double usersWeight = [mostRecentQuantity doubleValueForUnit:weightUnit];
            
            // Update UI
            dispatch_async(dispatch_get_main_queue(), ^{
                self.weightValueLb.text = [NSNumberFormatter localizedStringFromNumber:@(usersWeight) numberStyle:NSNumberFormatterNoStyle];
            });
        }
    }];
}

- (void)updateUsersHeightLb
{
    NSLengthFormatter *lengthFormatter = [[NSLengthFormatter alloc] init];
    lengthFormatter.unitStyle = NSFormattingUnitStyleLong;
    NSLengthFormatterUnit heightFormatterUnit = NSLengthFormatterUnitInch;
    NSString *heightUnitString = [lengthFormatter unitStringFromValue:10 unit:heightFormatterUnit];
    NSString *localizedHeightUnitDescriptionFormat = @"高度(%@)";
    
    self.heightLb.text = [NSString stringWithFormat:localizedHeightUnitDescriptionFormat, heightUnitString];
    
    HKQuantityType *heightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    
    [self.healthStore aapl_mostRecentQuantitySampleOfType:heightType predicate:nil completion:^(HKQuantity *mostRecentQuantity, NSError *error) {
        if (!mostRecentQuantity) {
            NSLog(@"Either an error occured fetching the user's height information or none has been stored yet. In your app, try to handle this gracefully.");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.heightValueLb.text = @"默认";
            });
        }
        else {
            
            HKUnit *heightUnit = [HKUnit inchUnit];
            double usersHeight = [mostRecentQuantity doubleValueForUnit:heightUnit];
            
            // Update UI
            dispatch_async(dispatch_get_main_queue(), ^{
                self.heightValueLb.text = [NSNumberFormatter localizedStringFromNumber:@(usersHeight) numberStyle:NSNumberFormatterNoStyle];
            });
        }
    }];
}

- (void)updateUsersAgeLb
{
    NSError* error;
    NSDate* dateOfBirth = [self.healthStore dateOfBirthWithError:&error];
    if (!dateOfBirth) {
        NSLog(@"Either an error occured fetching the user's age information or none has been stored yet. In your app, try to handle this gracefully.");
        self.ageValueLb.text = @"默认";
    }else {
        NSDate* now = [NSDate date];
        NSDateComponents* ageComponents = [[NSCalendar currentCalendar]components:NSCalendarUnitYear fromDate:dateOfBirth toDate:now options:NSCalendarWrapComponents];
        
        NSInteger userAge = [ageComponents year];
        
        self.ageValueLb.text = [NSNumberFormatter localizedStringFromNumber:@(userAge) numberStyle:NSNumberFormatterNoStyle];
        
    }
    
    
}
#pragma mark - 写入数据
- (void)saveHeightToHealthStore:(double)height
{
    HKUnit* inchUnit = [HKUnit inchUnit];
    HKQuantity* heightQuantity = [HKQuantity quantityWithUnit:inchUnit doubleValue:height];
    HKQuantityType* heightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    
    NSDate* now = [NSDate date];
    HKQuantitySample* heightSample = [HKQuantitySample quantitySampleWithType:heightType quantity:heightQuantity startDate:now endDate:now];
    
    [self.healthStore saveObject:heightSample withCompletion:^(BOOL success, NSError * _Nullable error) {
        if (!success) {
            NSLog(@"An error occured saving the height sample %@. In your app, try to handle this gracefully. The error was: %@.", heightSample, error);
            abort();
        }
        
        [self updateUsersHeightLb];
    }];
}

- (void)saveWeightToHealthStore:(double)weight
{
    HKUnit *poundUnit = [HKUnit poundUnit];
    HKQuantity *weightQuantity = [HKQuantity quantityWithUnit:poundUnit doubleValue:weight];
    
    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    NSDate *now = [NSDate date];
    
    HKQuantitySample *weightSample = [HKQuantitySample quantitySampleWithType:weightType quantity:weightQuantity startDate:now endDate:now];
    
    [self.healthStore saveObject:weightSample withCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"An error occured saving the weight sample %@. In your app, try to handle this gracefully. The error was: %@.", weightSample, error);
            abort();
        }
        
        [self updateUsersWeightLb];
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    NSString* title;
    void (^valueChangeHandler)(double value);
    
    if (indexPath.row == 1) {
        title = @"设置身高";
        valueChangeHandler = ^(double value){
            [self saveHeightToHealthStore:value];
        };
    }
    
    if (indexPath.row == 2) {
        title = @"设置体重";
        valueChangeHandler = ^(double value){
            [self saveWeightToHealthStore:value];
            
        };
    }
    
    //弹窗
    UIAlertController* alertCt = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertCt addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        valueChangeHandler(alertCt.textFields.firstObject.text.doubleValue);
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }];
    
    [alertCt addAction:okAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }];
    
    [alertCt addAction:cancelAction];
    
    [self presentViewController:alertCt animated:YES completion:nil];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSLog(@"111");
//    void (^LXC)(int) = ^(int num){
//        NSLog(@"222");
//    };
//    NSOperationQueue* operation = [[NSOperationQueue alloc]init];
//    [operation addOperationWithBlock:^{
//        LXC(3);
//        
//        NSLog(@"%@",[NSThread currentThread]);
//    }];
//    NSLog(@"333");
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
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
