//
//  SMIssureDetailModel.m
//  PMP
//
//  Created by mac on 15/12/3.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMIssureDetailModel.h"

@implementation SMIssureDetailModel


+ (NSDictionary *)objectClassInArray{
    return @{@"recheckProblemList" : [Recheckproblemlist class], @"checkInfoProblemClassList" : [Checkinfoproblemclasslist class]};
}
@end
@implementation Recheckproblemlist

+ (NSDictionary *)objectClassInArray{
    return @{@"recheckInfoList" : [Recheckinfolist class]};
}

@end


@implementation Recheckinfolist

@end


@implementation Checkinfoproblemclasslist

+ (NSDictionary *)objectClassInArray{
    return @{@"checkInfoDetailList" : [Checkinfodetaillist class],
             @"safetyContentArr" : [SMSafetyContent class]};
}

@end


@implementation Checkinfodetaillist

@end


