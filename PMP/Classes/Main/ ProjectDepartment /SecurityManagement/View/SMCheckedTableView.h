//
//  SMCheckedTableView.h
//  PMP
//
//  Created by mac on 15/12/1.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMIssureListModel.h"
#import "SMIssureAnalysisModel.h"
@protocol CheckedDelegate <NSObject>

-(void)JumpToSecondView:(NSIndexPath *)indexPath;



@end

@interface SMCheckedTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
/** 代理对象 */
@property (nonatomic, weak) id<CheckedDelegate>checkedDelegate;

@property(nonatomic,strong)NSMutableArray *dataList;
@property(nonatomic,strong)NSMutableArray *dataArr;

@property(nonatomic,strong)SMIssureAnalysisModel *app;

- (void)beginRefresh;


@end
