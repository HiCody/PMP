//
//  BCSMSafetyCheckDetailModel.m
//  PMP
//
//  Created by mac on 16/1/14.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "BCSMSafetyCheckDetailModel.h"

@implementation BCSMSafetyCheckDetailModel


+ (NSDictionary *)objectClassInArray{
    return @{@"companyCheckImages" : [BCSMCompanycheckimages class], @"companyCheckDetails" : [BCSMCompanycheckdetails class], @"spotInfos" : [BCSMSpotinfos class]};
}

@end

@implementation BCSMCompanycheckdetails

@end

@implementation BCSMCompanycheckimages

@end

@implementation BCSMSpotinfos

@end


