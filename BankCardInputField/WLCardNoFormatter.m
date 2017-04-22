//
//  WLCardNoFormatter.m
//  BankCardInputField
//
//  Created by iOSDeveloper003 on 17/4/22.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "WLCardNoFormatter.h"

@interface UITextField (WLRange)

- (NSRange)selectedRange;

- (void)setSelectedRange:(NSRange)range;

@end

@implementation UITextField (WLRange)

- (NSRange)selectedRange {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextRange *selectedRange = self.selectedTextRange;
    UITextPosition *selectionStart = selectedRange.start;
    UITextPosition *selectionEnd = selectedRange.end;
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    return NSMakeRange(location, length);
}
- (void)setSelectedRange:(NSRange)range {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectionRange];
}

@end

//---------------------O(∩_∩)O---------------------------

@implementation WLCardNoFormatter

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _groupSize = 4;
    _separator = @" ";
    return self;
}

- (void)bankNoField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger groupSize = self.groupSize;
    NSString *text = textField.text;
    NSString *beingString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *cardNo = [self removingSapceString:beingString];
    //校验卡号只能是数字，且不能超过20位
    if ( (string.length != 0 && ![self isValidNumbers:cardNo]) || cardNo.length > 20) {
        return;
    }
    //获取【光标右侧的数字个数】
    NSInteger rightNumberCount = [self removingSapceString:[text substringFromIndex:textField.selectedRange.location + textField.selectedRange.length]].length;
    //输入长度大于4 需要对数字进行分组，每4个一组，用空格隔开
    if (beingString.length > groupSize) {
        textField.text = [self groupedString:beingString];
    } else {
        textField.text = beingString;
    }
    text = textField.text;
    /**
     * 计算光标位置(相对末尾)
     * 光标右侧空格数 = 所有的空格数 - 光标左侧的空格数
     * 光标位置 = 【光标右侧的数字个数】+ 光标右侧空格数
     */
    NSInteger rightOffset = [self rightOffsetWithCardNoLength:cardNo.length rightNumberCount:rightNumberCount];
    NSRange currentSelectedRange = NSMakeRange(text.length - rightOffset, 0);
    
    //如果光标左侧是一个空格，则光标回退一格
    if (currentSelectedRange.location > 0 && [[text substringWithRange:NSMakeRange(currentSelectedRange.location - 1, 1)] isEqualToString:self.separator]) {
        currentSelectedRange.location -= 1;
    }
    [textField setSelectedRange:currentSelectedRange];
}

#pragma mark - Helper
/**
 *  计算光标相对末尾的位置偏移
 *
 *  @param length           卡号的长度(不包括空格)
 *  @param rightNumberCount 光标右侧的数字个数
 *
 *  @return 光标相对末尾的位置偏移
 */
- (NSInteger)rightOffsetWithCardNoLength:(NSInteger)length rightNumberCount:(NSInteger)rightNumberCount {
    NSInteger totalGroupCount = [self groupCountWithLength:length];
    NSInteger leftGroupCount = [self groupCountWithLength:length - rightNumberCount];
    NSInteger totalWhiteSpace = totalGroupCount -1 > 0? totalGroupCount - 1 : 0;
    NSInteger leftWhiteSpace = leftGroupCount -1 > 0? leftGroupCount - 1 : 0;
    return rightNumberCount + (totalWhiteSpace - leftWhiteSpace);
}

/**
 *  校验给定字符串是否是纯数字
 *
 *  @param numberStr 字符串
 *
 *  @return 字符串是否是纯数字
 */
- (BOOL)isValidNumbers:(NSString *)numberStr {
    NSString* numberRegex = @"^[0-9]+$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numberRegex];
    return [numberPre evaluateWithObject:numberStr];
}

/**
 *  去除字符串中包含的空格
 *
 *  @param str 字符串
 *
 *  @return 去除空格后的字符串
 */
- (NSString *)removingSapceString:(NSString *)str {
    return [str stringByReplacingOccurrencesOfString:self.separator withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, str.length)];
}

/**
 *  根据长度计算分组的个数
 *
 *  @param length 长度
 *
 *  @return 分组的个数
 */
- (NSInteger)groupCountWithLength:(NSInteger)length {
    return (NSInteger)ceilf((CGFloat)length /self.groupSize);
}

/**
 *  给定字符串根据指定的个数进行分组，每一组用空格分隔
 *
 *  @param string 字符串
 *
 *  @return 分组后的字符串
 */
- (NSString *)groupedString:(NSString *)string {
    NSString *str = [self removingSapceString:string];
    NSInteger groupCount = [self groupCountWithLength:str.length];
    NSInteger groupSize = self.groupSize;
    NSMutableArray *components = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < groupCount; i++) {
        if (i*groupSize + groupSize > str.length) {
            [components addObject:[str substringFromIndex:i*groupSize]];
        } else {
            [components addObject:[str substringWithRange:NSMakeRange(i*groupSize, groupSize)]];
        }
    }
    NSString *groupedString = [components componentsJoinedByString:self.separator];
    return groupedString;
}

@end
