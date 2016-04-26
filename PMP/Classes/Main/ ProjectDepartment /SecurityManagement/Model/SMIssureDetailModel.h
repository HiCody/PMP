//
//  SMIssureDetailModel.h
//  PMP
//
//  Created by mac on 15/12/3.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMSafetyContent.h"
@class Recheckproblemlist,Recheckinfolist,Checkinfoproblemclasslist,Checkinfodetaillist;
@interface SMIssureDetailModel : NSObject
@property(nonatomic,assign)NSInteger saveType;//保存类型1，2

@property(nonatomic,strong)NSString *positionName;//检查部位名称
@property(nonatomic,strong)NSString *checkPosId;//检查部位编号

@property(nonatomic,strong)NSString *solveRealName;

@property (nonatomic, assign) NSInteger checkTypeId;

@property (nonatomic, strong) NSMutableArray<Recheckproblemlist *> *recheckProblemList;

@property (nonatomic, assign) NSInteger checkUserId;

@property (nonatomic, copy) NSString *checkDate;

@property (nonatomic, copy) NSString *checkUserName;

@property (nonatomic, assign) NSInteger checkId;

@property (nonatomic, assign) NSInteger hasProblem;

@property (nonatomic, assign) NSInteger state;

@property (nonatomic,strong) NSString *solveUserName;

@property (nonatomic,strong) NSString *solveUserId;

@property (nonatomic, strong) NSMutableArray<Checkinfoproblemclasslist *> *checkInfoProblemClassList;

@end

@interface Recheckproblemlist : NSObject

@property (nonatomic, assign) NSInteger state;

@property (nonatomic, assign) NSInteger reCheckId;

@property (nonatomic, copy) NSString *reCheckDate;

@property (nonatomic, assign) NSInteger checkId;

@property (nonatomic, strong) NSMutableArray<Recheckinfolist *> *recheckInfoList;

@property (nonatomic, assign) NSInteger reCheckUserId;

@property (nonatomic, copy) NSString *reCheckUserName;

@end

@interface Recheckinfolist : NSObject

@property (nonatomic, assign) NSInteger classType;

@property (nonatomic, copy) NSString *imagePath;

@property (nonatomic,copy) NSString *thumbnailPath;

@property(nonatomic,strong)NSMutableArray *imageArr;
@end

@interface Checkinfoproblemclasslist : NSObject

@property (nonatomic, assign) NSInteger classType;

@property (nonatomic, strong) NSArray<Checkinfodetaillist *> *checkInfoDetailList;

@property (nonatomic,strong)NSArray<SMSafetyContent*> *safetyContentArr;

@property (nonatomic, copy) NSString *imagePath;

@property (nonatomic,copy) NSString *thumbnailPath;

@property (nonatomic,strong)NSMutableArray *imageArr;

@end

@interface Checkinfodetaillist : NSObject

@property (nonatomic, copy) NSString *checkProblemId;

@property (nonatomic, copy) NSString *checkItemName;

@property (nonatomic, assign) NSInteger checkId;

@property (nonatomic, copy) NSString *checkContentId;

@property (nonatomic, copy) NSString *checkContentName;

@property (nonatomic, copy) NSString *checkProblemName;

@property (nonatomic, copy) NSString *checkItemId;

@property (nonatomic, copy) NSString *problemDesc;
@end

