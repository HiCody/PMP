//
//  SMIssureAnalysisModel.m
//  PMP
//
//  Created by mac on 15/12/8.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMIssureAnalysisModel.h"

@implementation SMIssureAnalysisModel


+ (NSDictionary *)objectClassInArray{
    return @{@"recheckProblemList" : [SMARecheckproblemlist class], @"checkInfoProblemClassList" : [SMACheckinfoproblemclasslist class]};
}

@end



@implementation SMARecheckproblemlist

+ (NSDictionary *)objectClassInArray{
    return @{@"recheckInfoList" : [SMARecheckinfolist class]};
}

@end


@implementation SMARecheckinfolist

@end


@implementation SMACheckinfoproblemclasslist

+ (NSDictionary *)objectClassInArray{
    return @{@"checkInfoDetailList" : [SMACheckinfodetaillist class]};
}

@end


@implementation SMACheckinfodetaillist

@end


