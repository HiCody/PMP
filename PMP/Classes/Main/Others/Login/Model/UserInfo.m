//
//  UserInfo.m
//  PMP
//
//  Created by mac on 15/12/14.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "UserInfo.h"
static id shareUserInfo;
@implementation UserInfo

+ (instancetype)shareUserInfo
{
    
    if (shareUserInfo == nil) {
        shareUserInfo = [[UserInfo alloc] init];
    }
    
    return shareUserInfo;
}


+ (NSDictionary *)objectClassInArray{
    return @{@"belongCompanyListList" : [Belongcompanylistlist class]};
}
@end

@implementation Belongcompanylistlist

@end


