//
//  SMSafetySourceItem.h
//  PMP
//
//  Created by mac on 15/12/1.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMSafetySourceItem : NSObject

@property(nonatomic,strong) NSString *name;//item名字
@property(nonatomic,strong) NSString *imageName;//图片名字

@property(nonatomic,assign) BOOL isOpen;//是否打开状态
@property(nonatomic,strong) NSMutableArray *sections;//item下面有多少子级
@property(nonatomic,strong)NSString *right;
//解析数据的方法
-(instancetype)initWithDict:(NSDictionary *)dic;

+(NSMutableArray *)allItems;


@end

@interface SMSafetySourceDetail : NSObject

@property(nonatomic,strong) NSString *name;//detail名字
@property(nonatomic,strong) NSString *imageName;//图片名字
@property(nonatomic,assign) NSInteger classID;//detail编号id
@property(nonatomic,strong)NSString *right;
@property(nonatomic,strong) id father;//父级

@end