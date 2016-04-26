//
//  BCSMSafetyCheckDetailCell.h
//  PMP
//
//  Created by 顾佳洪 on 16/1/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCSMSafetyCheckDetailModel.h"
@interface BCSMSafetyCheckDetailCell : UITableViewCell

@property(nonatomic,strong)BCSMSafetyCheckDetailModel *detailModel;

@property(nonatomic,strong)BCSMCompanycheckimages *checkImages;

@property(nonatomic,strong)NSArray *prolist;

@property(nonatomic,assign)CGFloat cellHeight;

@property(nonatomic,copy)void(^showImageView)(NSArray *,NSInteger);

@end
