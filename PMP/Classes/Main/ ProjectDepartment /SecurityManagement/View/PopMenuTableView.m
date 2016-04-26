//
//  PopMenuTableView.m
//  PMP
//
//  Created by mac on 15/12/7.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "PopMenuTableView.h"

@implementation PopMenuTableView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self =[super initWithFrame:frame]) {
        self.delegate =self;
        self.dataSource =self;
        self.bounces =NO;
    }
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self setLayoutMargins:UIEdgeInsetsZero];
        
    }
   
    return  self;

}

//一共几组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}

//一组有几行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //1,定义一个共同的标识
    static NSString *ID = @"cell";
    //2,从缓存中取出可循环利用的cell
    UITableViewCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
    //3,如果缓存中没有可利用的cell，新建一个。
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //
    cell.textLabel.text = self.arr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    
    return cell;
    
}
//返回每行cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.menuDelegate&&[self.menuDelegate respondsToSelector:@selector(openWithTitle:)]) {
     
     UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
      cell.textLabel.text = self.arr[indexPath.row];
        [self.menuDelegate openWithTitle:self.arr[indexPath.row]];
    
         }
}


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
