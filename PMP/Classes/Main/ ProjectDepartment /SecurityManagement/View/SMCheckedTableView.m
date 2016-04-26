//
//  SMCheckedTableView.m
//  PMP
//
//  Created by mac on 15/12/1.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMCheckedTableView.h"
#import "SMImage.h"
@implementation SMCheckedTableView

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

//延迟实例化
-(NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc]init];
    }
    
    return  _dataList;
    
}
//延迟实例化
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    
    return  _dataArr;
    
}

- (void)beginRefresh{
    // 马上进入刷新状态
    [self.mj_header beginRefreshing];
}

//将lable转换为image
-(UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


//一共几组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}

//一组有几行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
    
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
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
            //删除并进行重新分配
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    self.app =self.dataList[indexPath.row];
    UIView *imgView=[[UIView alloc] initWithFrame:CGRectMake(10, 10, 50,50)];
    UILabel *imgLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 50,25)];
    UILabel *imgLab2=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, 50,25)];
    [imgView addSubview:imgLab];
    [imgView addSubview:imgLab2];
    switch (self.app.state) {
        case 1:
            imgLab.text =@"无";
            imgLab2.text=@"问题";
            imgLab.backgroundColor=[UIColor clearColor];
             imgView.backgroundColor=[UIColor colorWithRed:146/255.0 green:189/255.0 blue:59/255.0 alpha:1.0];
            break;
        case 2:
            imgLab.text =@"待";
            imgLab2.text=@"处理";
            imgLab.backgroundColor=[UIColor clearColor];
            imgLab2.backgroundColor=[UIColor clearColor];
            imgView.backgroundColor=[UIColor purpleColor];
            break;
        case 3:
            imgLab.text =@"待";
            imgLab2.text=@"复查";
            imgLab.backgroundColor=[UIColor clearColor];
            imgLab2.backgroundColor=[UIColor clearColor];
             imgView.backgroundColor=[UIColor colorWithRed:242/255.0 green:209/255.0 blue:8/255.0 alpha:1.0];
            break;
        case 4:
            imgLab.text =@"未";
            imgLab2.text=@"通过";
            imgLab.backgroundColor=[UIColor clearColor];
            imgLab2.backgroundColor=[UIColor clearColor];
             imgView.backgroundColor=[UIColor colorWithRed:253/255.0 green:132/255.0 blue:139/255.0 alpha:1.0];
            break;
        case 5:
            imgLab.text =@"已";
            imgLab2.text=@"通过";
            imgLab.backgroundColor=[UIColor clearColor];
            imgLab2.backgroundColor=[UIColor clearColor];
            imgView.backgroundColor=[UIColor colorWithRed:116/255.0 green:204/255.0 blue:242/255.0 alpha:1.0];
            break;
            
        default:
            break;
    }
    imgLab.lineBreakMode =NSLineBreakByTruncatingTail;
    imgLab.numberOfLines=0;
    imgLab.font=[UIFont systemFontOfSize:14];
    imgLab.textAlignment=NSTextAlignmentCenter;
    imgLab.textColor=[UIColor whiteColor];
    imgLab.layer.cornerRadius=25.0f;
    
    imgLab2.lineBreakMode =NSLineBreakByTruncatingTail;
    imgLab2.numberOfLines=0;
    imgLab2.font=[UIFont systemFontOfSize:14];
    imgLab2.textAlignment=NSTextAlignmentCenter;
    imgLab2.textColor=[UIColor whiteColor];
    imgLab2.layer.cornerRadius=25.0f;
    
    UIImage *image=[SMImage imageWithView:imgView];
    cell.imageView.image=image;
    cell.imageView.layer.cornerRadius=25.0f;
    cell.imageView.layer.masksToBounds=YES;
    cell.imageView.backgroundColor =[UIColor clearColor];
    
    
    switch (self.app.checkTypeId) {
        case 1:
             cell.textLabel.text = @"日常检查";
            break;
        case 2:
              cell.textLabel.text = @"专项检查";
            break;
        default:
            break;
    }
    
    NSMutableArray *tempArr=[[NSMutableArray alloc] init];
    for (SMACheckinfoproblemclasslist *proClasslist in self.app.checkInfoProblemClassList) {
        for (SMACheckinfodetaillist *detailList in proClasslist.checkInfoDetailList) {
            if (detailList.checkProblemName) {
                [tempArr addObject:detailList.checkProblemName];
            }
            if (detailList.problemDesc) {
                [tempArr addObject:detailList.problemDesc];
            }
            
        }
    }
    cell.detailTextLabel.numberOfLines=3;
    NSString *str;
    if (tempArr.count) {
        str =[tempArr componentsJoinedByString:@","];
        cell.detailTextLabel.text = str;
        cell.detailTextLabel.textColor =[UIColor grayColor];
    }
   
    
    //日期时间
    UILabel *fourthLabel = [[UILabel alloc] init];
    NSString *dateStr  = self.app.checkDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    fourthLabel.text = dateStr;
    fourthLabel.textAlignment = NSTextAlignmentRight;
    fourthLabel.font = [UIFont systemFontOfSize:10];
    fourthLabel.textColor = [UIColor grayColor];
    CGSize fourthSize = [self sizeWithText:fourthLabel.text font: fourthLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    fourthLabel.frame  =  CGRectMake(WinWidth-fourthSize.width-5, 5, fourthSize.width, fourthSize.height);
    [cell.contentView addSubview:fourthLabel];
    
    
    return cell;
    
}

-(UIImage*)convertViewToImage:(UIView*)v
{
    CGSize s = v.bounds.size;
    
    
    
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [v.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    v.layer.contents = nil;
    return image;
    
}

//返回每行cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
    
}

//选中某行做某事
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.checkedDelegate&&[self.checkedDelegate respondsToSelector:@selector(JumpToSecondView:)]) {
        
        [self.checkedDelegate JumpToSecondView:indexPath];
    }
    
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
