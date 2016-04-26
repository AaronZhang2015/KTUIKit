//
//  UIView+KTKit.h
//  KTCategories
//
//  Created by ZhangMing on 4/25/16.
//  Copyright © 2016 ZhangMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (KTKit)

@property (nonatomic, assign) UIEdgeInsets touchExtendInset;

- (void)stayIntrinsicSize;

- (void)stayIntrinsicWidth;

- (void)stayIntrinsicHeight;

- (CGSize)compressedSize;

- (UIImage *)snapshotImage;

- (void)removeAllSubviews;

- (UIViewController *)viewController;


@end
