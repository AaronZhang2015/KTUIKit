//
//  UIColor+KTKit.h
//  KTCategories
//
//  Created by ZhangMing on 4/25/16.
//  Copyright © 2016 ZhangMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (KTKit)


+ (instancetype)colorWithHexString:(NSString *)hexStr;

/**
 *  叠加色
 *
 *  @param toColor 目标颜色
 *  @param percent 当前渐变百分比
 *
 *  @return 叠加色
 */
- (UIColor *)mixColorWithDestinationColor:(UIColor *)toColor percent:(CGFloat)percent;

@end
