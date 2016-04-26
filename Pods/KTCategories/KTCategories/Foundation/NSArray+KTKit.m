//
//  NSArray+KTKit.m
//  KTCategories
//
//  Created by ZhangMing on 4/25/16.
//  Copyright © 2016 ZhangMing. All rights reserved.
//

#import "NSArray+KTKit.h"

@implementation NSArray (KTKit)

- (NSArray *)distinctObjects
{
    NSMutableArray *result = [@[] mutableCopy];
    for (id obj1 in self) {
        BOOL has = NO;
        for (id obj2 in result) {
            if ([obj1 isEqual:obj2]) {
                has = YES;
                break;
            }
        }
        
        if (!has) {
            [result addObject:obj1];
        }
    }
    
    return [result copy];
}

- (NSArray *)distinctObjectsFromArray:(NSArray *)array
{
    NSMutableArray *result = [@[] mutableCopy];
    
    for (id obj1 in array) {
        BOOL has = NO;
        for (id obj2 in self) {
            if ([obj1 isEqual:obj2]) {
                has = YES;
                break;
            }
        }
        
        if (!has) {
            [result addObject:obj1];
        }
    }
    
    return [result copy];
}

@end
