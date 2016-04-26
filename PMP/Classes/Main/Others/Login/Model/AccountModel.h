//
//  AccountModel.h
//  PMP
//
//  Created by mac on 15/12/9.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#define K_UserName     @"userName"
#define K_PassWord     @"passWord"

@interface AccountModel : NSObject
@property (nonatomic, copy) NSString *userName;//用户名
@property (nonatomic, copy) NSString *passWord;//密码

@property (nonatomic,copy)NSString *credential;

@property (nonatomic,copy)NSString *token;

+ (instancetype)shareAccount;

- (void)loadAccountFromSanbox;

- (void)saveAccountToSanbox;
@end
