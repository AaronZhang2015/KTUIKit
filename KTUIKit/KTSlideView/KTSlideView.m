//
//  KTSlideView.m
//  KTUIKit
//
//  Created by ZhangMing on 4/25/16.
//  Copyright © 2016 ZhangMing. All rights reserved.
//

#import "KTSlideView.h"
#import "UIView+KTLayout.h"
#import "UIView+KTKit.h"

static const CGFloat kKTOffsetThreshold = 50.0f;
static const NSTimeInterval kKTAnimateDuration = .25f;

@interface KTSlideView ()
{
    CGPoint _startLocation;
    NSUInteger _numberOfViewControllers;
    NSInteger _toIndex;
}

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, strong) UIViewController *parentViewController;

@property (nonatomic, strong) UIViewController *currentViewController;

@property (nonatomic, strong) UIViewController *toViewController;

@property (nonatomic, strong, readwrite) UIViewController *selectedViewController;

@property (nonatomic, strong) NSMutableArray<__kindof UIViewController *> *childViewControllers;

@end

@implementation KTSlideView

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
    _selectedIndex = -1;
    _duration = kKTAnimateDuration;
    _scrollEnabled = YES;
    [self addGestureRecognizer:self.panGestureRecognizer];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (_selectedIndex == -1) {
        [self reloadData];
    }
}

#pragma mark - Public Methods
- (void)reloadData
{
    _numberOfViewControllers= 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfViewControllers:)]) {
        _numberOfViewControllers = [self.dataSource numberOfViewControllers:self];
    }
    
    // Remove all viewControllers
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
        if (vc.view.superview) {
            [vc.view removeFromSuperview];
        }
    }];
    
    [self.childViewControllers removeAllObjects];
    if (_numberOfViewControllers == 0) {
        return;
    }
    
    _selectedIndex = 0;
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(kt_slideView:viewControllerAtIndex:)]) {
        self.currentViewController = [self.dataSource kt_slideView:self viewControllerAtIndex:_selectedIndex];
    }
    
    if (self.currentViewController == nil) {
        return;
    }
    
    [self showViewController:self.currentViewController];
}

#pragma mark - Private Methods
- (void)showViewController:(__kindof UIViewController *)viewController
{
    [self.parentViewController addChildViewController:viewController];
    [viewController willMoveToParentViewController:self.parentViewController];
    [self addSubview:viewController.view];
    viewController.view.frame = self.bounds;
    [viewController didMoveToParentViewController:self.parentViewController];
}

- (void)configureChildViewFrameWithOffset:(CGFloat)offsetX
{
    CGFloat delta = 0;
    if (_toIndex < _selectedIndex) {
        delta = self.bounds.origin.x - self.bounds.size.width + offsetX;
    }
    else {
        delta = self.bounds.origin.x + self.bounds.size.width + offsetX;
    }
    self.currentViewController.view.frame = CGRectMake(self.bounds.origin.x + offsetX, self.bounds.origin.y, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    if (self.toViewController) {
        self.toViewController.view.frame = CGRectMake(delta, self.bounds.origin.y, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    }
}

- (void)resetChildViewFrame
{
    [UIView animateWithDuration:_duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self configureChildViewFrameWithOffset:0.f];
    } completion:^(BOOL finished) {
        if (!finished) { return; }
        if (!self.toViewController) { return; }
    
        [self.toViewController beginAppearanceTransition:NO animated:YES];
        [self.currentViewController beginAppearanceTransition:YES animated:YES];
        // 移除VC
        [self.toViewController willMoveToParentViewController:nil];
        [self.toViewController.view removeFromSuperview];
        [self.toViewController endAppearanceTransition];
        [self.toViewController removeFromParentViewController];
        
        [self.currentViewController endAppearanceTransition];
        
        self.toViewController = nil;
    }];
}

- (void)changeChildViewController:(NSInteger)index
{
    if (index == _selectedIndex) { return; }
    
    _numberOfViewControllers = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfViewControllers:)]) {
        _numberOfViewControllers = [self.dataSource numberOfViewControllers:self];
    }
    
    if (index >= _numberOfViewControllers ) { return; }
    _toIndex = index;
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(kt_slideView:viewControllerAtIndex:)]) {
        self.toViewController = [self.dataSource kt_slideView:self viewControllerAtIndex:_toIndex];
    }
    
    if (!self.toViewController || self.toViewController.parentViewController) { return; }
    
    if (self.currentViewController) {
        [self.currentViewController willMoveToParentViewController:nil];
        [self.currentViewController beginAppearanceTransition:NO animated:NO];
    }
    
    [self.parentViewController addChildViewController:self.toViewController];
    [self.toViewController willMoveToParentViewController:self.parentViewController];
    [self addSubview:self.toViewController.view];
    
    BOOL isNextPage = _selectedIndex < _toIndex;
    if (isNextPage) {
        self.toViewController.view.frame = CGRectMake(self.bounds.size.width,
                                                      self.bounds.origin.y,
                                                      CGRectGetWidth(self.bounds),
                                                      CGRectGetHeight(self.bounds));
    }
    else {
        self.toViewController.view.frame = CGRectMake(-self.bounds.size.width,
                                                      self.bounds.origin.y,
                                                      CGRectGetWidth(self.bounds),
                                                      CGRectGetHeight(self.bounds));
    }
    
    if (self.animated && self.duration > 0) {
        [UIView animateWithDuration:self.duration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self changeChildViewFrame:isNextPage];
                         }
                         completion:^(BOOL finished) {
                             if (finished) { return; }
                             [self changeChildViewControllerFinished];
        }];
    }
    else {
        [self changeChildViewFrame:isNextPage];
        [self changeChildViewControllerFinished];
    }
}

- (void)changeChildViewFrame:(BOOL)isNextPage
{
    if (isNextPage) {
        self.currentViewController.view.frame = CGRectMake(-CGRectGetWidth(self.bounds),
                                                           self.bounds.origin.y,
                                                           CGRectGetWidth(self.bounds),
                                                           CGRectGetHeight(self.bounds));
    }
    else {
        self.currentViewController.view.frame = CGRectMake(CGRectGetWidth(self.bounds),
                                                           self.bounds.origin.y,
                                                           CGRectGetWidth(self.bounds),
                                                           CGRectGetHeight(self.bounds));
    }
    self.toViewController.view.frame = CGRectMake(0,
                                                  self.bounds.origin.y,
                                                  CGRectGetWidth(self.bounds),
                                                  CGRectGetHeight(self.bounds));
}

- (void)changeChildViewControllerFinished
{
    if (self.currentViewController) {
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController endAppearanceTransition];
        [self.currentViewController removeFromParentViewController];
    }
    [self.toViewController didMoveToParentViewController:self.parentViewController];
    
    self.currentViewController = self.toViewController;
    _selectedIndex = _toIndex;
    self.toViewController = nil;
}

#pragma mark - Gesture
- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:recognizer.view];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _startLocation = [recognizer locationInView:recognizer.view];
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfViewControllers:)]) {
            _numberOfViewControllers = [self.dataSource numberOfViewControllers:self];
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat offsetX = location.x - _startLocation.x;
        
        if (offsetX < 0) {
            if (_toIndex != _selectedIndex + 1) {
                _toIndex = _selectedIndex + 1;
                if (_toIndex < _numberOfViewControllers) {
                    [self.currentViewController beginAppearanceTransition:NO animated:NO];
                }
            }
        }
        else {
            if (_toIndex != _selectedIndex - 1) {
                _toIndex = _selectedIndex - 1;
                if (_toIndex >= 0) {
                    [self.currentViewController beginAppearanceTransition:NO animated:NO];
                }
            }
        }
        if (_toIndex >= 0 && _toIndex < _numberOfViewControllers) {
            if (!self.toViewController) {
                if (self.dataSource && [self.dataSource respondsToSelector:@selector(kt_slideView:viewControllerAtIndex:)]) {
                    self.toViewController = [self.dataSource kt_slideView:self viewControllerAtIndex:_toIndex];
                }
                if (self.toViewController && !self.toViewController.parentViewController) {
                    [self.parentViewController addChildViewController:self.toViewController];
                    [self.toViewController willMoveToParentViewController:self.parentViewController];
                    [self.toViewController beginAppearanceTransition:YES animated:NO];
                    [self addSubview:self.toViewController.view];
                }
            }
            
            [self configureChildViewFrameWithOffset:offsetX];
        }
        else {
            [self configureChildViewFrameWithOffset:offsetX / 3.0];
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat offsetX = location.x - _startLocation.x;
        
        if (_toIndex >= 0 && _toIndex < _numberOfViewControllers && _toIndex != _selectedIndex) {
            if (fabs(offsetX) > kKTOffsetThreshold) {
                [UIView animateWithDuration:_duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [self configureChildViewFrameWithOffset:offsetX > 0 ? self.bounds.size.width : -self.bounds.size.width];
                } completion:^(BOOL finished) {
                    if (!finished) { return; }
                    // 移除当前VC
                    [self.currentViewController willMoveToParentViewController:nil];
                    [self.currentViewController.view removeFromSuperview];
                    [self.currentViewController endAppearanceTransition];
                    [self.currentViewController removeFromParentViewController];
                    // 展现下个VC
                    [self.toViewController endAppearanceTransition];
                    [self.toViewController didMoveToParentViewController:self.parentViewController];
                    _selectedIndex = _toIndex;
                    _currentViewController = self.toViewController;
                    _toViewController = nil;
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(kt_slideView:didSelectedIndex:)]) {
                        [self.delegate kt_slideView:self didSelectedIndex:_selectedIndex];
                    }
                }];
            }
            else {
                [self resetChildViewFrame];
            }
        }
        else {
            [self resetChildViewFrame];
        }
    }
    else {
        [self resetChildViewFrame];
    }
}

#pragma mark - Getters and Setters

- (UIPanGestureRecognizer *)panGestureRecognizer
{
    if (!_panGestureRecognizer) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    }
    
    return _panGestureRecognizer;
}

- (UIViewController *)parentViewController
{
    if (!_parentViewController) {
        _parentViewController = [self viewController];
    }
    
    return _parentViewController;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled
{
    _scrollEnabled = scrollEnabled;
    self.panGestureRecognizer.enabled = scrollEnabled;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex != selectedIndex) {
        [self changeChildViewController:selectedIndex];
        _selectedIndex = selectedIndex;
    }
}

@end
