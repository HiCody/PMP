//
//  SMSafetyContent.h
//  PMP
//
//  Created by mac on 15/12/2.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SMSafetyContentSecondDetail,SMSafetyContentThirdDetail;
@interface SMSafetyContent : NSObject

@property(nonatomic,strong) NSString *name;//item名字

@property(nonatomic,strong) NSString *classID;//编号id

@property(nonatomic,assign) BOOL isOpen;//是否打开状态

@property(nonatomic,strong) NSArray<SMSafetyContentSecondDetail *> *sections;//item下面有多少子级

@end

@interface SMSafetyContentSecondDetail : NSObject

@property(nonatomic,strong) NSString *name;//detail名字

@property(nonatomic,strong) NSString *classID;//detail编号id

@property(nonatomic,assign) BOOL isOpen;//是否打开状态

@property(nonatomic,strong) NSArray<SMSafetyContentThirdDetail *> *sections;//item下面有多少子级

@property(nonatomic,strong) id father;//父级

@end

@interface SMSafetyContentThirdDetail : NSObject

@property(nonatomic,strong) NSString *name;//detail名字

@property(nonatomic,strong) NSString *classID;//detail编号id

@property(nonatomic,assign) BOOL isOpen;//是否打开状态

@property(nonatomic,strong) id father;//父级

@end

@interface SMSafetyContentAssemble : NSObject

@property(nonatomic,strong)NSMutableArray *arr;

@end

