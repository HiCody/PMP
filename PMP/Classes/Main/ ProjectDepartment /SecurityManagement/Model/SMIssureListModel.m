//
//  SMIssureListModel.m
//  PMP
//
//  Created by mac on 15/12/3.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMIssureListModel.h"

@implementation SMIssureListModel


+ (NSDictionary *)objectClassInArray{
    return @{@"totalArr" : [SMAllInfoModel class]};
}

@end



@implementation SMAllInfoModel

+ (NSDictionary *)objectClassInArray{
    return @{@"checkInfoProblemClassList" : [SMCheckinfoproblemclasslist class]};
}

@end


@implementation SMCheckinfoproblemclasslist

+ (NSDictionary *)objectClassInArray{
    return @{@"checkInfoDetailList" : [SMCheckinfodetaillist class]};
}

@end


@implementation SMCheckinfodetaillist

@end


