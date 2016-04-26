//
//  BCSMSpotCheckListViewController.h
//  PMP
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCSMSpotCheckListViewController : UIViewController

@property (nonatomic,copy)void(^passSpotCheck)(NSArray *);

@property (nonatomic,strong)NSMutableArray *spotInfos;

@property (nonatomic,assign)BOOL isEdit;

@end
