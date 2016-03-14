//
//  XPDetailPostViewController.h
//  XPApp
//
//  Created by iiseeuu on 15/12/30.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseViewController.h"
#import "XPCreatePostViewController.h"

@interface XPDetailPostViewController : XPBaseViewController

@property (nonatomic, strong) NSString *forumtopicId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) PushFromType pushFromType;

@end
