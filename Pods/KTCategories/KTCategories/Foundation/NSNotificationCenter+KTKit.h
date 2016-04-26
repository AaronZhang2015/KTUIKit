//
//  NSNotificationCenter+KTKit.h
//  KTCategories
//
//  Created by ZhangMing on 4/25/16.
//  Copyright © 2016 ZhangMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (KTKit)

- (void)postNotificationOnMainThread:(NSNotification *)notification;

- (void)postNotificationOnMainThread:(NSNotification *)notification
                       waitUntilDone:(BOOL)wait;

- (void)postNotificationOnMainThreadWithName:(NSString *)name
                                      object:(id)object;

- (void)postNotificationOnMainThreadWithName:(NSString *)name
                                      object:(id)object
                                    userInfo:(NSDictionary *)userInfo;

- (void)postNotificationOnMainThreadWithName:(NSString *)name
                                      object:(id)object
                                    userInfo:(NSDictionary *)userInfo
                               waitUntilDone:(BOOL)wait;

@end
