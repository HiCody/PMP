//
//  SMIssureListModel.h
//  PMP
//
//  Created by mac on 15/12/3.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetRequestClass.h"
@class SMAllInfoModel,SMCheckinfoproblemclasslist,SMCheckinfodetaillist;
@interface SMIssureListModel : NSObject


@property (nonatomic, strong) NSArray<SMAllInfoModel *> *totalArr;


@end

@interface SMAllInfoModel : NSObject

@property (nonatomic, assign) NSInteger checkTypeId;// 检查类别1. 日常检查  2.专项检查

@property (nonatomic, copy) NSString *recheckProblemList;//列表页中不用处理

@property (nonatomic, assign) NSInteger checkUserId;//检查人员编号

@property (nonatomic, copy) NSString *checkDate;//检查日期

@property (nonatomic, copy) NSString *checkUserName;//检查人员名称

@property (nonatomic, assign) NSInteger checkId; //检查问题编号

@property (nonatomic, assign) NSInteger hasProblem; //是否存在问题:0：未发现问题 1 存在问题

@property (nonatomic, assign) NSInteger state;  //问题状态：1: 未发现问题  2：待复查  3：复查未通过 4：复查通过

@property (nonatomic, strong) NSMutableArray<SMCheckinfoproblemclasslist *> *checkInfoProblemClassList;

@end

@interface SMCheckinfoproblemclasslist : NSObject

@property (nonatomic, assign) NSInteger classType;//第一个检查内容为：0，第二个检查内容为1，以此类推。用以分类。

@property (nonatomic, strong) NSArray<SMCheckinfodetaillist *> *checkInfoDetailList;
//该问题对应选择的的问题选项

@property (nonatomic, copy) NSString *imagePath;//该检查问题对应图片地址: | 分割

@end

@interface SMCheckinfodetaillist : NSObject

@property (nonatomic, copy) NSString *checkProblemId;//检查问题编号

@property (nonatomic, copy) NSString *checkItemName;//检查项目名称

@property (nonatomic, assign) NSInteger checkId;//检查问题编号(无用)

@property (nonatomic, copy) NSString *checkContentId;//检查内容编号

@property (nonatomic, copy) NSString *checkContentName;//检查内容名称

@property (nonatomic, copy) NSString *checkProblemName;//检查问题名称

@property (nonatomic, copy) NSString *checkItemId;//检查项目编号

@end

