//
//  SMFilterTableView.h
//  PMP
//
//  Created by 顾佳洪 on 16/1/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XIDropdownlistViewProtocol.h"
#import "SMFilterRequset.h"
@protocol SMFilterDelegate <NSObject>

-(void)JumpToFilter:(NSIndexPath *)indexPath;

- (void)requestWithFilterData:(SMFilterRequset *)filterRequset;
@end

@interface SMFilterTableView : UITableView<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,XIDropdownlistViewProtocol>
@property (nonatomic, weak) id<SMFilterDelegate> filterDelegate;

@property(nonatomic,strong)NSString *dateString;
@property(nonatomic,strong)NSString *endDateString;
@property(nonatomic,strong)NSString *typeStr;
@property(nonatomic,strong)NSString *hasPro;
@property(nonatomic,strong)SMFilterRequset *filterRequest;
@end
