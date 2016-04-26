//
//  SMMessageCenterModel.h
//  PMP
//
//  Created by mac on 15/12/31.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMMessageCenterModel : NSObject

@property (nonatomic, copy) NSString *checkInfos;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger pushUserId;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) BOOL read;

@property (nonatomic, assign) NSInteger checkId;

@property (nonatomic, copy) NSString *pushDate;

@property (nonatomic, assign) NSInteger state;

@end


