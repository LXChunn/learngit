//
//  operateSqlViewController.m
//  SQLite3Test
//
//  Created by fengxiao on 11-12-1.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "operateSqlViewController.h"


@implementation operateSqlViewController
@synthesize idValue;
@synthesize textValue;
@synthesize oprateType;
@synthesize sqlValue;
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidLoad{
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
								   initWithTitle:@"返回"
								   style:UIBarButtonItemStyleBordered
								   target:self
								   action:@selector(dismiss:)];
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
								   initWithTitle:@"保存"
								   style:UIBarButtonItemStyleBordered
								   target:self
								   action:@selector(saveValue:)];
	[[self navigationItem] setLeftBarButtonItem:backButton];
	[[self navigationItem] setRightBarButtonItem:saveButton];
	
	[backButton release];
	[saveButton release];
	
	if (oprateType == 0) {
		[self.navigationItem setTitle:@"数据插入"];
		idValue.enabled = YES;
	}
	else if(oprateType == 1){
		[self.navigationItem setTitle:@"数据更新"];
		idValue.text = [NSString stringWithFormat:@"%d", sqlValue.sqlID];
		textValue.text = sqlValue.sqlText;
		idValue.enabled = NO;
	}
	
}
- (void)viewDidUnload {
	idValue = nil;
	textValue = nil;
	sqlValue = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[idValue release];
	[textValue release];
	[sqlValue release];
    [super dealloc];
}

- (void)dismiss:(id)sender{
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}
- (void)saveValue:(id)sender{
	
	
	if ([idValue.text isEqualToString:@"" ]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
															message:@"请输入ID" 
														   delegate:self
											      cancelButtonTitle:@"好" 
											      otherButtonTitles:nil];
			[alert show];
			[alert release];
		return;
	}
	if ([textValue.text isEqualToString:@"" ]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
														message:@"请输入value" 
													   delegate:self
											  cancelButtonTitle:@"好" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	
	
	//初始化数据库
	sqlService *sqlSer = [[sqlService alloc] init];
	
	//数据库插入
	if (oprateType == 0) {
		
		sqlTestList *sqlInsert = [[sqlTestList alloc]init];
		sqlInsert.sqlID = [idValue.text intValue];
		sqlInsert.sqlText = textValue.text;
		
		//调用封装好的数据库插入函数
		if ([sqlSer insertTestList:sqlInsert]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
															message:@"插入数据成功" 
														   delegate:self
											      cancelButtonTitle:@"好" 
											      otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		else {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
															message:@"插入数据失败" 
														   delegate:self
											      cancelButtonTitle:@"好" 
											      otherButtonTitles:nil];
			[alert show];
			[alert release];
			
		}
		[sqlInsert release];

	}
	//数据库更新
	if(oprateType == 1){
		
		sqlTestList *newValue = [[sqlTestList alloc]init];
		newValue.sqlID = [idValue.text intValue];
		newValue.sqlText = textValue.text;
		
		//调用封装好的更新数据库函数
		if ([sqlSer updateTestList:newValue]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
															message:@"更新数据成功" 
														   delegate:self
											      cancelButtonTitle:@"好" 
											      otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		else {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
															message:@"更新数据失败" 
														   delegate:self
											      cancelButtonTitle:@"好" 
											      otherButtonTitles:nil];
			[alert show];
			[alert release];
			
		}
		
		[newValue release];
	}

	
}

@end
