//
//  KTTabItem.h
//  KTUIKit
//
//  Created by ZhangMing on 4/26/16.
//  Copyright © 2016 ZhangMing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KTTabItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *selectedTitleColor;

@end
