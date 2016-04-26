//
//  NSArray+KTKit.h
//  KTCategories
//
//  Created by ZhangMing on 4/25/16.
//  Copyright © 2016 ZhangMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (KTKit)

- (NSArray *)distinctObjects;

- (NSArray *)distinctObjectsFromArray:(NSArray *)array;

@end
