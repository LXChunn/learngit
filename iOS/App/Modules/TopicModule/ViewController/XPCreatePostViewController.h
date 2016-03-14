//
//  XPCreatePostViewController.h
//  XPApp
//
//  Created by iiseeuu on 15/12/30.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseViewController.h"
#import "XPTransferOrBuyModel.h"

typedef enum : NSUInteger {
    PushFromNeighborhood,
    PushFromMyPost,
    PushFromMyComment,
} PushFromType;

@interface XPCreatePostViewController : XPBaseViewController

@property (nonatomic, strong) XPTransferOrBuyModel *forumTopicModel;
@property (strong, nonatomic) NSString *forumTopicId;
@property (nonatomic, assign) PushFromType pushFromType;

@end
