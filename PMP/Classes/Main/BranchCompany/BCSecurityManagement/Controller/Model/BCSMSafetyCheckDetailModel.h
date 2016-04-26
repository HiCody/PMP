//
//  BCSMSafetyCheckDetailModel.h
//  PMP
//
//  Created by mac on 16/1/14.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMSafetyContent.h"
@class BCSMCompanycheckimages,BCSMCompanycheckdetails,BCSMSpotinfos;
@interface BCSMSafetyCheckDetailModel : NSObject

@property (nonatomic, copy) NSString *qualityManTel;

@property (nonatomic, copy) NSString *landDown;

@property (nonatomic, copy) NSString *checkEndDate;

@property (nonatomic, copy) NSString *checkDate;

@property (nonatomic, copy) NSString *deptName;

@property (nonatomic, copy) NSString *safetyManName;

@property (nonatomic, copy) NSString *manageManName;

@property (nonatomic, copy) NSString *technologyManName;

@property (nonatomic, copy)NSString *costOfConstruction;

@property (nonatomic, copy) NSString *progress;

@property (nonatomic, copy) NSString *manageManTel;

@property (nonatomic, assign) NSInteger isModify;

@property (nonatomic, copy) NSString *qualityManName;

@property (nonatomic, copy)NSString *buildAreaSize;

@property (nonatomic, copy) NSString *searchValue;

@property (nonatomic, copy) NSString *checkBeginDate;

@property (nonatomic, copy) NSString *safetyManTel;

@property (nonatomic, copy) NSString *strutClassName;

@property (nonatomic, assign) NSInteger companySubId;

@property (nonatomic, copy) NSString *improve;

@property (nonatomic, assign) NSInteger companyId;

@property (nonatomic, copy) NSString *checkManName;

@property (nonatomic, copy) NSString *technologyManTel;

@property (nonatomic, copy)NSString *buildPersons;

@property (nonatomic, strong) NSArray<BCSMSpotinfos *> *spotInfos;

@property (nonatomic, strong) NSArray<BCSMCompanycheckimages *> *companyCheckImages;

@property (nonatomic, strong) NSArray<BCSMCompanycheckdetails *> *companyCheckDetails;

@property (nonatomic, strong)NSArray *safetyContentArr;//添加安全检查

@property (nonatomic, strong)NSArray *checkImagesArr;//每组图片集合


@property (nonatomic, assign) NSInteger strutClass;

@property (nonatomic, assign) NSInteger historyCompanyId;

@property (nonatomic, copy)NSString *landUp;

@property (nonatomic, copy) NSString *beginDate;

@property (nonatomic, assign) NSInteger companyCheckId;

@property (nonatomic, copy) NSString *endDate;

@end

@interface BCSMCompanycheckimages : NSObject

@property (nonatomic, assign) NSInteger classType;

@property (nonatomic, copy) NSString *positionName;

@property (nonatomic, copy) NSString *imagePath;

@property (nonatomic, assign) NSInteger companyCheckId;

@property (nonatomic, copy) NSString *thumbnailPath;

@property (nonatomic, assign) NSInteger checkPosId;

@property (nonatomic, assign) NSInteger imageId;

@property (nonatomic,strong)NSString *problemDesc;

@end

@interface BCSMCompanycheckdetails : NSObject

@property (nonatomic, copy) NSString *checkProblemName;

@property (nonatomic, assign) NSInteger detailId;

@property (nonatomic, copy) NSString *checkProblemId;

@property (nonatomic, assign) NSInteger classType;

@property (nonatomic, copy) NSString *checkItemName;

@property (nonatomic, copy) NSString *checkContentId;

@property (nonatomic, assign) NSInteger companyCheckId;

@property (nonatomic, copy) NSString *problemDesc;

@property (nonatomic, copy) NSString *checkItemId;

@property (nonatomic, copy) NSString *checkContentName;

@end

@interface BCSMSpotinfos : NSObject

@property (nonatomic, assign) NSInteger companyCheckId;

@property (nonatomic, assign) NSInteger order;

@property (nonatomic, assign) NSInteger spotInfoId;

@property (nonatomic, assign) NSInteger spotId;

@property (nonatomic, copy) NSString *spotName;

@end

