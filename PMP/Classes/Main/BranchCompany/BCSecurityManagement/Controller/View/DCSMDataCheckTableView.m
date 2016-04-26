//
//  SMDataCheckTableView.m
//  PMP
//
//  Created by mac on 16/1/12.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "DCSMDataCheckTableView.h"
#import "DCSMDataCheckCell.h"

@interface DCSMDataCheckTableView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation DCSMDataCheckTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if ([super initWithFrame:frame style:style]) {
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     return self.datalist.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    DCSMDataCheckCell *cell  =[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [DCSMDataCheckCell cell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    
    BCSMSafetyCheckModel *safetyCheck  =self.datalist[indexPath.section];
    
    cell.safetyCheck  =safetyCheck;
    
    cell.lineWidth.constant= WinWidth-12*2;
    cell.lineWidth2.constant= WinWidth-12*2;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.1;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BCSMSafetyCheckModel *safetyCheck  =self.datalist[indexPath.section];
    
    self.segureToSecurityCheckListVC(safetyCheck);
}
@end
