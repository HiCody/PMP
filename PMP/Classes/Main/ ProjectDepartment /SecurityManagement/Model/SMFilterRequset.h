//
//  SMFilterRequset.h
//  PMP
//
//  Created by 顾佳洪 on 16/1/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMFilterRequset : NSObject

@property(nonatomic,strong)NSString *userId;//检查人工号查询项

@property(nonatomic,strong)NSString *checkTypeId;//检查类型查询项

@property(nonatomic,strong)NSString *hasProblem;//是否存在问题查询项

@property(nonatomic,strong)NSString *state;//检查状态查询项

@property(nonatomic,strong)NSString *checkUserName;//检查人姓名查询项

@property(nonatomic,strong)NSString *beginDate;//开始日期范围查询项

@property(nonatomic,strong)NSString *endDate;//结束日期范围查询项

@property(nonatomic,strong)NSString *solveUserName;//处理人姓名

@end
