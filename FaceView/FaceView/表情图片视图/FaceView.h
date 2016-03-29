//
//  FaceView.h
//  FaceView
//
//  Created by mac on 16/1/12.
//  Copyright © 2016年 YF_S. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnItemNameBlock)(NSString *itemName);

@interface FaceView : UIView

//重写init方法
-(instancetype)initWithFrame:(CGRect)frame withReturnBlock:(returnItemNameBlock)block;

@end

//每个内容视图
@interface FaceViewItem : UIView

//重写init方法
-(instancetype)initWithFrame:(CGRect)frame withReturnBlock:(returnItemNameBlock)block;

@property (nonatomic,retain) NSArray *dataList;

@end