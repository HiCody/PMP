//
//  SMSafetySourceItem.m
//  PMP
//
//  Created by mac on 15/12/1.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMSafetySourceItem.h"

@implementation SMSafetySourceItem
-(NSMutableArray *)sections{
    if (!_sections) {
        _sections=[[NSMutableArray alloc]init];
    }
    return _sections;
}

+(NSMutableArray *)allItems{
    NSMutableArray *arrM=[[NSMutableArray alloc]init];
    NSString *filePath=[[NSBundle mainBundle] pathForResource:@"SafetySource" ofType:@"plist"];
    NSArray *arr=[[NSArray alloc]initWithContentsOfFile:filePath];
    //解析plist添加到数组
    for (NSDictionary *dic in arr) {
        SMSafetySourceItem *item=[SMSafetySourceItem decodeWithDict:dic];
        [arrM addObject:item];
    }
    return arrM;
}


+(instancetype)decodeWithDict:(NSDictionary *)dic{
    return [[self alloc]initWithDict:dic];
}

-(instancetype)initWithDict:(NSDictionary *)dic{
    if (self=[super init]) {
        self.imageName=[dic objectForKey:@"imageName"];
        self.name=[dic objectForKey:@"name"];
        self.isOpen=YES;//默认情况下item是开启状态
         self.right =[dic objectForKey:@"right"];
        NSArray *sectionArr=[dic objectForKey:@"subClass"];
        if (sectionArr.count>0) {
            for (NSDictionary *tmpDic in sectionArr) {
                SMSafetySourceDetail *detail=[[SMSafetySourceDetail alloc]init];
                detail.classID=[[tmpDic objectForKey:@"classID"] integerValue];
                detail.imageName=[tmpDic objectForKey:@"imageName"];
                detail.name=[tmpDic objectForKey:@"name"];
                detail.father=self;
                detail.right =[tmpDic objectForKey:@"right"];
                [self.sections addObject:detail];//当前sections添加的是当前item下面一条条具体信息
            }
        }
    }
    return self;
}@end


@implementation SMSafetySourceDetail

@end