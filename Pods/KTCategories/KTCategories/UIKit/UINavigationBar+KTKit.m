//
//  UINavigationBar+KTKit.m
//  KTCategories
//
//  Created by ZhangMing on 4/25/16.
//  Copyright © 2016 ZhangMing. All rights reserved.
//

#import "UINavigationBar+KTKit.h"

@implementation UINavigationBar (KTKit)

- (void)hideBottomHairline
{
    UIImageView *bottomHairlineView = [self hairlineImageViewInNavigationBar:self];
    bottomHairlineView.hidden = YES;
}

- (void)showBottomHariline
{
    UIImageView *bottomHairlineView = [self hairlineImageViewInNavigationBar:self];
    bottomHairlineView.hidden = NO;
}

- (UIImageView *)hairlineImageViewInNavigationBar:(UIView *)view
{
    if (view && [view isKindOfClass:[UIImageView class]] && (view).bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    
    NSArray *subviews = view.subviews;
    
    for (id view in subviews) {
        UIImageView *iv = [self hairlineImageViewInNavigationBar:view];
        if (iv) {
            return iv;
        }
    }
    
    return nil;
}

@end
