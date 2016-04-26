//
//  AccountModel.m
//  PMP
//
//  Created by mac on 15/12/9.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "AccountModel.h"
static id shareAccount;
@implementation AccountModel
+ (instancetype)shareAccount
{
    if (shareAccount == nil) {
        shareAccount = [[AccountModel alloc] init];
    }
    
    return shareAccount;
}

- (void)saveAccountToSanbox{
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    [userdefault setObject:self.userName forKey:K_UserName];
    [userdefault setObject:self.passWord forKey:K_PassWord];

    [userdefault synchronize];
}


- (void)loadAccountFromSanbox{
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    
    self.userName = [userdefault objectForKey:K_UserName];
    
    self.passWord = [userdefault objectForKey:K_PassWord];
    
}

@end
