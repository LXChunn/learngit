//
//  XPAPIManager.m
//  Huaban
//
//  Created by huangxinping on 4/21/15.
//  Copyright (c) 2015 iiseeuu.com. All rights reserved.
//

#import "XPAPIManager.h"
#import <JSONModel-RACExtensions/RACJSONModel.h>
#import <JSONModel/JSONModel.h>

NSString *const kXPAPIErrorDomain = @"kXPAPIErrorDomain";
NSString *const kXPAPIErrorDescription = @"请求失败，请稍后重试!";

const NSInteger kXPAPI_Timeout = 15;

@implementation XPAPIManager

#pragma mark - Normal Request
- (AFHTTPRequestOperationManager *)manager
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/html",@"text/plain",@"text/json",@"text/xml",@"application/json",@"application/xml",@"application/x-www-form-urlencoded"]];
    //        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/json"];
    //        instance.requestSerializer = [AFHTTPRequestSerializer serializer];
    //        instance.responseSerializer = [AFHTTPResponseSerializer serializer];
    //        instance.responseSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.requestSerializer.timeoutInterval = kXPAPI_Timeout;
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    manager.responseSerializer.acceptableStatusCodes = nil;
    return manager;
}

- (RACSignal *)rac_GET:(NSString *)path parameters:(id)parameters
{
    AFHTTPRequestOperationManager *manager = [self manager];
    return /*[*/ [[manager rac_GET:path parameters:parameters] reduceEach:^id (NSDictionary *dictionary, NSHTTPURLResponse *response){
        return dictionary;
    }] /* deliverOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground]]*/;
}

- (RACSignal *)rac_POST:(NSString *)path parameters:(id)parameters
{
    AFHTTPRequestOperationManager *manager = [self manager];
    return [[manager rac_POST:path parameters:parameters] reduceEach:^id (NSDictionary *dictionary, NSHTTPURLResponse *response){
        return dictionary;
    }];
}

- (RACSignal *)rac_PUT:(NSString *)path parameters:(id)parameters
{
    AFHTTPRequestOperationManager *manager = [self manager];
    return [[manager rac_PUT:path parameters:parameters] reduceEach:^id (NSDictionary *dictionary, NSHTTPURLResponse *response){
        return dictionary;
    }];
}

- (RACSignal *)rac_DELETE:(NSString *)path parameters:(id)parameters
{
    AFHTTPRequestOperationManager *manager = [self manager];
    return [[manager rac_DELETE:path parameters:parameters] reduceEach:^id (NSDictionary *dictionary, NSHTTPURLResponse *response){
        return dictionary;
    }];
}

- (RACSignal *)rac_PATCH:(NSString *)path parameters:(id)parameters
{
    AFHTTPRequestOperationManager *manager = [self manager];
    return [[manager rac_PATCH:path parameters:parameters]reduceEach:^id (NSDictionary *dictionary, NSHTTPURLResponse *response){
        return dictionary;
    }];
}

@end

@implementation XPAPIManager (Restful)

- (RACSignal *)rac_MappingForClass:(Class)class array:(NSArray *)array
{
    return [class parseSignalForArray:array];
}

- (RACSignal *)rac_MappingForClass:(Class)class dictionary:(NSDictionary *)dictionary
{
    return [class parseSignalForDictionary:dictionary];
}

- (RACSignal *)rac_MergeMappingForClass:(Class)class dictionary:(NSDictionary *)dictionary
{
    [[class singleton] mergeFromDictionary:dictionary useKeyMapping:YES];
    return [RACSignal return :[class singleton]];
}

@end

@implementation XPAPIManager (Image)

- (UIImage *)imageCacheWithPath:(NSString *)path
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:path] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0f];
    UIImage *image = [[UIImageView sharedImageCache] cachedImageForRequest:urlRequest];
    if(image != nil) {
        return image;
    }
    
    return nil;
}

- (RACSignal *)rac_remoteImage:(NSString *)path
{
    UIImage *cacheImage = [self imageCacheWithPath:path];
    if(cacheImage) {
        return [RACSignal createSignal:^RACDisposable *(id < RACSubscriber > subscriber) {
            [subscriber sendNext:cacheImage];
            [subscriber sendCompleted];
            return [RACDisposable disposableWithBlock:^{
            }];
        }];
    }
    
    return [RACSignal createSignal:^RACDisposable *(id < RACSubscriber > subscriber) {
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
        AFHTTPRequestOperation *postOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        postOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [postOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            UIImage *image = responseObject;
            [[UIImageView sharedImageCache] cacheImage:image forRequest:urlRequest];
            [subscriber sendNext:image];
            [subscriber sendCompleted];
        }
                                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                 [subscriber sendError:[NSError errorWithDomain:kXPAPIErrorDomain code:kXPAPIErrorNotFound userInfo:error.userInfo]];
                                             }];
        [postOperation start];
        
        return [RACDisposable disposableWithBlock:^{
            [postOperation cancel];
        }];
    }];
}

@end
