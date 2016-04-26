//
//  NSString+KTKit.m
//  KTCategories
//
//  Created by ZhangMing on 4/25/16.
//  Copyright © 2016 ZhangMing. All rights reserved.
//

#import "NSString+KTKit.h"

@implementation NSString (KTKit)

- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode
{
    CGSize result;
    if (!font) {
        NSAssert(NO, @"font cannot be nil");
    }
    
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attributes = [@{} mutableCopy];
        attributes[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
            paragrahStyle.lineBreakMode = lineBreakMode;
            attributes[NSParagraphStyleAttributeName] = paragrahStyle;
        }
        result = [self boundingRectWithSize:size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    
    return result;
}

- (CGFloat)widthForFont:(UIFont *)font
{
    return [self sizeForFont:font size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping].width;
}

- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width
{
    return [self sizeForFont:font size:CGSizeMake(width, HUGE) mode:NSLineBreakByWordWrapping].width;
}

- (NSString *)stringByTrim
{
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

- (NSData *)dataValue
{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSInteger)countOfBytes
{
    NSInteger strlength = 0;
    
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    NSInteger count = [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding];
    for (NSInteger index = 0; index < count; index++)
    {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

@end
