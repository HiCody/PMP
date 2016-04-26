//
//  DCSMSafetyCheckModel.h
//  PMP
//
//  Created by mac on 16/1/12.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCSMSafetyCheckModel : NSObject

@property(nonatomic,strong)NSString *projectManager;

@property(nonatomic,strong)NSString *qualityController;

@property(nonatomic,strong)NSString *checkTime;

@property(nonatomic,strong)NSString *technicalDirector;

@property(nonatomic,strong)NSString * safetyOfficer;

@property(nonatomic,strong)NSString * checker;

@property(nonatomic,strong)NSString *projectName;
@end
