//
//  KTFixedSlideView.m
//  KTUIKit
//
//  Created by ZhangMing on 4/26/16.
//  Copyright © 2016 ZhangMing. All rights reserved.
//

#import "KTFixedSlideView.h"
#import "KTFixedTabView.h"
#import "KTSlideView.h"

@interface KTFixedSlideView()<KTSlideViewDataSource, KTSlideViewDelegate, KTFixedTabViewDelegate>

@property (nonatomic, strong) KTFixedTabView *tabView;
@property (nonatomic, strong) KTSlideView *slideView;

@end

@implementation KTFixedSlideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    [self addSubview:self.tabView];
    [self addSubview:self.slideView];
    _tabBarHeight = 60;
    
    self.animated = NO;
    self.trackColor = [UIColor blueColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tabView.frame = CGRectMake(0, 0, self.bounds.size.width, self.tabBarHeight);
    self.slideView.frame = CGRectMake(0, self.tabBarHeight, self.bounds.size.width, self.bounds.size.height - self.tabBarHeight);
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    [self reloadData];
}

- (void)reloadData
{
    [self.slideView reloadData];
    [self.tabView reloadData];
}

#pragma mark - KTSlideViewDataSource
- (NSUInteger)numberOfViewControllers:(KTSlideView *)slideView
{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfViewControllers:)]) {
        return [self.dataSource numberOfViewControllers:self];
    }
    return 0;
}

- (__kindof UIViewController *)kt_slideView:(KTSlideView *)slideView viewControllerAtIndex:(NSUInteger)index
{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(kt_fixedSlideView:viewControllerAtIndex:)]) {
        return [self.dataSource kt_fixedSlideView:self viewControllerAtIndex:index];
    }
    
    return nil;
}

#pragma mark - KTSlideViewDelegate
- (void)kt_slideView:(KTSlideView *)slideView didSelectedIndex:(NSUInteger)index
{
    [self.tabView setSelectedIndex:index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(kt_fixedSlideView:didSelectedIndex:)]) {
        [self.delegate kt_fixedSlideView:self didSelectedIndex:index];
    }
}

#pragma mark - KTFixedTabViewDelegate
-(void)kt_fixedTabView:(KTFixedTabView *)tabView didSelectedAtIndex:(NSInteger)index
{
    [self.slideView setSelectedIndex:index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(kt_fixedSlideView:didSelectedIndex:)]) {
        [self.delegate kt_fixedSlideView:self didSelectedIndex:index];
    }
}

#pragma mark - Getters and Setters
- (KTSlideView *)slideView
{
    if (!_slideView) {
        _slideView = [[KTSlideView alloc] init];
        _slideView.dataSource = self;
        _slideView.delegate = self;
        _slideView.scrollEnabled = YES;
    }
    
    return _slideView;
}

- (KTFixedTabView *)tabView
{
    if (!_tabView) {
        _tabView = [[KTFixedTabView alloc] init];
        _tabView.delegate = self;
    }
    
    return _tabView;
}

- (void)setItems:(NSArray<KTTabItem *> *)items
{
    self.tabView.items = items;
}

- (void)setTrackColor:(UIColor *)trackColor
{
    self.tabView.trackColor = trackColor;
}

- (void)setTrackAnimated:(BOOL)trackAnimated
{
    _trackAnimated = trackAnimated;
    self.tabView.trackAnimated = _trackAnimated;
}

- (void)setAnimated:(BOOL)animated
{
    _animated = animated;
    self.slideView.animated = _animated;
}

- (void)setTrackHeight:(CGFloat)trackHeight
{
    _trackHeight = trackHeight;
    self.tabView.trackHeight = trackHeight;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled
{
    _scrollEnabled = scrollEnabled;
    self.slideView.scrollEnabled = scrollEnabled;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    [self.slideView setSelectedIndex:selectedIndex];
    [self.tabView setSelectedIndex:selectedIndex];
}

@end
