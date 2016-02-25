//
//  NSObject+XPFlyweightTransmit.h
//  XPApp
//
//  Created by huangxinping on 15/7/16.
//  Copyright (c) 2015年 iiseeuu.com. All rights reserved.
//
/*
 @interface UINavigationBar (XP)
 xp_property_as_associated_strong(id, test2);
 @end
 
 @implementation UINavigationBar (XP)
 xp_property_def_associated_strong(id, test2)
 @end
 
 */

#import <Foundation/Foundation.h>

#pragma mark - strong
#define xp_property_as_associated_strong(__type, __name) \
@property (nonatomic, strong, setter = set__ ## __name:, getter = __ ## __name) __type __name;
#define xp_property_def_associated_strong(__type, __name) \
- (__type)__ ## __name   \
{ return [self xp_getAssociatedObjectForKey:#__name]; }   \
- (void)set__ ## __name: (id)__ ## __name   \
{ [self xp_retainAssociatedObject:__ ## __name forKey:#__name]; }

#pragma mark - assign
#define xp_property_as_associated_assign(__type, __name) \
@property (nonatomic, assign, setter = set__ ## __name:, getter = __ ## __name) __type __name;
#define xp_property_def_associated_assign(__type, __name) \
- (__type)__ ## __name   \
{ return [self xp_getAssociatedObjectForKey:#__name]; }   \
- (void)set__ ## __name: (id)__ ## __name   \
{ [self xp_assignAssociatedObject:__ ## __name forKey:#__name]; }

@interface NSObject (XPFlyweightTransmit)

- (id)xp_getAssociatedObjectForKey:(const char *)key;
- (id)xp_retainAssociatedObject:(id)obj forKey:(const char *)key;

@end
