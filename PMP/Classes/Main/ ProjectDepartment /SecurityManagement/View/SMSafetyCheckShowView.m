//
//  SMSafetyCheckShowView.m
//  PMP
//
//  Created by mac on 15/12/2.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMSafetyCheckShowView.h"
#import "SMSafetyContent.h"
#import "SMCheckIssureCell.h"
@interface SMSafetyCheckShowView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic,weak) UITableView * tableView;
@property (nonatomic,weak) UIView * headerView;
@property (nonatomic,weak) UIView * coverView;
@property (nonatomic,assign) BOOL isFirstLayout;
@property (nonatomic,strong)NSMutableArray *selectedArr;
@end

@implementation SMSafetyCheckShowView
- (NSMutableArray *)selectedArr{
    if (!_selectedArr) {
        _selectedArr = [[NSMutableArray alloc] init];
    }
    return _selectedArr;
}

-(instancetype)init
{
    if (self=[super init]) {
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        self.frame = CGRectMake(W(100), 0, screenBounds.size.width-W(100), screenBounds.size.height);
        _isFirstLayout = YES;
        
    }
    return self;
}



-(void)layoutSubviews
{
    //遮盖层
    if (_isFirstLayout) {
        UIButton * view = [[UIButton alloc] init];
        view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        view.frame=[UIScreen mainScreen].bounds;
        view.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.7];
        [view addTarget:self action:@selector(btnCancelClick) forControlEvents:UIControlEventTouchUpInside];
        self.coverView = view;
        [UIView commitAnimations];
        [self.superview addSubview:view];
        [self.superview bringSubviewToFront:self];
        
        [self setupHeaderNavigation];
        [self setupFilterTable];
        
    }
    _isFirstLayout= NO;
}

- (void)setupFilterTable{
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    
    UINavigationController *navi=[[UINavigationController alloc] init];
    CGRect rectNav = navi.navigationBar.frame;
    
    UITableView * tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 64, self.frame.size.width, self.frame.size.height-64);
    tableView.delegate=self;
    tableView.dataSource=self;
    
    //去掉多余的分割线
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self addSubview:tableView];
    self.tableView = tableView;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    tableView.frame =CGRectMake(0,rectNav.size.height+rectStatus.size.height, self.frame.size.width, self.frame.size.height-rectNav.size.height-rectStatus.size.height);
    [UIView commitAnimations];

}

//头部导航栏
-(void)setupHeaderNavigation
{
    UIView * view = [[UIView alloc] init];
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];

    UINavigationController *navi=[[UINavigationController alloc] init];
   CGRect rectNav = navi.navigationBar.frame;
   
    view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0,self.frame.size.width, rectNav.size.height+rectStatus.size.height);
    view.backgroundColor = NAVI_SECOND_COLOR;
    self.headerView = view;
    [self addSubview:view];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    view.frame = CGRectMake(0, 0, self.frame.size.width, rectNav.size.height+rectStatus.size.height);
    [UIView commitAnimations];
    
    //确定按钮
    UIButton * btnOK = [[UIButton alloc] init];
    btnOK.frame = CGRectMake(view.frame.size.width-50, 20, 50, 40);
    [btnOK setTitle:@"确定" forState:UIControlStateNormal];
    [btnOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnOK addTarget:self action:@selector(btnOKClick) forControlEvents:UIControlEventTouchUpInside];
    btnOK.titleLabel.font = [UIFont systemFontOfSize:16];
    [view addSubview:btnOK];
    
    //标题
    UILabel * lblTitle = [[UILabel alloc] init];
    lblTitle.frame = CGRectMake(10,rectStatus.size.height, 110, 40);
    lblTitle.text = @"检查问题";
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.font = [UIFont systemFontOfSize:18];
    [view addSubview:lblTitle];

}

-(void)btnOKClick
{
    NSMutableArray *tempArr=[[NSMutableArray alloc] init];
    for (int i=0; i<self.selectedArr.count; i++) {
        NSIndexPath *indexPath=self.selectedArr[i];
        SMSafetyContentThirdDetail *thirdDetail = self.dataArr[indexPath.row];
        [tempArr addObject:thirdDetail];
    }
    
    [tempArr  sortedArrayUsingComparator:^NSComparisonResult(SMSafetyContentThirdDetail *obj1, SMSafetyContentThirdDetail *obj2) {
        NSComparisonResult result = [obj1.classID compare:obj2.classID];
        
        return result;
    }];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(SMSafetyCheckShowViewFinishedPickkingFilter:)]) {
        [self.delegate SMSafetyCheckShowViewFinishedPickkingFilter:tempArr];
    }
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    //隐藏
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(screenWidth,0,0, screenHeight);
        self.coverView.frame = CGRectMake(screenWidth,0,0, screenHeight);
        
    } completion:^(BOOL finished) {
        [self.coverView removeFromSuperview];
        [self removeFromSuperview];
        
    }];
    
    
    
    
}

-(void)btnCancelClick
{
    for (int i=0; i<self.selectedArr.count; i++) {
        NSIndexPath *indexPath= self.selectedArr[i];
        SMSafetyContentThirdDetail *thirdDetail =self.dataArr[indexPath.row] ;
        thirdDetail.isOpen=NO;
    }
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(SMSafetyCheckShowViewCancelled)]) {
        [self.delegate SMSafetyCheckShowViewCancelled];
    }
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    //隐藏遮盖层
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(screenWidth,0,0, screenHeight);
        self.coverView.frame = CGRectMake(screenWidth,0,0, screenHeight);
        
    } completion:^(BOOL finished) {
       
        [self.coverView removeFromSuperview];
        [self removeFromSuperview];
        
    }];
    
}


#pragma mark
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMCheckIssureCell *cell=(SMCheckIssureCell *)[self getCellWithTableView:tableView];
    SMSafetyContentThirdDetail *thirdDetail = self.dataArr[indexPath.row];
    cell.title=thirdDetail.name;
    if (thirdDetail.isOpen) {
        cell.selectState=1;
    }else{
        cell.selectState=0;
    }

    return cell;
}

-(UITableViewCell *)getCellWithTableView:(UITableView *)tableView{
    static NSString *identifier=@"cell";
    SMCheckIssureCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[SMCheckIssureCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMCheckIssureCell *cell=(SMCheckIssureCell *)[self getCellWithTableView:tableView];
    SMSafetyContentThirdDetail *thirdDetail = self.dataArr[indexPath.row];
    cell.title=thirdDetail.name;
    return cell.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SMSafetyContentThirdDetail *thirdDetail = self.dataArr[indexPath.row];
    thirdDetail.isOpen=!thirdDetail.isOpen;
    if (thirdDetail.isOpen) {
        [self.selectedArr addObject:indexPath];
    }else{
        [self.selectedArr removeObject:indexPath];
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


@end
