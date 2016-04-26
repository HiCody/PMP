//
//  DCSMSafetyCheckModel.h
//  PMP
//
//  Created by mac on 16/1/12.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BCSMCompanycheckbaseinfohistory;
@interface BCSMSafetyCheckModel : NSObject

@property (nonatomic, strong) BCSMCompanycheckbaseinfohistory *companyCheckBaseInfoHistory;

@property (nonatomic, assign) NSInteger companyId;

@property (nonatomic, copy) NSString *companyName;

@property (nonatomic, assign) NSInteger pCompanyId;


@end


@interface BCSMCompanycheckbaseinfohistory : NSObject

@property (nonatomic, assign) NSInteger landDown;

@property (nonatomic, copy) NSString *checkManName;

@property (nonatomic, copy) NSString *manageManTel;

@property (nonatomic, copy) NSString *checkDate;

@property (nonatomic, assign) NSInteger costOfConstruction;

@property (nonatomic, copy) NSString *safetyManTel;

@property (nonatomic, assign) NSInteger buildPersons;

@property (nonatomic, copy) NSString *qualityManTel;

@property (nonatomic, assign) NSInteger buildAreaSize;

@property (nonatomic, copy) NSString *technologyManName;

@property (nonatomic, assign) NSInteger companyId;

@property (nonatomic, assign) NSInteger strutClass;

@property (nonatomic, copy) NSString *endDate;

@property (nonatomic, copy) NSString *qualityManName;

@property (nonatomic, copy) NSString *safetyManName;

@property (nonatomic, copy) NSString *deptName;

@property (nonatomic, copy) NSString *strutClassName;

@property (nonatomic, assign) NSInteger landUp;

@property (nonatomic, copy) NSString *manageManName;

@property (nonatomic, copy) NSString *beginDate;

@property (nonatomic, assign) NSInteger historyId;

@property (nonatomic, copy) NSString *technologyManTel;

@end

