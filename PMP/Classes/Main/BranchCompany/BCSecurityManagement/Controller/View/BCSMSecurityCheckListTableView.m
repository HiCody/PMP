//
//  BCSMSecurityCheckListTableView.m
//  PMP
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "BCSMSecurityCheckListTableView.h"
#import "BCSMSecurityCheckListCell.h"
#import "UIImage+Circle.h"
#import "SMImage.h"
#import "UIColor+Random.h"
@interface BCSMSecurityCheckListTableView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation BCSMSecurityCheckListTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if ([super initWithFrame:frame style:style]) {
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor colorWithRed:241/255.0 green:242/255.0 blue:244/255.0 alpha:1.0];
    }
    return self;
}

#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *tempArr = self.datalist[section];
    return tempArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    BCSMSecurityCheckListCell *cell  =[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [BCSMSecurityCheckListCell cell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    NSArray *tempArr = self.datalist[indexPath.section];
    
    BCSMSafetyCheckDetailModel *safetyCheck  =tempArr[indexPath.row];
    
    cell.detailModel  = safetyCheck;
    NSString *date  = safetyCheck.checkDate;
    NSString *day = [date substringWithRange:NSMakeRange(date.length-2,2)];

    if ((int)day >=10) {
        cell.dateLable.text =day;
    }
    else{
       NSString *days = [date substringWithRange:NSMakeRange(date.length-1,1)];
         cell.dateLable.text =days;
    }
    
    if (indexPath.row==0) {
        cell.dateLable.textColor = NAVI_SECOND_COLOR;
        cell.dayLable.textColor = NAVI_SECOND_COLOR;
    }

    cell.backView.layer.cornerRadius=5.0;
    cell.backView.layer.borderColor = [UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0 alpha:1.0].CGColor;
    cell.backView.layer.borderWidth = 1.0;
    
    cell.backWidth.constant  = WinWidth-85;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 40)];
    view.backgroundColor = [UIColor colorWithRed:241/255.0 green:242/255.0 blue:244/255.0 alpha:1.0];
    
    UIView *lineView =[[UIView alloc] initWithFrame:CGRectMake(65, 0, 1, 40)];
    lineView.backgroundColor  = [UIColor lightGrayColor];
    [view addSubview:lineView];
    
    UIImageView *arreImageView=[[UIImageView alloc]initWithFrame:CGRectMake(59,13.5, 13, 13)];
    arreImageView.image=[UIImage imageNamed:@"timeline_green.png"];
    
    [view addSubview:arreImageView];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, WinWidth, 40)];
    lable.backgroundColor = [UIColor clearColor];
    lable.textColor = [UIColor lightGrayColor];
    lable.font = [UIFont systemFontOfSize:17.0];
    lable.textColor = NAVI_SECOND_COLOR;
    [view addSubview:lable];
    
    NSString *dateStr = self.sectionArr[section];
    NSArray *dateArr  =[dateStr componentsSeparatedByString:@"-"];
    
    lable.text = [NSString stringWithFormat:@"%@/%@",dateArr.firstObject,dateArr.lastObject];

    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *tempArr = self.datalist[indexPath.section];
    
    BCSMSafetyCheckDetailModel *safetyCheck  =tempArr[indexPath.row];

    self.segureToSafetyDetailVC(safetyCheck);
}


@end
