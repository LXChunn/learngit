//
//  SQLite3TestViewController.m
//  SQLite3Test
//
//  Created by fengxiao on 11-11-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SQLite3TestViewController.h"
#import "operateSqlViewController.h"

@implementation SQLite3TestViewController
@synthesize utableView;
@synthesize listData;
@synthesize searchBar;

- (void)viewDidLoad{
	sqlService *sqlSer = [[sqlService alloc] init];
	listData = [sqlSer getTestList];
}

- (void)viewDidAppear:(BOOL)animated{
	sqlService *sqlSer = [[sqlService alloc] init];
	listData = [sqlSer getTestList];
	[sqlSer release];
	[utableView reloadData];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	utableView = nil;
	listData = nil;
	searchBar = nil;
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[utableView release];
	[listData release];
	[searchBar release];
    [super dealloc];
}


- (IBAction)insertValue{
	
	[searchBar resignFirstResponder];
	
	operateSqlViewController *operateController = [[operateSqlViewController alloc] init ];
	UINavigationController *theNavController = [[UINavigationController alloc]
												initWithRootViewController:operateController];
	operateController.oprateType = 0;//optrateType为0时为数据插入
	[operateController release];
	theNavController.navigationBar.tintColor = [UIColor blackColor];
	[self presentModalViewController:theNavController animated:YES];
	[theNavController release];
	
}

- (IBAction)updateValue{
	
	[searchBar resignFirstResponder];
	
	NSIndexPath *indexPath = [utableView  indexPathForSelectedRow];
	
	if (indexPath == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
														message:@"请选择要更新的项" 
													   delegate:self
											  cancelButtonTitle:@"好" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	NSUInteger row = [indexPath row];
	sqlTestList *sqlList = [[sqlTestList alloc]init];
	sqlList = [listData objectAtIndex:row];
		
	operateSqlViewController *operateController = [[operateSqlViewController alloc] init ];
	UINavigationController *theNavController = [[UINavigationController alloc]
												initWithRootViewController:operateController];
	operateController.oprateType = 1;//optrateType为1时为数据更新
	operateController.sqlValue = sqlList;
	theNavController.navigationBar.tintColor = [UIColor blackColor];
	[self presentModalViewController:theNavController animated:YES];
	[sqlList release];
	[operateController release];
	[theNavController release];
}

- (IBAction)getAllValue{
	
	[searchBar resignFirstResponder];
	
	sqlService *sqlSer = [[sqlService alloc] init];
	listData = [sqlSer getTestList];
    [utableView reloadData];
	[sqlSer release];
	
}
- (IBAction)deleteValue{
	
	[searchBar resignFirstResponder];
	
	NSIndexPath *indexPath = [utableView  indexPathForSelectedRow];
	
	if (indexPath == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
														message:@"请选择要删除的项" 
													   delegate:self
											  cancelButtonTitle:@"好" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	NSUInteger row = [indexPath row];
	sqlTestList *sqlList = [[sqlTestList alloc]init];
	sqlList = [listData objectAtIndex:row];
	
	sqlService *sqlSer = [[sqlService alloc] init];
	
	 if ([sqlSer deleteTestList:sqlList]) {
		 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
														 message:@"删除数据成功" 
														delegate:self
											   cancelButtonTitle:@"好" 
											   otherButtonTitles:nil];
		 [alert show];
		 [alert release];
		 
		 //删除成功后重新获取数据更新列表
		 listData = [sqlSer getTestList];
		 [utableView reloadData];

	 }
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
														message:@"删除数据失败" 
													   delegate:self
											  cancelButtonTitle:@"好" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	[sqlList release];
	[sqlSer release];
}
- (IBAction)searchValue{
	
	if ([searchBar.text isEqualToString:@""]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
														message:@"请输入要查询数据的ID" 
													   delegate:self
											  cancelButtonTitle:@"好" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	else {
		int idNum = [searchBar.text intValue];
		sqlService *sqlSer = [[sqlService alloc] init];
		listData = [sqlSer searchTestList:idNum];

		if ([listData  count] == 0) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
															message:@"sorry,未查询到数据，请查看ID是否有误" 
														   delegate:self
												  cancelButtonTitle:@"好" 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
			return;
		}
		
		[searchBar resignFirstResponder];
		[utableView reloadData];
		[sqlSer release];
	
	}

}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CustomIdentifier = @"CustomIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomIdentifier];
	
	if ( cell == nil ) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 
									     reuseIdentifier:CustomIdentifier] autorelease];
		
	}
	NSUInteger row = [indexPath row];
	sqlTestList *sqlList = [[[sqlTestList alloc] init] autorelease];
	sqlList = [listData objectAtIndex:row];
	NSString *strID = [NSString stringWithFormat:@"%d",sqlList.sqlID];
	cell.detailTextLabel.text = sqlList.sqlText;
	cell.textLabel.text = strID;
	return cell;
}

@end
