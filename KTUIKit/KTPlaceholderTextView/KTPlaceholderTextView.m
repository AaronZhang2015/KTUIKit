//
//  KTPlaceholderTextView.m
//  KTUIKit
//
//  Created by ZhangMing on 4/26/16.
//  Copyright © 2016 ZhangMing. All rights reserved.
//

#import "KTPlaceholderTextView.h"

@interface KTPlaceholderTextView()<UITextViewDelegate>{
    UIColor *_placeholderColor;
}

@property (nonatomic, strong, nonnull) UILabel *placeholderLabel;
@property (nonatomic, strong, nullable) NSMutableArray<NSLayoutConstraint *> *placeholderLabelConstraints;

@end

@implementation KTPlaceholderTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commitInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        [self commitInit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.placeholderLabel.preferredMaxLayoutWidth = self.textContainer.size.width - self.textContainer.lineFragmentPadding * 2;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - private methods
- (void)commitInit {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChanged)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
    // workaround, because self.font is nil
    // see http://stackoverflow.com/questions/19049917/uitextview-font-is-being-reset-after-settext
    if (self.font == nil) {
        self.font = [UIFont systemFontOfSize:14];
    }
    self.placeholderLabel.font = self.font;
    self.placeholderLabel.textColor = self.placeholderColor;
    self.placeholderLabel.textAlignment = self.textAlignment;
    self.placeholderLabel.text = self.text;
    self.placeholderLabel.numberOfLines = 0;
    self.placeholderLabel.backgroundColor = [UIColor clearColor];
    self.placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.placeholderLabel];
    [self updateConstraintsForPlaceholderLabel];
}

- (void)textDidChanged {
    self.placeholderLabel.hidden = self.text.length > 0;
}

- (void)updateConstraintsForPlaceholderLabel {
    NSString *format = [NSString stringWithFormat:@"H:|-%f-[placeholder]", self.textContainerInset.left + self.textContainer.lineFragmentPadding];
    NSMutableArray<NSLayoutConstraint *> *newConstraints = [[NSMutableArray alloc] initWithArray:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:@{@"placeholder": self.placeholderLabel}] copyItems:NO];
    format = [NSString stringWithFormat:@"V:|-%f-[placeholder]", self.textContainerInset.top];
    [newConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:@{@"placeholder": self.placeholderLabel}]];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.placeholderLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-(self.textContainerInset.left + self.textContainerInset.right + self.textContainer.lineFragmentPadding * 2)];
    [newConstraints addObject:constraint];
    
    [self removeConstraints:self.placeholderLabelConstraints];
    [self addConstraints:newConstraints];
    self.placeholderLabelConstraints = newConstraints;
}

#pragma mark - getters and setters

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
    }
    return _placeholderLabel;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderLabel.text = _placeholder;
}

- (UIColor *)placeholderColor {
    if (!_placeholderColor) {
        _placeholderColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0980392 alpha:0.22];
    }
    
    return _placeholderColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.placeholderLabel.font = font;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    self.placeholderLabel.textAlignment = textAlignment;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textDidChanged];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self textDidChanged];
}

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset {
    [super setTextContainerInset:textContainerInset];
    [self updateConstraintsForPlaceholderLabel];
}


@end
