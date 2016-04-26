//
//  KTSlideView.h
//  KTUIKit
//
//  Created by ZhangMing on 4/25/16.
//  Copyright © 2016 ZhangMing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class KTSlideView;

@protocol KTSlideViewDataSource <NSObject>

- (NSUInteger)numberOfViewControllers:(KTSlideView *)slideView;

- (__kindof UIViewController *)kt_slideView:(KTSlideView *)slideView viewControllerAtIndex:(NSUInteger)index;

@end

@protocol KTSlideViewDelegate <NSObject>

- (void)kt_slideView:(KTSlideView *)slideView didSelectedIndex:(NSUInteger)index;

@end

@interface KTSlideView : UIView

@property (nonatomic, weak) id<KTSlideViewDataSource> dataSource;

@property (nonatomic, weak) id<KTSlideViewDelegate> delegate;

///   当前选中索引
@property (nonatomic, assign) NSInteger selectedIndex;

///  当前选中的视图控制器
@property (nonatomic, strong, readonly) UIViewController *selectedViewController;

///  切换页面是否有动画效果
@property (nonatomic, assign) BOOL animated;

///  是否可以滑动，默认可以滑动
@property (nonatomic, assign) BOOL scrollEnabled;

///  切换页面动画时长
@property (nonatomic, assign) NSTimeInterval duration;

///  加载数据
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
