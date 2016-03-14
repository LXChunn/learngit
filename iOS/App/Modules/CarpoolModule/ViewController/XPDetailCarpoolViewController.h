//
//  XPDetailCarpoolViewController.h
//  XPApp
//
//  Created by iiseeuu on 16/2/22.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPBaseViewController.h"
#import "XPCarpoolModel.h"

@interface XPDetailCarpoolViewController : XPBaseViewController
@property(nonatomic,strong)XPCarpoolModel *detailModel;
@property (nonatomic,assign) BOOL isDelete;
@end
