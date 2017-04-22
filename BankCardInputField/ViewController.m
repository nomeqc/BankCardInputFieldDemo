//
//  ViewController.m
//  BankCardInputField
//
//  Created by iOSDeveloper003 on 17/4/22.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "ViewController.h"
#import "WLCardNoFormatter.h"

@interface ViewController ()
<UITextFieldDelegate>

@property (strong, nonatomic) UITextField *bankCardNoField;

@property (strong, nonatomic) WLCardNoFormatter *cardNoFormatter;

@end

@implementation ViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"银行卡号输入Demo";
    
    UITextField *textField = [[UITextField alloc] init];
    textField.delegate = self;
    textField.frame = CGRectMake(0, 0, 200, 40);
    textField.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame) - 80);
    textField.layer.cornerRadius = 2;
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.layer.borderWidth = 1/[UIScreen mainScreen].scale;
    [self.view addSubview:textField];
    self.bankCardNoField = textField;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.bankCardNoField) {
        [self.cardNoFormatter bankNoField:textField shouldChangeCharactersInRange:range replacementString:string];
        return NO;
    }
    return YES;
}


- (WLCardNoFormatter *)cardNoFormatter {
	if(_cardNoFormatter == nil) {
		_cardNoFormatter = [[WLCardNoFormatter alloc] init];
	}
	return _cardNoFormatter;
}

@end
