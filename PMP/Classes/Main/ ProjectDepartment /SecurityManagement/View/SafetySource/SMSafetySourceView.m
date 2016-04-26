//
//  SMSafetySourceView.m
//  PMP
//
//  Created by mac on 15/12/1.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMSafetySourceView.h"
#import "SMSafetySourceItem.h"
#import "SMSafetySourceTableViewDetailCell.h"
#import "SMSafetySourceTableViewItemCell.h"

static NSString *itemCellIdentifier=@"cell1";//item的cell
static NSString *detailCellIdentifier=@"cell2";//detail的cell
@interface SMSafetySourceView()<UITableViewDelegate,UITableViewDataSource,SMSafetySourceDelegate>

@property(nonatomic,strong)NSMutableArray *contentArr;

@property(nonatomic,strong)NSMutableArray *contentForShowArr;
@end

@implementation SMSafetySourceView
-(NSMutableArray *)contentArr{
    if (!_contentArr) {
        
        _contentArr=[SMSafetySourceItem allItems];
       
    }
    return _contentArr;
}

-(NSMutableArray *)contentForShowArr{
    if (!_contentForShowArr) {
        _contentForShowArr=[[NSMutableArray alloc]init];
    }
    return _contentForShowArr;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        [self reloadShowIngData];
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            
            [self setSeparatorInset:UIEdgeInsetsZero];
            
        }
        
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            
            [self setLayoutMargins:UIEdgeInsetsZero];
            
        }
        
        self.dataSource= self;
        self.delegate = self;
    }
    return self;
}


-(void)reloadShowIngData{
    [self.contentForShowArr removeAllObjects];
    [self reloadVisiableDataFrom:self.contentArr toTagertArr:self.contentForShowArr];
}

-(void)reloadVisiableDataFrom:(NSMutableArray *)initialArr toTagertArr:(NSMutableArray *)tagertArr{
    for (SMSafetySourceItem *item in initialArr) {
        [tagertArr addObject:item];
        if ([item isOpen]) {
            [tagertArr addObject:item.sections];
        }
    }
}


#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentForShowArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id value=self.contentForShowArr[indexPath.row];
    UITableViewCell *cell=[self getCellWithTableView:tableView andIndexpath:indexPath];
    if ([cell isKindOfClass:[SMSafetySourceTableViewItemCell class]]) {
        [(SMSafetySourceTableViewItemCell *)cell setCellItem:value];
    }
    else{
       
        [(SMSafetySourceTableViewDetailCell *)cell setDetailList:value];
    }
    cell.backgroundColor=[UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(UITableViewCell *)getCellWithTableView:(UITableView *)tableView andIndexpath:(NSIndexPath *)indexPath{
    id value=self.contentForShowArr[indexPath.row];
    UITableViewCell *cell;
    //如果value是BouceTableViewItem类型，复用itemCellIdentifier
    if ([value isKindOfClass:[SMSafetySourceItem class]]) {
        cell=[tableView dequeueReusableCellWithIdentifier:itemCellIdentifier];
        if (cell==nil) {
            cell=[[SMSafetySourceTableViewItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemCellIdentifier];
        }
    }
    //否则复用detailCellIdentifier
    else{
        cell=[tableView dequeueReusableCellWithIdentifier:detailCellIdentifier];
        if (cell==nil) {
            cell=[[SMSafetySourceTableViewDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailCellIdentifier];
        }
    }
    return cell;
}

//tableView行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id value=self.contentForShowArr[indexPath.row];
    CGFloat height=0;
    if ([value isKindOfClass:[SMSafetySourceItem class]]) {
        height=30;
    }
    else{
        UITableViewCell *cell=[self getCellWithTableView:tableView andIndexpath:indexPath];
        [(SMSafetySourceTableViewDetailCell *)cell setDetailList:value];
        height=[(SMSafetySourceTableViewDetailCell *)cell cellHeight];
    }
    return height;
}

//使cell的下划线顶头，沾满整个屏幕宽
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


@end
