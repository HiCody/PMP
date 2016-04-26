//
//  LoginViewController.m
//  PMP
//
//  Created by mac on 15/11/30.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "LoginViewController.h"
#import "PMPHomeViewController.h"
#import "NetRequestClass.h"
#import "AccountModel.h"
@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *versionLable;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *accountImageView;
@property (weak, nonatomic) IBOutlet UIImageView *pwdImageView;
@property (weak, nonatomic) IBOutlet UITextField *accountTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *accountPanelView;
@property (weak, nonatomic) IBOutlet UIView *pwdPanelView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *str=  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.versionLable.text = [NSString stringWithFormat:@"V%@",str];
    
    //设置paneView的显示样式
    self.accountPanelView.layer.borderWidth=1.0;
    self.accountPanelView.layer.borderColor=[UIColor clearColor].CGColor;
    self.accountPanelView.layer.cornerRadius=4.0;
    
    self.pwdPanelView.layer.borderWidth=1.0;
    self.pwdPanelView.layer.borderColor=[UIColor clearColor].CGColor;
    self.pwdPanelView.layer.cornerRadius=4.0;
    
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"login_btn_high"] forState:UIControlStateHighlighted];
    self.loginButton.layer.borderWidth=1.0;
    self.loginButton.layer.borderColor=[UIColor whiteColor].CGColor;
    self.loginButton.layer.cornerRadius=4.0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self.accountTextfield addTarget:self  action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    
    AccountModel *account=[AccountModel shareAccount];
    [account loadAccountFromSanbox];
    if (account.userName) {
        NSString *user=account.userName;
        self.accountTextfield.text=user;
    }
    if (account.passWord) {
        NSString *passWord=account.passWord;
        self.passwordTextField.text=passWord;
    }
    


}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    CGFloat duration =[notification.userInfo [UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyBoardFrame =[notification.userInfo [UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat transfomY=(keyBoardFrame.origin.y-self.view.frame.size.height)/3;
    // NSLog(@"%f",transfomY);
    [UIView animateWithDuration:duration animations:^{
        self.view.transform=CGAffineTransformMakeTranslation(0, transfomY);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextFieldDelegate
- (void)textChange:(UITextField *)textField{
    
    
    //限制输入的字数长度
    if (textField == self.accountTextfield) {
        if (textField.text.length==0) {
            self.accountImageView.image=[UIImage imageNamed:@"login_account_nil"];
        }else{
            self.accountImageView.image=[UIImage imageNamed:@"login_account"];
        }
        
        if (textField.text.length > 15) {
            textField.text = [textField.text substringToIndex:15];
        }
    }
    
    if (textField == self.passwordTextField) {
        if (textField.text.length==0) {
            self.pwdImageView.image=[UIImage imageNamed:@"login_pwd_nil"];
        }else{
            self.pwdImageView.image=[UIImage imageNamed:@"login_pwd"];
        }
        if (textField.text.length > 15) {
            textField.text = [textField.text substringToIndex:15];
        }
    }
}


- (IBAction)logIn:(id)sender {
    //账号或密码为空是抖动
    if (!self.accountTextfield.text.length||!self.passwordTextField.text.length) {
        if (!self.accountTextfield.text.length) {
            [self shakeActionWithTextField:self.accountTextfield];
        }else{
            [self shakeActionWithTextField:self.passwordTextField];
        }
    }else{
        
       [self requestLoginWithName:self.accountTextfield.text pwd:self.passwordTextField.text];
       //[[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
        
    }
    
    [self.accountTextfield resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
}

- (void)shakeActionWithTextField:(UITextField *)textField
{
    // 晃动次数
    static int numberOfShakes = 4;
    // 晃动幅度（相对于总宽度）
    static float vigourOfShake = 0.01f;
    // 晃动延续时常（秒）
    static float durationOfShake = 0.5f;
    
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    // 方法一：绘制路径
    CGRect frame = textField.frame;
    // 创建路径
    CGMutablePathRef shakePath = CGPathCreateMutable();
    // 起始点
    CGPathMoveToPoint(shakePath, NULL, CGRectGetMidX(frame), CGRectGetMidY(frame));
    for (int index = 0; index < numberOfShakes; index++)
    {
        // 添加晃动路径 幅度由大变小
        CGPathAddLineToPoint(shakePath, NULL, CGRectGetMidX(frame) - frame.size.width * vigourOfShake*(1-(float)index/numberOfShakes),CGRectGetMidY(frame));
        CGPathAddLineToPoint(shakePath, NULL,  CGRectGetMidX(frame) + frame.size.width * vigourOfShake*(1-(float)index/numberOfShakes),CGRectGetMidY(frame));
    }
    // 闭合
    CGPathCloseSubpath(shakePath);
    shakeAnimation.path = shakePath;
    shakeAnimation.duration = durationOfShake;
    // 释放
    CFRelease(shakePath);
    
    [textField.layer addAnimation:shakeAnimation forKey:kCATransition];
}

- (void)requestLoginWithName:(NSString*)name pwd:(NSString*)pwd{
    NSDictionary *parameters= @{@"userName":name,
                                @"passWord":pwd
                                };
    AccountModel *account =[AccountModel shareAccount];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"2" forHTTPHeaderField:@"platform"];
    [manager.requestSerializer setValue:@"true" forHTTPHeaderField:@"mobile"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [MBProgressHUD showMessage:@"登录中..." toView:self.view];

    [manager POST:kLoginCheck parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSString *obj =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",obj);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

        account.credential =operation.response.allHeaderFields[@"credential"];
        account.token      =operation.response.allHeaderFields[@"token"];
        
        if ([dic[@"status"] intValue]!=200) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"登录失败" message:@"帐号或密码错误"delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }else{
            
            NSDictionary *dict= dic[@"items"];
            UserInfo *userInfo =[UserInfo shareUserInfo];
            userInfo.userId     =dict[@"userId"];
            userInfo.userName   =dict[@"userName"];
            userInfo.realName   =dict[@"realName"];
            userInfo.right      =dict[@"right"];
            NSString *companyId =dict[@"companyId"];
            userInfo.companyId  =companyId.integerValue;
            userInfo.companyName   =dict[@"companyName"];
            NSArray *companyListArr = [Belongcompanylistlist mj_objectArrayWithKeyValuesArray:dict[@"belongCompanyListList"]];
            userInfo.belongCompanyListList = companyListArr;
            
            if (![account.userName isEqualToString:name]) {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSArray *smArr=[[NSArray alloc] init];
                [userDefaults setObject:smArr forKey:kDraft];
                
            }
            
            account.userName=name;
            account.passWord=pwd;
            [account saveAccountToSanbox];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"登录失败" message:@"请检查网络设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
