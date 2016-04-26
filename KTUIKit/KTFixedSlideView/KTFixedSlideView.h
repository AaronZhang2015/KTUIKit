//
//  KTFixedSlideView.h
//  KTUIKit
//
//  Created by ZhangMing on 4/26/16.
//  Copyright © 2016 ZhangMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KTFixedSlideViewDataSource <NSObject>


@end

@protocol KTFixedSlideViewDelegate <NSObject>


@end

@interface KTFixedSlideView : UIView

@property (nonatomic, weak) id<KTFixedSlideViewDelegate> delegate;

@property (nonatomic, weak) id<KTFixedSlideViewDataSource> dataSource;

@end
