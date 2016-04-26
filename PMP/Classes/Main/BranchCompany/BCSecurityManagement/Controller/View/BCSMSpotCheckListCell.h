//
//  BCSMSpotCheckListCell.h
//  PMP
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCSMSafetyCheckDetailModel.h"
@interface BCSMSpotCheckListCell : UITableViewCell

@property (nonatomic,strong)NSArray *infoList;

@property (nonatomic,assign)CGFloat cellHeight;

@property (nonatomic,copy)void(^chooseSpotCheck)(UIButton *);

@property (nonatomic,copy)NSString *spotInfo;

@property (nonatomic,strong)BCSMSpotinfos *spotInfos;

@property (nonatomic,assign)BOOL isEditing;
@end
