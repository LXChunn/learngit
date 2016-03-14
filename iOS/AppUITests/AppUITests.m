//
//  AppUITests.m
//  AppUITests
//
//  Created by huangxinping on 15/11/5.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface AppUITests : XCTestCase

@end

@implementation AppUITests

- (void)setUp
{
    [super setUp];
    
    self.continueAfterFailure = NO;
    [[[XCUIApplication alloc] init] launch];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testLoginWithEmptyLoginAndPassword
{
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.buttons[@"login"] tap];
    [app.alerts[@"Ops"].collectionViews.buttons[@"Ok"] tap];
}

- (void)testLoginWithWrongLoginAndPassword
{
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    XCUIElement *loginTextField = app.textFields[@"Username"];
    [loginTextField tap];
    [loginTextField typeText:@"test"];
    
    XCUIElement *passwordField = app.secureTextFields[@"Password"];
    [passwordField tap];
    [passwordField typeText:@"1234"];
    [app.buttons[@"login"] tap];
    
    //XCUIElement* valueLabel = app.staticTexts[@"Ops"];
    
    //    NSString * staticIden = app.staticTexts.element.identifier;
    //    NSString * alertIden = app.alerts.staticTexts.element.identifier;
    
    // id button = app.alerts[@"Ops"].collectionViews.buttons[@"Ok"];
    
    // id button = app.alerts[@"Ops"].collectionViews.buttons[@"Ok"];
    
    //    id alert1 = app.alerts.element.identifier;
    //    id alert2 = app.alerts.element.title;
    //    id alert3 = app.alerts.element.value;
    id alert4 = app.alerts;
    //    id alert6 = app.alerts.dialogs;
    NSString *alert7 = [NSString stringWithFormat:@"%@", app.alerts.element.label];
    NSString *alert8 = app.alerts.element.label;
    
    //NSString* labelAlertString = [NSString stringWithFormat:@"%@",app.alerts.element.label];
    // XCTAssertEqual(labelAlertString,@"Ops");
    XCTAssertNotNil(app.alerts.element.label); // If show alert will succeed
    //id alert7 = app.alerts.element.element.identifier;
    
    //    id navbar1 = app.navigationBars.element.identifier;
    //    id navbar2 = app.navigationBars.element.title;
    //    id navbar = app.navigationBars.element.value;
    
    id forbreak = app.alerts.element.identifier;
    
    XCTAssertEqual(alert7, @"Ops");
    
    //XCTAssertEqual(app.alerts[@"Ops"].staticTexts,@"Ops");
    
    // XCTAssertEqual(app.navigationBars.element.identifier, @"Login");
    
    // XCTAssertNotNil(app.alerts[@"Ops"]);
    // XCTAssertNotNil(app.staticTexts[@"Ops"]);
    
    // XCTAssertNotNil(passwordField);
    // XCTAssertEqual([passwordField.value description], @"1234");
    
    //    delay
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    //    });
    
    //    NSLog(@"IDEN %@",app.alerts.element.identifier);
    //    app.alerts.element.identifier
    //    app.alerts.element.title
    //    XCTAssertNil(app.alerts.element.title);
}

- (void)testSuccessLogin
{
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *loginTextField = app.textFields[@"Username"];
    [loginTextField tap];
    [loginTextField typeText:@"test"];
    
    XCUIElement *senhaTextField = app.secureTextFields[@"password"];
    [senhaTextField tap];
    [senhaTextField typeText:@"123"];
    [app.buttons[@"login"] tap];
}

- (void)testTapViewDetailWhenSwitchIsOffDoesNothing
{
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.navigationBars[@"发现"].buttons[@"Search"] tap];
    [app.tables.staticTexts[@"Oranges - 2 dozen"] tap];
    [app.navigationBars[@"搜索"].buttons[@"发现"] tap];
    
    XCUIElementQuery *tabBarsQuery = app.tabBars;
    [tabBarsQuery.buttons[@"联系人"] tap];
    [tabBarsQuery.buttons[@"我的"] tap];
}

@end
