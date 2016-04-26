//
//  UIControl+KTKit.m
//  KTCategories
//
//  Created by ZhangMing on 4/25/16.
//  Copyright © 2016 ZhangMing. All rights reserved.
//

#import "UIControl+KTKit.h"
#import <objc/runtime.h>

static const int block_key;

@interface KUIControlBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(id sender);
@property (nonatomic, assign) UIControlEvents events;

- (id)initWithBlock:(void (^)(id sender))block controlEvents:(UIControlEvents)events;
- (void)invoke:(id)sender;

@end

@implementation KUIControlBlockTarget

- (id)initWithBlock:(void (^)(id))block controlEvents:(UIControlEvents)events {
    if (self = [super init]) {
        _block = [block copy];
        _events = events;
    }
    
    return self;
}

- (void)invoke:(id)sender {
    if (_block) {
        _block(sender);
    }
}

@end

@implementation UIControl (KTKit)

- (void)removeAllTargets {
    [[self allTargets] enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self removeTarget:obj action:NULL forControlEvents:UIControlEventAllEvents];
    }];
}

- (void)setTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    if (!target || !action || controlEvents) {
        return;
    }
    
    NSSet *allTargets = [self allTargets];
    for (id target in allTargets) {
        NSArray *actions = [self actionsForTarget:target forControlEvent:controlEvents];
        for (NSString *action in actions) {
            [self removeTarget:target action:NSSelectorFromString(action) forControlEvents:controlEvents];
        }
    }
    
    [self addTarget:target action:action forControlEvents:controlEvents];
}

- (void)addBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block {
    if (!controlEvents) {
        return;
    }
    
    KUIControlBlockTarget *target = [[KUIControlBlockTarget alloc] initWithBlock:block controlEvents:controlEvents];
    [self addTarget:target action:@selector(invoke:) forControlEvents:controlEvents];
    
    NSMutableArray *allTargets = [self k_allUIControlBlockTargets];
    [allTargets addObject:target];
    
}

- (void)setBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block {
    [self removeAllBlocksForControlEvents:controlEvents];
    [self addBlockForControlEvents:controlEvents block:block];
}

- (void)removeAllBlocksForControlEvents:(UIControlEvents)controlEvents {
    if (!controlEvents) {
        return;
    }
    
    NSMutableArray *targets = [self k_allUIControlBlockTargets];
    NSMutableArray *removes = [NSMutableArray array];
    for (KUIControlBlockTarget *target in targets) {
        if (target.events & controlEvents) {
            UIControlEvents newEvents = target.events & (~controlEvents);
            
            [self removeTarget:target action:@selector(invoke:) forControlEvents:target.events];
            if (newEvents) {
                target.events = newEvents;
                [self addTarget:target action:@selector(invoke:) forControlEvents:target.events];
            } else {
                [removes addObject:target];
            }
        }
    }
    
    [targets removeObjectsInArray:removes];
}

- (NSMutableArray *)k_allUIControlBlockTargets {
    NSMutableArray *targets = objc_getAssociatedObject(self, &block_key);
    if (!targets) {
        targets = [NSMutableArray array];
        objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}


@end
