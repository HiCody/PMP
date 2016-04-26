//
//  SMDatacheckTableView.m
//  PMP
//
//  Created by mac on 15/11/30.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMDatacheckTableView.h"

@implementation SMDatacheckTableView



-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.dataSource = self;
        
        
//        //设置搜索框
//        UISearchBar* searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, 320, 44)];
//        searchBar.delegate = self;
//        self.tableHeaderView =searchBar;
//
       
        
    }
    
    return self;
    
}

//一共几组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  5;
}

//一组有几行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return  1 ;
    
}

//头部间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
   return 20;
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor =[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    if (section ==0) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, WinWidth/4, 44)];
        self.titleLabel.text =@"安全管理";
        [view addSubview:self.titleLabel];
    }
    if (section ==1) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, WinWidth/4, 44)];
        self.titleLabel.text =@"安全验收";
        [view addSubview:self.titleLabel];
    }
    if (section ==2) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, WinWidth/4, 44)];
        self.titleLabel.text =@"危险源识别";
        [view addSubview:self.titleLabel];
    }
    if (section ==3) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, WinWidth/4, 44)];
        self.titleLabel.text =@"安全教育";
        [view addSubview:self.titleLabel];
    }
    if (section ==4) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, WinWidth/4, 44)];
        self.titleLabel.text =@"建筑机械设备维修保养";
        [view addSubview:self.titleLabel];
    }
    
       return view;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //1,定义一个共同的标识
    static NSString *ID = @"cell";
    //2,从缓存中取出可循环利用的cell
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ID];
    //3,如果缓存中没有可利用的cell，新建一个。
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
        }
    }
    
    cell.textLabel.text = @"sdaada";
    
       return cell;
    
}
//返回每行cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
       
    return   70;
    

    
}

//选中某行做某事
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   

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

//获取文字处理后的尺寸
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs=@{NSFontAttributeName:font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
