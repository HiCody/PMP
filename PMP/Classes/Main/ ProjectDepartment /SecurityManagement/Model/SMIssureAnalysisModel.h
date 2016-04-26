//
//  SMIssureAnalysisModel.h
//  PMP
//
//  Created by mac on 15/12/8.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SMARecheckproblemlist,SMARecheckinfolist,SMACheckinfoproblemclasslist,SMACheckinfodetaillist;
@interface SMIssureAnalysisModel : NSObject

@property(nonatomic,strong)NSString *positionName;//检查部位名称

@property (nonatomic, assign) NSInteger checkTypeId;

@property (nonatomic, strong) NSArray<SMARecheckproblemlist *> *recheckProblemList;

@property (nonatomic, assign) NSInteger checkUserId;

@property (nonatomic, copy) NSString *checkDate;

@property (nonatomic, copy) NSString *checkUserName;

@property (nonatomic, assign) NSInteger checkId;

@property (nonatomic, assign) NSInteger hasProblem;

@property (nonatomic, assign) NSInteger state;

@property (nonatomic,strong) NSString *solveUserName;

@property (nonatomic,strong) NSString *solveUserId;

@property (nonatomic, strong) NSArray<SMACheckinfoproblemclasslist *> *checkInfoProblemClassList;

@end
@interface SMARecheckproblemlist : NSObject

@property (nonatomic, assign) NSInteger state;

@property (nonatomic, assign) NSInteger reCheckId;

@property (nonatomic, copy) NSString *reCheckDate;

@property (nonatomic, assign) NSInteger checkId;

@property (nonatomic, strong) NSArray<SMARecheckinfolist *> *recheckInfoList;

@property (nonatomic, assign) NSInteger reCheckUserId;

@property (nonatomic, copy) NSString *reCheckUserName;

@end

@interface SMARecheckinfolist : NSObject

@property (nonatomic, assign) NSInteger classType;

@property (nonatomic, copy) NSString *imagePath;

@property (nonatomic,copy) NSString *thumbnailPath;

@end

@interface SMACheckinfoproblemclasslist : NSObject

@property (nonatomic, assign) NSInteger classType;

@property (nonatomic, strong) NSArray<SMACheckinfodetaillist *> *checkInfoDetailList;

@property (nonatomic, copy) NSString *imagePath;

@property (nonatomic,copy) NSString *thumbnailPath;

@end

@interface SMACheckinfodetaillist : NSObject

@property (nonatomic, copy) NSString *checkProblemId;

@property (nonatomic, copy) NSString *checkItemName;

@property (nonatomic, strong) NSString *checkId;

@property (nonatomic, copy) NSString *checkContentId;

@property (nonatomic, copy) NSString *checkContentName;

@property (nonatomic, copy) NSString *checkProblemName;

@property (nonatomic, copy) NSString *checkItemId;

@property (nonatomic, copy)NSString *problemDesc;
@end

