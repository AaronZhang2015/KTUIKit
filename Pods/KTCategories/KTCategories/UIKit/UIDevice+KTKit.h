//
//  UIDevice+KTKit.h
//  KTCategories
//
//  Created by ZhangMing on 4/25/16.
//  Copyright © 2016 ZhangMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (KTKit)

@property (nonatomic, readonly) BOOL isPad;

@property (nonatomic, readonly) BOOL isSimulator;

@property (nonatomic, readonly) NSString *machineModel;

@property (nonatomic, readonly) NSString *machineModelName;

#pragma mark - Disk Space

@property (nonatomic, readonly) int64_t diskSpace;

@property (nonatomic, readonly) int64_t diskSpaceFree;

@property (nonatomic, readonly) int64_t diskSpaceUsed;


#pragma mark - Memory Information
@property (nonatomic, readonly) int64_t memoryTotal;

@property (nonatomic, readonly) int64_t memoryUsed;

@property (nonatomic, readonly) int64_t memoryFree;

@property (nonatomic, readonly) int64_t memoryActive;

@property (nonatomic, readonly) int64_t memoryInactive;

@property (nonatomic, readonly) int64_t memoryWired;

@property (nonatomic, readonly) int64_t memoryPurgeable;

@property (nonatomic, readonly) int64_t memoryCurrentUsed;

#pragma mark - CPU Information
@property (nonatomic, readonly) NSUInteger cpuCount;

@property (nonatomic, readonly) float cpuUsage;

@property (nonatomic, readonly) NSArray *cpuUsagePerProcessor;


@end
