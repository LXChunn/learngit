//
//  operateSqlViewController.h
//  SQLite3Test
//
//  Created by fengxiao on 11-12-1.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlService.h"

@interface operateSqlViewController : UIViewController {
	
	UITextField *idValue;
	UITextField *textValue;
	int oprateType;//区分数据插入与更新
	sqlTestList *sqlValue;
}

@property (nonatomic, retain) IBOutlet UITextField *idValue;
@property (nonatomic, retain) IBOutlet UITextField *textValue;
@property (nonatomic, retain) sqlTestList *sqlValue;
@property (nonatomic) int oprateType;

@end
