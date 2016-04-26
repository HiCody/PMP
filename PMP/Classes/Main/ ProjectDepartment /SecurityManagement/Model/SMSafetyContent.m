//
//  SMSafetyContent.m
//  PMP
//
//  Created by mac on 15/12/2.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMSafetyContent.h"

@implementation SMSafetyContent

+ (NSDictionary *)objectClassInArray{
    return @{@"sections" : [SMSafetyContentSecondDetail class]};
}

@end

@implementation SMSafetyContentSecondDetail

+ (NSDictionary *)objectClassInArray{
    return @{@"sections" : [SMSafetyContentThirdDetail class]};
}

@end


@implementation SMSafetyContentThirdDetail

@end




