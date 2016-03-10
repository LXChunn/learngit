//
//  XCViewModel.h
//  RACdemo
//
//  Created by Mac OS on 16/3/10.
//  Copyright © 2016年 JASON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface XCViewModel : NSObject

@property (nonatomic,strong,readonly)RACCommand* listCommand;
@property (nonatomic,strong,readonly)NSArray* list;

@end
