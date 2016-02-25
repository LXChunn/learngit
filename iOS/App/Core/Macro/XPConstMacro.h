//
//  XPConstMacro.h
//  Huaban
//
//  Created by huangxinping on 4/25/15.
//  Copyright (c) 2015 iiseeuu.com. All rights reserved.
//

#ifndef __XPConstMacro__
#define __XPConstMacro__
#import <Foundation/Foundation.h>

#pragma mark -
/*
 TICK
 //do your work here
 TOCK
 */
#define TICK   NSDate * startTime = [NSDate date]
#define TOCK   NSLog(@"Time: %f", -[startTime timeIntervalSinceNow])

#pragma mark -
extern NSString *const kXPHeaderRefreshingText;
extern NSString *const kXPFooterRefreshingText;

#pragma mark -
extern NSString *const kXPDataErrorDescription;
extern NSString *const kXPDataLoadingDescription;

#endif
