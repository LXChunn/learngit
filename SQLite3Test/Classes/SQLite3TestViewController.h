//
//  SQLite3TestViewController.h
//  SQLite3Test
//
//  Created by fengxiao on 11-11-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlService.h"
@interface SQLite3TestViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> {

	UITableView *utableView;
	NSArray *listData;
	UISearchBar *searchBar;
}

@property (nonatomic, retain) IBOutlet UITableView *utableView;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) NSArray *listData;

- (IBAction)insertValue;
- (IBAction)updateValue;
- (IBAction)getAllValue;
- (IBAction)deleteValue;
- (IBAction)searchValue;


@end

