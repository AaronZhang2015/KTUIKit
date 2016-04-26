//
//  UIGestureRecognizer+KTKit.h
//  KTCategories
//
//  Created by ZhangMing on 4/25/16.
//  Copyright © 2016 ZhangMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (KTKit)

- (instancetype)initWithActionBlock:(void (^)(id sender))block;

- (void)addActionBlock:(void (^)(id sender))block;

- (void)removeAllActionBlock;

@end
