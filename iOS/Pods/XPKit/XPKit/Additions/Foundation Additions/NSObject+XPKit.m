//
//  NSObject+XPKit.m
//  XPKit
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014 - 2015 Fabrizio Brancati. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "NSObject+XPKit.h"
#import <objc/runtime.h>


@implementation NSObject (XPKit)


- (void)dispatchWorker:(void (^)())worker withCallback:(void (^)())callback {
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(queue, ^{
	    worker();
	    dispatch_async(dispatch_get_main_queue(), ^{
	        callback();
		});
	});
}

+ (void)dispatchWorker:(void (^)())worker withCallback:(void (^)())callback {
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(queue, ^{
	    worker();
	    dispatch_async(dispatch_get_main_queue(), ^{
	        callback();
		});
	});
}

- (void)performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay onMainThread:(BOOL)useMainThread {
	int64_t delta = (int64_t)(1.0e9 * delay);
	if (useMainThread) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), dispatch_get_main_queue(), block);
	}
	else {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
	}
}

+ (void)performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay onMainThread:(BOOL)useMainThread {
	int64_t delta = (int64_t)(1.0e9 * delay);
	if (useMainThread) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), dispatch_get_main_queue(), block);
	}
	else {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
	}
}

- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 {
	NSMethodSignature *sig = [self methodSignatureForSelector:selector];

	if (sig) {
		NSInvocation *invo = [NSInvocation invocationWithMethodSignature:sig];
		[invo setTarget:self];
		[invo setSelector:selector];
		[invo setArgument:&p1 atIndex:2];
		[invo setArgument:&p2 atIndex:3];
		[invo setArgument:&p3 atIndex:4];
		[invo invoke];

		if (sig.methodReturnLength) {
			id anObject;
			[invo getReturnValue:&anObject];
			return anObject;
		}
		else {
			return nil;
		}
	}
	else {
		return nil;
	}
}

- (void)performSelectorOnMainThread:(SEL)selector withObjects:(id)obj1, ...
{
	id argitem; va_list args;
	NSMutableArray *objects = [[NSMutableArray alloc] init];

	if (obj1 != nil) {
		[objects addObject:obj1];
		va_start(args, obj1);

		while ((argitem = va_arg(args, id)))
			[objects addObject:argitem];

		va_end(args);
	}

	[self performSelectorOnMainThread:selector withObjectArray:objects];
}

- (void)performSelectorOnMainThread:(SEL)selector withObjectArray:(NSArray *)objects {
	NSMethodSignature *signature = [self methodSignatureForSelector:selector];

	if (signature) {
		NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
		[invocation setTarget:self];
		[invocation setSelector:selector];

		for (NSUInteger i = 0; i < objects.count; ++i) {
			id obj = [objects objectAtIndex:i];
			[invocation setArgument:&obj atIndex:(NSInteger)(i + 2)];
		}

		[invocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:YES];
	}
}

- (NSString *)className {
	return NSStringFromClass([self class]);
}

//referenced: http://stackoverflow.com/questions/2410081/return-all-properties-of-an-object-in-objective-c
- (NSDictionary *)propertiesDictionaryOfObject:(id)obj withClassType:(Class)cls {
	unsigned int propCount;
	objc_property_t *properties = class_copyPropertyList(cls, &propCount);

	NSMutableDictionary *result = [NSMutableDictionary dictionary];
	NSString *propertyName;
	id propertyValue;

	for (size_t i = 0; i < propCount; i++) {
		@try {
			propertyName = [NSString stringWithUTF8String:property_getName(properties[i])];
			propertyValue = [obj valueForKey:propertyName];
			[result setValue:(propertyValue ? propertyValue : @"nil") forKey:propertyName];
		}
		@catch (NSException *exception)
		{
			/* do nothing */
		}
	}

	free(properties);

	//lookup super classes
	Class superCls = class_getSuperclass(cls);

	while (superCls && ![superCls isEqual:[NSObject class]]) {
		[result addEntriesFromDictionary:[self propertiesDictionaryOfObject:obj withClassType:superCls]];
		superCls = class_getSuperclass(superCls);
	}

	return result;
}

- (NSDictionary *)propertiesDictionary {
	return [self propertiesDictionaryOfObject:self withClassType:[self class]];
}

@end
