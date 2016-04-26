//
//  HZWLimitCharactersTextView.m
//  HZWUIKit
//
//  Created by ZhangMing on 4/13/16.
//  Copyright © 2016 ZhangMing. All rights reserved.
//

#import "KTLimitCharactersTextView.h"
#import "NSString+KTKit.h"

@interface KTLimitCharactersTextView ()<UITextViewDelegate>

@end

@implementation KTLimitCharactersTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL aSelector = [anInvocation selector];
    if ([self.limitDelegate respondsToSelector:aSelector]) {
        [anInvocation invokeWithTarget:self.limitDelegate];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *limitSignature = [(NSObject *)self.limitDelegate methodSignatureForSelector:aSelector];
    if (limitSignature) {
        return limitSignature;
    }
    
    return [super methodSignatureForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([super respondsToSelector:aSelector]) {
        return YES;
    }
    
    BOOL result = [self.limitDelegate respondsToSelector:aSelector];
    return result;
}


#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    if (selectedRange && position) {
        return YES;
    }
    
    if (self.limitedCharactersCount == 0) {
        return YES;
    }
    
    NSString *concatString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger canInputLen = self.limitedCharactersCount - concatString.length;
    if (canInputLen >= 0) {
        return YES;
    }
    else {
        NSInteger len = text.length + canInputLen;
        NSRange canInputRange = {0, MAX(len, 0)};
        if (canInputRange.length > 0) {
            NSString *trimString = @"";
            BOOL isAscii = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (isAscii) {
                trimString = [text substringWithRange:canInputRange];
            }
            else {
                __block NSInteger idx = 0;
                __block NSString *tempSring = @"";
                [text enumerateSubstringsInRange:NSMakeRange(0, text.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
                    NSInteger stepLen = substring.length;
                    
                    if (idx > canInputRange.length) {
                        *stop = YES;
                        return;
                    }
                    
                    tempSring = [tempSring stringByAppendingString:substring];
                    idx += stepLen;
                }];
                
                trimString = tempSring;
            }
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:trimString]];
            if (self.limitDelegate && [self.limitDelegate respondsToSelector:@selector(textDidChanged:)]) {
                [self.limitDelegate textDidChanged:self];
            }
        }
        
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && position) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (self.limitedCharactersCount > 0) {
        if (existTextNum > self.limitedCharactersCount){
            //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
            NSString *str = [nsTextContent substringToIndex:self.limitedCharactersCount];
            [textView setText:str];
        }
    }
    
    if (self.limitDelegate && [self.limitDelegate respondsToSelector:@selector(textDidChanged:)]) {
        [self.limitDelegate textDidChanged:self];
    }
}

@end
