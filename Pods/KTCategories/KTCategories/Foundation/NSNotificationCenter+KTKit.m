//
//  NSNotificationCenter+KTKit.m
//  KTCategories
//
//  Created by ZhangMing on 4/25/16.
//  Copyright © 2016 ZhangMing. All rights reserved.
//

#import "NSNotificationCenter+KTKit.h"
#include <pthread.h>

@implementation NSNotificationCenter (KTKit)

- (void)postNotificationOnMainThread:(NSNotification *)notification {
    [self postNotificationOnMainThread:notification waitUntilDone:NO];
}

- (void)postNotificationOnMainThread:(NSNotification *)notification waitUntilDone:(BOOL)wait {
    if (pthread_main_np()) {
        return [self postNotification:notification];
    }
    [[self class] performSelectorOnMainThread:@selector(k_postNotification:) withObject:notification waitUntilDone: wait];
}

- (void)postNotificationOnMainThreadWithName:(NSString *)name object:(id)object {
    [self postNotificationOnMainThreadWithName:name object:object userInfo:nil];
}

- (void)postNotificationOnMainThreadWithName:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo {
    [self postNotificationOnMainThreadWithName:name object:object userInfo:userInfo waitUntilDone:NO];
}

- (void)postNotificationOnMainThreadWithName:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo waitUntilDone:(BOOL)wait {
    if (pthread_main_np()) {
        return [self postNotificationName:name object:object userInfo:userInfo];
    }
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithCapacity:3];
    info[@"name"] = name;
    info[@"object"] = object;
    info[@"userInfo"] = userInfo;
    [[self class] performSelectorOnMainThread:@selector(k_postNotificationName:) withObject:info waitUntilDone: wait];
}

+ (void)k_postNotification:(NSNotification *)notification {
    [[self defaultCenter] postNotification:notification];
}

+ (void)k_postNotificationName:(NSDictionary *)info {
    NSString *name = info[@"name"];
    id object = info[@"object"];
    NSDictionary *userInfo = info[@"userInfo"];
    [[self defaultCenter] postNotificationName:name object:object userInfo:userInfo];
}

@end
