//
//  UIApplication+KTKit.h
//  KTCategories
//
//  Created by ZhangMing on 4/25/16.
//  Copyright © 2016 ZhangMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (KTKit)

@property (nonatomic, readonly) NSURL *documentsURL;
@property (nonatomic, readonly) NSString *documentsPath;

@property (nonatomic, readonly) NSURL *cachesURL;
@property (nonatomic, readonly) NSString *cachesPath;

@property (nonatomic, readonly) NSURL *libraryURL;
@property (nonatomic, readonly) NSString *libraryPath;

@property (nonatomic, readonly) NSString *appBundleName;

@property (nonatomic, readonly) NSString *appBundleID;

@property (nonatomic, readonly) NSString *appVersion;

@property (nonatomic, readonly) NSString *appBuildVersion;

@property (nonatomic, readonly) int64_t memoryUsage;

@property (nonatomic, readonly) float cpuUsage;

@end
