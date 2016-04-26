//
//  HZWLimitCharactersTextView.h
//  HZWUIKit
//
//  Created by ZhangMing on 4/13/16.
//  Copyright © 2016 ZhangMing. All rights reserved.
//

#import "KTPlaceholderTextView.h"

@class KTLimitCharactersTextView;

@protocol KTLimitCharactersTextViewDelegate <UITextViewDelegate>

- (void)textDidChanged:(KTLimitCharactersTextView *)textView;

@end


@interface KTLimitCharactersTextView : KTPlaceholderTextView

/**
 *  最大允许数据的字符长度
 */
@property (nonatomic, assign) NSInteger limitedCharactersCount;

@property (nonatomic, weak) id<KTLimitCharactersTextViewDelegate> limitDelegate;

@end
