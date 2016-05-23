//
//  ECLoginViewController.m
//  EasyChat
//
//  Created by wanghu on 16/5/21.
//  Copyright © 2016年 wanghu. All rights reserved.
//

#import "ECLoginViewController.h"
#import "ECTabBarController.h"
#import "EMSDK.h"

@interface ECLoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewConstraintCenterY;

@end

@implementation ECLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"EasyChat";

}


// 登录账号
- (IBAction)login:(id)sender {
    EMError *error = [[EMClient sharedClient] loginWithUsername:self.accountField.text password:self.pwdField.text];
    if (!error) {
        [[EMClient sharedClient].options setIsAutoLogin:YES];
        [UIApplication sharedApplication].keyWindow.rootViewController = [[ECTabBarController alloc] init];
    } else {
        [SVProgressHUD showErrorWithStatus:@"登录失败"];
    }
}

// 注册账号
- (IBAction)registerID:(id)sender {
    NSString *account = self.accountField.text;
    NSString *pwd = self.pwdField.text;
    EMError *error = [[EMClient sharedClient] registerWithUsername:account password:pwd];
    if (error) {
        NSLog(@"注册失败%@", error.description);
        [SVProgressHUD showErrorWithStatus:@"注册失败"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"注册成功"];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    NSLog(@"%s", __func__);
    if (textField == self.accountField) {
        [textField resignFirstResponder];
        [self.pwdField becomeFirstResponder];
    } else{
        [self login:nil];
    }
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
