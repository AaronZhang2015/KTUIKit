//
//  KTFixedSlideView.h
//  KTUIKit
//
//  Created by ZhangMing on 4/26/16.
//  Copyright © 2016 ZhangMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTTabItem.h"

@class KTFixedSlideView;
@protocol KTFixedSlideViewDataSource <NSObject>

- (NSUInteger)numberOfViewControllers:(KTFixedSlideView *)slideView;

- (__kindof UIViewController *)kt_fixedSlideView:(KTFixedSlideView *)slideView viewControllerAtIndex:(NSUInteger)index;

@end

@protocol KTFixedSlideViewDelegate <NSObject>

- (void)kt_fixedSlideView:(KTFixedSlideView *)slideView didSelectedIndex:(NSUInteger)index;


@end

@interface KTFixedSlideView : UIView

@property (nonatomic, weak) id<KTFixedSlideViewDelegate> delegate;

@property (nonatomic, weak) id<KTFixedSlideViewDataSource> dataSource;

@property (nonatomic, assign) CGFloat tabBarHeight;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) NSArray<KTTabItem *> *items;

@property (nonatomic, assign) BOOL scrollEnabled;

@property (nonatomic, assign) CGFloat trackHeight;

@property (nonatomic, strong) UIColor *trackColor;

@property (nonatomic, assign) BOOL trackAnimated;

@property (nonatomic, assign) BOOL animated;

- (void)reloadData;

@end
