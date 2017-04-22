//
//  WLCardNoFormatter.h
//  BankCardInputField
//
//  Created by iOSDeveloper003 on 17/4/22.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WLCardNoFormatter : NSObject

/**
 *  默认为4，即4个数一组 用空格分隔
 */
@property (assign, nonatomic) NSInteger groupSize;

/**
 *  分隔符 默认为空格
 */
@property (copy, nonatomic) NSString *separator;

- (void)bankNoField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
