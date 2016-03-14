//
//  XPNoDataView.h
//  XPApp
//
//  Created by jy on 16/1/11.
//  Copyright © 2016年 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    NoDataTypeOfDefault,
    NoDataTypeOfCollection,
    NoDataTypeOfPrivateMessage,
    NoDataTypeOfComment,
    NoDataTypeOfPost,
} NoDataType;

@interface XPNoDataView : UIView

- (void)configureUIWithType:(NoDataType)type;

@end
