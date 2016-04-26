//
//  BCSMSpotCheckListTableView.h
//  PMP
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCSMSpotCheckListTableView : UITableView

@property(nonatomic,strong)NSArray *datalist;

@property(nonatomic,strong)NSArray *spotInfoArr;

@property (nonatomic,copy)void(^chooseBySpotCheck)(UIButton *,NSInteger);

@property (nonatomic,assign)BOOL isEditing;

@end
