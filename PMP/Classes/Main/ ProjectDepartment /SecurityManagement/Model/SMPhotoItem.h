//
//  SMPhotoItem.h
//  PMP
//
//  Created by mac on 15/12/1.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>



@class Resultlist;
@interface SMPhotoItem : NSObject

@property(nonatomic,assign) BOOL isOpen;//是否打开状态

@property (nonatomic, copy) NSString *date;

@property (nonatomic, strong) NSArray<Resultlist *> *resultList;



@end

@interface Resultlist : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *menuId;

@property (nonatomic, copy) NSString *fileName;

@property (nonatomic, copy) NSString *uploadTime;

@property (nonatomic, assign) NSInteger fileSize;

@property (nonatomic, copy) NSString *thumbnailPath;

@property (nonatomic, assign) NSInteger groupByDate;

@property (nonatomic, assign) NSInteger delFlag;

@property (nonatomic, copy) NSString *menuName;

@property (nonatomic, copy) NSString *fileTypeName;

@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, assign) NSInteger fileType;

@end

