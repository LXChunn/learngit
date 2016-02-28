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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTableview) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.healthStore = [[HKHealthStore alloc]init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - 读取数据
- (void)refreshTableview
{
    [self.refreshControl beginRefreshing];
    
    HKQuantityType* energyConsumedType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
    HKQuantityType* activeEnergyType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    [self fetchSumOfSamplesTodayForType:energyConsumedType unit:[HKUnit jouleUnit] completion:^(double totalJoulesConsumed, NSError *error) {
        
        // Next, fetch the sum of active energy burned from HealthKit. Populate this by creating your
        // own calorie tracking app or the Health app.
        [self fetchSumOfSamplesTodayForType:activeEnergyType unit:[HKUnit jouleUnit] completion:^(double activeEnergyBurned, NSError *error) {
            
            // Last, calculate the user's basal energy burn so far today.
            [self fetchTotalBasalBurn:^(HKQuantity *basalEnergyBurn, NSError *error) {
                
                if (!basalEnergyBurn) {
                    NSLog(@"An error occurred trying to compute the basal energy burn. In your app, handle this gracefully. Error: %@", error);
                }
                
                // Update the UI with all of the fetched values.
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.activeEnergyBurned = activeEnergyBurned;
                    
                    self.restingEnergyBurned = [basalEnergyBurn doubleValueForUnit:[HKUnit jouleUnit]];
                    
                    self.energyConsumed = totalJoulesConsumed;
                    
                    self.netEnergy = self.energyConsumed - self.activeEnergyBurned - self.restingEnergyBurned;
                    
                    [self.refreshControl endRefreshing];
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
            
            NSDate *dateOfBirth = [self.healthStore dateOfBirthWithError:&error];
            if (!dateOfBirth) {
                completion(nil, error);
                
                return;
            }
            
            HKBiologicalSexObject *biologicalSexObject = [self.healthStore biologicalSexWithError:&error];
            if (!biologicalSexObject) {
                completion(nil, error);
                
                return;
            }
            
            // Once we have pulled all of the information without errors, calculate the user's total basal energy burn
            HKQuantity *basalEnergyBurn = [self calculateBasalBurnTodayFromWeight:weight height:height dateOfBirth:dateOfBirth biologicalSex:biologicalSexObject];
            
            completion(basalEnergyBurn, nil);
        }];
    }];
}
- (HKQuantity *)calculateBasalBurnTodayFromWeight:(HKQuantity *)weight height:(HKQuantity *)height dateOfBirth:(NSDate *)dateOfBirth biologicalSex:(HKBiologicalSexObject *)biologicalSex {
    // Only calculate Basal Metabolic Rate (BMR) if we have enough information about the user
    if (!weight || !height || !dateOfBirth || !biologicalSex) {
        return nil;
    }
    
    // Note the difference between calling +unitFromString: vs creating a unit from a string with
    // a given prefix. Both of these are equally valid, however one may be more convenient for a given
    // use case.
    double heightInCentimeters = [height doubleValueForUnit:[HKUnit unitFromString:@"cm"]];
    double weightInKilograms = [weight doubleValueForUnit:[HKUnit gramUnitWithMetricPrefix:HKMetricPrefixKilo]];
    
    NSDate *now = [NSDate date];
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:dateOfBirth toDate:now options:NSCalendarWrapComponents];
    NSUInteger ageInYears = ageComponents.year;
    
    // BMR is calculated in kilocalories per day.
    double BMR = [self calculateBMRFromWeight:weightInKilograms height:heightInCentimeters age:ageInYears biologicalSex:[biologicalSex biologicalSex]];
    
    // Figure out how much of today has completed so we know how many kilocalories the user has burned.
    NSDate *startOfToday = [[NSCalendar currentCalendar] startOfDayForDate:now];
    NSDate *endOfToday = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startOfToday options:0];
    
    NSTimeInterval secondsInDay = [endOfToday timeIntervalSinceDate:startOfToday];
    double percentOfDayComplete = [now timeIntervalSinceDate:startOfToday] / secondsInDay;
    
    double kilocaloriesBurned = BMR * percentOfDayComplete;
    
    return [HKQuantity quantityWithUnit:[HKUnit kilocalorieUnit] doubleValue:kilocaloriesBurned];
}
- (double)calculateBMRFromWeight:(double)weightInKilograms height:(double)heightInCentimeters age:(NSUInteger)ageInYears biologicalSex:(HKBiologicalSex)biologicalSex {
    double BMR;
    
    // The BMR equation is different between males and females.
    if (biologicalSex == HKBiologicalSexMale) {
        BMR = 66.0 + (13.8 * weightInKilograms) + (5 * heightInCentimeters) - (6.8 * ageInYears);
    }
    else {
        BMR = 655 + (9.6 * weightInKilograms) + (1.8 * heightInCentimeters) - (4.7 * ageInYears);
    }
    
    return BMR;
}

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
#pragma mark - NSEnergyFormatter

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

#pragma mark - Setter Overrides

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
