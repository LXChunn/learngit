//
//  SQLite3TestAppDelegate.h
//  SQLite3Test
//
//  Created by fengxiao on 11-11-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SQLite3TestViewController;

@interface SQLite3TestAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SQLite3TestViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SQLite3TestViewController *viewController;

@end

