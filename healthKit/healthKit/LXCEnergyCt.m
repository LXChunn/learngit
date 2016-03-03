//
//  LXCEnergyCt.m
//  healthKit
//
//  Created by 刘小椿 on 16/2/28.
//  Copyright © 2016年 刘小椿. All rights reserved.
//

#import "LXCEnergyCt.h"
#import "HKHealthStore+LXCExtension.h"
@interface LXCEnergyCt ()
@property (weak, nonatomic) IBOutlet UILabel *restingBurnLb;
@property (weak, nonatomic) IBOutlet UILabel *activeBurnLb;
@property (weak, nonatomic) IBOutlet UILabel *consumedLb;
@property (weak, nonatomic) IBOutlet UILabel *netLb;

@property (nonatomic) double activeEnergyBurned;
@property (nonatomic) double restingEnergyBurned;
@property (nonatomic) double energyConsumed;
@property (nonatomic) double netEnergy;

@property (weak, nonatomic) IBOutlet UILabel *restingValueLb;
@property (weak, nonatomic) IBOutlet UILabel *activeValueLb;
@property (weak, nonatomic) IBOutlet UILabel *consumedValueLb;
@property (weak, nonatomic) IBOutlet UILabel *netValueLb;

@property (nonatomic,strong)HKHealthStore* healthStore;

@end

@implementation LXCEnergyCt
-(void)viewWillAppear:(BOOL)animated
{
    [self.refreshControl addTarget:self action:@selector(refreshTableview) forControlEvents:UIControlEventValueChanged];
    
    //先保存
    [self saveFoodItem];
    //刷新
    [self refreshTableview];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.healthStore = [[HKHealthStore alloc]init];
}

#pragma mark - 读取数据
- (void)refreshTableview
{
    
    HKQuantityType* energyConsumedType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
    HKQuantityType* activeEnergyType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    //查询总焦耳
    [self fetchSumOfSamplesTodayForType:energyConsumedType unit:[HKUnit jouleUnit] completion:^(double totalJoulesConsumed, NSError *error) {
        
        //查询运动消耗量
        [self fetchSumOfSamplesTodayForType:activeEnergyType unit:[HKUnit jouleUnit] completion:^(double activeEnergyBurned, NSError *error) {
            
            //
            [self fetchTotalBasalBurn:^(HKQuantity *basalEnergyBurn, NSError *error) {
                
                if (!basalEnergyBurn) {
                    NSLog(@"An error occurred trying to compute the basal energy burn. In your app, handle this gracefully. Error: %@", error);
                }
                
                // 主线程更新UI.
                dispatch_async(dispatch_get_main_queue(), ^{
                    //运动耗能
                    self.activeEnergyBurned = activeEnergyBurned;
                    //人体消耗
                    self.restingEnergyBurned = [basalEnergyBurn doubleValueForUnit:[HKUnit jouleUnit]];
                    //总消耗
                    self.energyConsumed = totalJoulesConsumed;
                    //剩余能量
                    self.netEnergy = self.energyConsumed - self.activeEnergyBurned - self.restingEnergyBurned;
                });
            }];
        }];
    }];
}

- (void)fetchTotalBasalBurn:(void(^)(HKQuantity *basalEnergyBurn, NSError *error))completion {
    NSPredicate *todayPredicate = [self predicteForSamplesToday];
    
    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    
    [self.healthStore aapl_mostRecentQuantitySampleOfType:weightType predicate:nil completion:^(HKQuantity *weight, NSError *error) {
        if (!weight) {
            completion(nil, error);
            
            return;
        }
        
        [self.healthStore aapl_mostRecentQuantitySampleOfType:heightType predicate:todayPredicate completion:^(HKQuantity *height, NSError *error) {
            if (!height) {
                completion(nil, error);
                return;
            }
            
            HKBiologicalSexObject *biologicalSexObject = [self.healthStore biologicalSexWithError:&error];
            if (!biologicalSexObject) {
                completion(nil, error);
                
                return;
            }
            
            HKQuantity *basalEnergyBurn = [self calculateBasalBurnTodayFromWeight:weight height:height biologicalSex:biologicalSexObject];
            
            completion(basalEnergyBurn, nil);
        }];
    }];
}

- (HKQuantity *)calculateBasalBurnTodayFromWeight:(HKQuantity *)weight height:(HKQuantity *)height biologicalSex:(HKBiologicalSexObject *)biologicalSex {
    if (!weight || !height || !biologicalSex) {
        return nil;
    }
    
    double heightInCentimeters = [height doubleValueForUnit:[HKUnit unitFromString:@"cm"]];
    double weightInKilograms = [weight doubleValueForUnit:[HKUnit gramUnitWithMetricPrefix:HKMetricPrefixKilo]];
    //一天的能量消耗
    double BMR = [self calculateBMRFromWeight:weightInKilograms height:heightInCentimeters biologicalSex:[biologicalSex biologicalSex]];
    
    NSDate* now = [NSDate new];
    NSDate *startOfToday = [[NSCalendar currentCalendar] startOfDayForDate:now];
    NSDate *endOfToday = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startOfToday options:0];
    NSTimeInterval secondsInDay = [endOfToday timeIntervalSinceDate:startOfToday];
    //百分比计算
    double percentOfDayComplete = [now timeIntervalSinceDate:startOfToday] / secondsInDay;
    double kilocaloriesBurned = BMR * percentOfDayComplete;
    
    
    return [HKQuantity quantityWithUnit:[HKUnit jouleUnit] doubleValue:kilocaloriesBurned];
}
//根据身高 体重 性别 估算一天能量消耗
- (double)calculateBMRFromWeight:(double)weightInKilograms height:(double)heightInCentimeters biologicalSex:(HKBiologicalSex)biologicalSex {
    double BMR;
    
    if (biologicalSex == HKBiologicalSexMale) {
        BMR = 100.0 + (2 * weightInKilograms) + (2 * heightInCentimeters);
    }
    else {
        BMR = 200 + (2 * weightInKilograms) + (2 * heightInCentimeters);
    }
    
    return BMR;
}
#pragma mark - tongji
- (void)fetchSumOfSamplesTodayForType:(HKQuantityType *)quantityType unit:(HKUnit *)unit completion:(void (^)(double, NSError *))completionHandler {
    NSPredicate *predicate = [self predicteForSamplesToday];
    
    //统计查询
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:quantityType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        HKQuantity *sum = [result sumQuantity];
        
        if (completionHandler) {
            double value = [sum doubleValueForUnit:unit];
            
            completionHandler(value, error);
        }else{
            completionHandler(0,error);
        }
    }];
    
    [self.healthStore executeQuery:query];
}

- (NSPredicate*)predicteForSamplesToday
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDate* now = [NSDate date];
    
    NSDate* startDate = [calendar startOfDayForDate:now];
    NSDate* endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
     
    return [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
}
#pragma mark - 模拟correlation 存储
- (void)saveFoodItem
{
    HKCorrelation* foodCorrelationItemBread = [self foodCorrelationForFoodName:@"面包" andFoodJoules:100.0];
    HKCorrelation* foodCorrelationItemRice = [self foodCorrelationForFoodName:@"大米" andFoodJoules:150.0];
    HKCorrelation* foodCorrelationItemWater = [self foodCorrelationForFoodName:@"水" andFoodJoules:10.0];
    
    NSLog(@"%@",foodCorrelationItemBread);
    
    [self.healthStore saveObjects:@[foodCorrelationItemBread,foodCorrelationItemRice,foodCorrelationItemWater] withCompletion:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                NSLog(@"保存成功");
            }else{
                NSLog(@"An error occured saving the food. In your app, try to handle this gracefully.");
            }
        });
    }];
}

- (HKCorrelation*)foodCorrelationForFoodName:(NSString*)foodName andFoodJoules:(double)foodJoules
{
    NSDate *now = [NSDate date];
    
    HKQuantity *energyQuantityConsumed = [HKQuantity quantityWithUnit:[HKUnit jouleUnit] doubleValue:foodJoules];
    HKQuantityType *energyConsumedType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
    
    HKQuantitySample *energyConsumedSample = [HKQuantitySample quantitySampleWithType:energyConsumedType quantity:energyQuantityConsumed startDate:now endDate:now];
    NSSet *energyConsumedSamples = [NSSet setWithObject:energyConsumedSample];
    
    HKCorrelationType *foodType = [HKObjectType correlationTypeForIdentifier:HKCorrelationTypeIdentifierFood];
    
    NSDictionary *foodCorrelationMetadata = @{HKMetadataKeyFoodType: foodName};
    
    HKCorrelation *foodCorrelation = [HKCorrelation correlationWithType:foodType startDate:now endDate:now objects:energyConsumedSamples metadata:foodCorrelationMetadata];
    NSLog(@"%@",foodCorrelation);
    return foodCorrelation;
}

#pragma mark - 显示
//格式化器
- (NSEnergyFormatter *)energyFormatter {
    static NSEnergyFormatter *energyFormatter;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        energyFormatter = [[NSEnergyFormatter alloc] init];
        energyFormatter.unitStyle = NSFormattingUnitStyleLong;
        energyFormatter.forFoodEnergyUse = YES;
        energyFormatter.numberFormatter.maximumFractionDigits = 2;
    });
    
    return energyFormatter;
}

- (void)setActiveEnergyBurned:(double)activeEnergyBurned {
    _activeEnergyBurned = activeEnergyBurned;
    
    NSEnergyFormatter *energyFormatter = [self energyFormatter];
    self.activeValueLb.text = [energyFormatter stringFromJoules:activeEnergyBurned];
}

- (void)setEnergyConsumed:(double)energyConsumed {
    _energyConsumed = energyConsumed;
    
    NSEnergyFormatter *energyFormatter = [self energyFormatter];
    self.consumedValueLb.text = [energyFormatter stringFromJoules:energyConsumed];
}

- (void)setRestingEnergyBurned:(double)restingEnergyBurned {
    _restingEnergyBurned = restingEnergyBurned;
    
    NSEnergyFormatter *energyFormatter = [self energyFormatter];
    self.restingValueLb.text = [energyFormatter stringFromJoules:restingEnergyBurned];
}

- (void)setNetEnergy:(double)netEnergy {
    _netEnergy = netEnergy;
    
    NSEnergyFormatter *energyFormatter = [self energyFormatter];
    self.netValueLb.text = [energyFormatter stringFromJoules:netEnergy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 4;
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
