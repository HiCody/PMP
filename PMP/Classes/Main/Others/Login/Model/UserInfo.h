//
//  UserInfo.h
//  PMP
//
//  Created by mac on 15/12/14.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Belongcompanylistlist;
@interface UserInfo : NSObject

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, assign) NSInteger deptId;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *realName;

@property (nonatomic, copy) NSString *deptName;

@property (nonatomic, strong) NSArray<Belongcompanylistlist *> *belongCompanyListList;

@property (nonatomic, copy) NSString *telPhone;

@property (nonatomic, copy) NSString *companyName;

@property (nonatomic, copy) NSString *passWord;

@property (nonatomic, copy) NSString *right;

@property (nonatomic, assign) NSInteger companyId;

+ (instancetype)shareUserInfo;

@end


@interface Belongcompanylistlist : NSObject

@property (nonatomic, assign) NSInteger companyId;

@property (nonatomic, copy) NSString *companyName;

@property (nonatomic,copy) NSString *type;
@end

