//
//  KTFixedTabView.h
//  KTUIKit
//
//  Created by ZhangMing on 4/26/16.
//  Copyright © 2016 ZhangMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTTabItem.h"

@class KTFixedTabView;

@protocol KTFixedTabViewDelegate <NSObject>

- (void)kt_fixedTabView:(KTFixedTabView *)tabView didSelectedAtIndex:(NSInteger)index;

@end

@interface KTFixedTabView : UIView

@property (nonatomic, weak) id<KTFixedTabViewDelegate> delegate;

@property (nonatomic, strong) NSArray<KTTabItem *> *items;

@property (nonatomic, strong) UIColor *trackColor;

@property (nonatomic, assign) CGFloat trackHeight;

@property (nonatomic, strong) UIImage *backgroundImage;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, assign) BOOL trackAnimated;

- (instancetype)initWithItems:(NSArray<KTTabItem *> *)items innerMargin:(CGFloat)innerMargin;

- (void)reloadData;

@end
