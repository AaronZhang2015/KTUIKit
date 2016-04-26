//
//  KTFixedTabView.m
//  KTUIKit
//
//  Created by ZhangMing on 4/26/16.
//  Copyright © 2016 ZhangMing. All rights reserved.
//

#import "KTFixedTabView.h"
#import "UIView+KTLayout.h"
#import "UIColor+KTKit.h"
#import "KTTabItem.h"
#import "NSString+KTKit.h"

static const NSTimeInterval kKTAnimateDuration = .25f;

@interface KTFixedTabView ()

@property (nonatomic, strong) UIImageView *backgroundView;

@property (nonatomic, strong) UIImageView *trackView;

@property (nonatomic, strong) NSMutableArray<UILabel *> *labelList;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation KTFixedTabView

- (instancetype)initWithItems:(NSArray<KTTabItem *> *)items innerMargin:(CGFloat)innerMargin
{
    // 计算文本内容
    CGFloat width = 0.0f;
    for (KTTabItem *item in items) {
        width += [item.title widthForFont:item.font];
    }
    width += innerMargin * items.count;
    
    if (self = [self initWithFrame:CGRectMake(0, 0, width, 0)]) {
        self.items = items;
    }
    
    return self;
}

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
    [self addSubview:self.backgroundView];
    [self addSubview:self.trackView];
    
    [self addGestureRecognizer:self.tapGestureRecognizer];
    
    self.trackHeight = 1.0;
    
    self.trackAnimated = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundView.frame = self.bounds;
    [self layoutTabItems];
}

- (void)layoutTabItems
{
    if (self.labelList.count == 0) { return; };
    CGFloat width = self.width / self.labelList.count;
    CGFloat height = self.height;
    CGFloat offsetX = 0.0f;
    for (NSInteger index = 0; index < self.labelList.count; index++) {
        UILabel *label = self.labelList[index];
        if (_selectedIndex == index) {
            KTTabItem *currentItem = [self.items objectAtIndex:_selectedIndex];
            label.textColor = currentItem.selectedTitleColor;
        }
        label.frame = CGRectMake(offsetX, 0, width, height);
        offsetX += width;
    }
    
    // trackView frame
    self.trackView.frame = CGRectMake(_selectedIndex * width, self.height - self.trackHeight, width, self.trackHeight);
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    [self reloadData];
}

#pragma mark - Gesture
- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer
{
    if (self.items.count == 0) { return; }
    CGPoint location = [recognizer locationInView:self];
    
    // Gesture点击事件会在超出frame的范围之内接受事件
    if (!CGRectContainsPoint(recognizer.view.bounds, location)) {
        return;
    }
    CGFloat width = self.width / self.items.count;
    
    NSInteger index = location.x / width;
    if (index != _selectedIndex) {
        [self changeTabItem:index];
        if (self.delegate && [self.delegate respondsToSelector:@selector(kt_fixedTabView:didSelectedAtIndex:)]) {
            [self.delegate kt_fixedTabView:self didSelectedAtIndex:index];
        }
    }
}


#pragma mark - Public Methods
- (void)changeTabItem:(NSInteger)index
{
    if (_selectedIndex == index) { return; }
    // 恢复当前的Label状态
    if (_selectedIndex >= 0 && _selectedIndex < self.items.count) {
        UILabel *currentLabel = [self.labelList objectAtIndex:_selectedIndex];
        KTTabItem *currentItem = [self.items objectAtIndex:_selectedIndex];
        currentLabel.textColor = currentItem.titleColor;
        
        // 更新即将展现的Label状态
        UILabel *toLabel = [self.labelList objectAtIndex:index];
        KTTabItem *toItem = [self.items objectAtIndex:index];
        toLabel.textColor = toItem.selectedTitleColor;
        
        if (self.trackAnimated) {
            self.tapGestureRecognizer.enabled = NO;
            [UIView animateWithDuration:kKTAnimateDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.trackView.originX = self.width / self.items.count * index;
            } completion:^(BOOL finished) {
                self.tapGestureRecognizer.enabled = YES;
            }];
        }
        else {
            self.trackView.originX = self.width / self.items.count * index;
        }
        
        _selectedIndex = index;
    }
}

- (void)reloadData
{
    [self changeTabItem:_selectedIndex];
}

#pragma mark - Private Methods
- (void)createItemViews
{
    [self removeAllLabels];
    if (self.items.count == 0) { return; }
    _selectedIndex = 0;
    CGFloat width = self.width / self.items.count;
    CGFloat height = self.height;
    for (NSInteger index = 0; index < self.items.count; index++) {
        KTTabItem *item = [self.items objectAtIndex:index];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        label.text = item.title;
        label.backgroundColor = self.backgroundColor;
        label.textColor = item.titleColor;
        label.highlightedTextColor = item.selectedTitleColor;
        label.textAlignment = NSTextAlignmentCenter;
        if (item.font) {
            label.font = item.font;
        }
        else {
            label.font = [UIFont systemFontOfSize:15.0];
        }
        
        [self.labelList addObject:label];
        [self addSubview:label];
    }
    [self setNeedsLayout];
}

- (void)removeAllLabels
{
    if (self.labelList.count > 0) {
        for (UILabel *label in self.labelList) {
            [label removeFromSuperview];
        }
        
        [self.labelList removeAllObjects];
    }
}

#pragma mark - Getters and Setters

- (NSMutableArray<UILabel *> *)labelList
{
    if (!_labelList) {
        _labelList = [[NSMutableArray<UILabel *> alloc] init];
    }
    
    return _labelList;
}

- (UIImageView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] init];
    }
    return _backgroundView;
}

- (UIImageView *)trackView
{
    if (!_trackView) {
        _trackView = [[UIImageView alloc] init];
    }
    return _trackView;
}

- (void)setTrackHeight:(CGFloat)trackHeight
{
    _trackHeight = trackHeight;
    [self setNeedsLayout];
}

- (void)setItems:(NSArray<KTTabItem *> *)items
{
    if (_items != items) {
        _items = items;
        [self createItemViews];
    }
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    self.backgroundView.image = backgroundImage;
}

- (void)setTrackColor:(UIColor *)trackColor
{
    self.trackView.backgroundColor = trackColor;
}

- (UITapGestureRecognizer *)tapGestureRecognizer
{
    if (!_tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    }
    
    return _tapGestureRecognizer;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex != selectedIndex) {
        [self changeTabItem:selectedIndex];
    }
}

@end
