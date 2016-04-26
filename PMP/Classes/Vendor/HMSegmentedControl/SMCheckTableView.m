//
//  SMCheckTableView.m
//  PMP
//
//  Created by mac on 15/11/30.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMCheckTableView.h"

@implementation SMCheckTableView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.dataSource = self;
        
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            
            [self setSeparatorInset:UIEdgeInsetsZero];
            
        }
        
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            
            [self setLayoutMargins:UIEdgeInsetsZero];
            
        }
        
        
      
        
    }
    
    return self;
    
}
//一共几组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}

//一组有几行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
    
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
    
    cell.selectionStyle = UITableViewCellAccessoryDisclosureIndicator;
    
    UILabel *bigLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,10,50, 50)];
    bigLabel.layer.masksToBounds=YES;
    bigLabel.layer.cornerRadius=25;
    bigLabel.backgroundColor =[UIColor orangeColor];
    
    bigLabel.text = @"待";
    bigLabel.font = [UIFont systemFontOfSize:24];
    bigLabel.textColor = [UIColor whiteColor];
    bigLabel.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:bigLabel];
    
    
    UILabel* headLabel = [[UILabel alloc]init];
    headLabel.text = @"日常检查";
    headLabel.font = [UIFont systemFontOfSize:15];
    
    CGSize headSize =[self sizeWithText:headLabel.text font:headLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    headLabel.frame= CGRectMake(80, bigLabel.frame.origin.y, W(200), headSize.height);
    
    [cell.contentView addSubview:headLabel];
   
    
    UILabel *firstLabel = [[UILabel alloc] init];
    firstLabel.text = @"阿斯顿那是多大的马力达到阿大多数大声道阿达";
    firstLabel.font = [UIFont systemFontOfSize:12];
    firstLabel.textColor = [UIColor grayColor];
    CGSize firstSize =[self sizeWithText:firstLabel.text font:firstLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    firstLabel.frame = CGRectMake(headLabel.frame.origin.x,  bigLabel.frame.origin.y +30, firstSize.width, firstSize.height);
    [cell.contentView addSubview:firstLabel];

    
    
    
        //日期时间
    UILabel *fourthLabel = [[UILabel alloc] init];
    NSString *dateStr  = @"2015-11-18";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:dateStr];
    
//    NSString *dateStr2= [date timeIntervalDescription];
    
    fourthLabel.text = dateStr;
    fourthLabel.textAlignment = NSTextAlignmentRight;
    fourthLabel.font = [UIFont systemFontOfSize:10];
    fourthLabel.textColor = [UIColor grayColor];
    CGSize fourthSize = [self sizeWithText:fourthLabel.text font: fourthLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    fourthLabel.frame  =  CGRectMake(WinWidth-fourthSize.width-5, bigLabel.frame.origin.y, fourthSize.width, fourthSize.height);
    [cell.contentView addSubview:fourthLabel];
    
    return cell;
    
}
//返回每行cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
    
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
