//
//  UIGestureRecognizer+KTKit.m
//  KTCategories
//
//  Created by ZhangMing on 4/25/16.
//  Copyright © 2016 ZhangMing. All rights reserved.
//

#import "UIGestureRecognizer+KTKit.h"
#import <objc/runtime.h>

static const int block_key;

@interface KUIGestureRecognizerBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(id sender);

- (id)initWithBlock:(void (^)(id sender))block;
- (void)invoke:(id)sender;

@end

@implementation KUIGestureRecognizerBlockTarget

- (id)initWithBlock:(void (^)(id sender))block {
    if (self = [super init]) {
        _block = [block copy];
    }
    return self;
}

- (void)invoke:(id)sender {
    if (_block) {
        _block(sender);
    }
}

@end

@implementation UIGestureRecognizer (KTKit)

- (instancetype)initWithActionBlock:(void (^)(id sender))block {
    if (self = [self init]) {
        [self addActionBlock:block];
    }
    return self;
}

- (void)addActionBlock:(void (^)(id sender))block {
    KUIGestureRecognizerBlockTarget *target = [[KUIGestureRecognizerBlockTarget alloc] initWithBlock:block];
    [self addTarget:target action:@selector(invoke:)];
    NSMutableArray *targets = [self k_allUIGestureRecognizerBlockTargets];
    [targets addObject:target];
}

- (void)removeAllActionBlock {
    NSMutableArray *targets = [self k_allUIGestureRecognizerBlockTargets];
    [targets enumerateObjectsUsingBlock:^(id  _Nonnull target, NSUInteger idx, BOOL * _Nonnull stop) {
        [self removeTarget:target action:@selector(invoke:)];
    }];
    [targets removeAllObjects];
}

- (NSMutableArray *)k_allUIGestureRecognizerBlockTargets {
    NSMutableArray *targets = objc_getAssociatedObject(self, &block_key);
    if (!targets) {
        targets = [NSMutableArray array];
        objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

@end
