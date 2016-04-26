//
//  BCSMSafetyCheckDetailCell.m
//  PMP
//
//  Created by 顾佳洪 on 16/1/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "BCSMSafetyCheckDetailCell.h"
#import "NSString+NumRevretToChinese.h"
#define kLableHeight  50
#define K_ImageWidth  floorf((WinWidth-20*2- 10*3)/4)
#define K_Count 4
#define K_Space 10
#define K_Orignx 20

#define k_LineColor [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0]

#define kLableHeight2 38
#define kLableWidthLeft W(100)
#define kLableWidthRight W(200)
#define kLablePadding  15

@implementation BCSMSafetyCheckDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDetailModel:(BCSMSafetyCheckDetailModel *)detailModel{
    _detailModel   =  detailModel;
    [self setUpFrame];
}

- (void)setCheckImages:(BCSMCompanycheckimages *)checkImages{
    _checkImages = checkImages;
     [self setUpFrame];
}

- (void)setUpFrame{
    [self removeSubViews];
    self.cellHeight = 0;
    UIView *view = [[UIView alloc] init];
    
    UILabel *piclable = [[UILabel alloc] initWithFrame:CGRectMake(16 , 0.5, WinWidth, kLableHeight)];
    piclable.font = [UIFont systemFontOfSize:14.0];
    NSString *numStr = [NSString stringWithFormat:@"%li",self.checkImages.classType+1];
    NSString *positionName;
    if (self.checkImages.positionName) {
        positionName =self.checkImages.positionName;
    }else if(self.checkImages.problemDesc){
        positionName =self.checkImages.problemDesc;
    }
    piclable.text = [NSString stringWithFormat:@"%@.%@",[NSString translation:numStr],positionName];
    [view addSubview:piclable];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(piclable.frame), WinWidth, 0.5)];
    lineView.backgroundColor=k_LineColor;
    [view addSubview:lineView];
    
    NSArray *picArr=[self addHttpHeadToPic:@[self.checkImages.imagePath]];
    
    UIView *picView = [self listImageViewWithPicArr:picArr WithTag:100];
    picView.top = CGRectGetMaxY(piclable.frame);
    
    [view addSubview:picView];
    self.cellHeight = CGRectGetMaxY(picView.frame);
    
    UIView *proView = [self problemViewWithArr:[self.prolist mutableCopy]];
    [view addSubview:proView];
     proView.top =self.cellHeight;
    
    self.cellHeight = CGRectGetMaxY(proView.frame);
    
    view.frame = CGRectMake(0, 0, WinWidth, self.cellHeight);
    [self.contentView addSubview:view];

}

- (UIView *)problemViewWithArr:(NSMutableArray *)arr{
    
    NSMutableArray *dateMutablearray=[[NSMutableArray alloc] init];
    for (int i = 0; i < arr.count; i ++) {
        BCSMCompanycheckdetails *checkInfoDelist = arr[i];
        NSMutableArray *tempArray = [@[] mutableCopy];
        [tempArray addObject:checkInfoDelist];
        for (int j = i+1; j < arr.count; j ++) {
            BCSMCompanycheckdetails *checkInfoDelist2 = arr[j];
            
            if([checkInfoDelist.checkContentId isEqualToString:checkInfoDelist2.checkContentId]){
                [tempArray addObject:checkInfoDelist2];
            }
        }
        [arr removeObjectsInArray:tempArray];
        i=-1;
        [dateMutablearray addObject:tempArray];
    }
    
//        for (BCSMCompanycheckdetails *checkInfoDelist2 in dateMutablearray.lastObject) {
//            //NSLog(@"%@",checkInfoDelist2.checkContentId);
//        }
    
    NSMutableArray *firstArr=[[NSMutableArray alloc] init];
    for (int i=0; i<dateMutablearray.count;i++) {
        SMSafetyContent *content = [[SMSafetyContent alloc] init];
        NSArray *tempArr  =dateMutablearray[i];
        BCSMCompanycheckdetails *detailList=tempArr.firstObject;
        content.classID =detailList.checkContentId;
        content.name = detailList.checkContentName;
        NSMutableArray *secondArr=[[NSMutableArray alloc] init];
        NSInteger classIndex=-1;
        for (BCSMCompanycheckdetails *detailList1 in tempArr) {
            SMSafetyContentSecondDetail *secondDetail =[[SMSafetyContentSecondDetail alloc] init];
            if (classIndex==detailList1.checkItemId.integerValue) {
                continue;
            }else{
                secondDetail.name = detailList1.checkItemName;
                secondDetail.classID = detailList1.checkItemId;
                classIndex=detailList1.checkItemId.integerValue;
                NSMutableArray *thirdArr=[[NSMutableArray alloc] init];
                for (BCSMCompanycheckdetails *detailList2 in tempArr) {
                    if ([detailList2.checkItemId isEqualToString:secondDetail.classID]) {
                        SMSafetyContentThirdDetail *thirdDetail = [[SMSafetyContentThirdDetail alloc] init];
                        if (detailList2.checkProblemName) {
                            thirdDetail.name =detailList2.checkProblemName;
                            thirdDetail.classID = detailList2.checkProblemId;
                        }else{
                            thirdDetail.name =detailList2.problemDesc;
                            thirdDetail.classID = @"-1";
                        }
                        
                        [thirdArr addObject:thirdDetail];
                        
                    }
                }
                secondDetail.sections = thirdArr;
                [secondArr addObject:secondDetail];
                
            }
            
        }
        content.sections = secondArr;
        [firstArr addObject:content];
    }
    
    
    
    UIView *view = [[UIView alloc] init];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, WinWidth, kLableHeight)];
    lable.text = @"检查问题";
    lable.font = [UIFont systemFontOfSize:14.0];
    [view addSubview:lable];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lable.frame), WinWidth, 0.5)];
    lineView.backgroundColor=k_LineColor;
    [view addSubview:lineView];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 0.5)];
    lineView1.backgroundColor=k_LineColor;
    [view addSubview:lineView1];
    
    CGFloat firstHeight=0;
    CGFloat proHeight = 0;
    for (int i =0;i<firstArr.count ; i++) {
        SMSafetyContent *content=firstArr[i];
        
        UILabel *contentLable =[[UILabel alloc] initWithFrame:CGRectMake(15,kLableHeight+1+10+firstHeight, kLableWidthLeft, kLableHeight2)];
        if (i==0) {
            contentLable.top=kLableHeight+10+firstHeight;
        }else{
            contentLable.top=10+firstHeight;
        }
        contentLable.font =[UIFont systemFontOfSize:15.0];
        contentLable.text=@"检查内容";
        contentLable.textColor=[UIColor whiteColor];
        contentLable.textAlignment=NSTextAlignmentCenter;
        contentLable.backgroundColor=NAVI_SECOND_COLOR;
        contentLable.layer.cornerRadius=10.0;
        contentLable.layer.masksToBounds=YES;
        
        [view addSubview:contentLable];
        
        UILabel *contentDetailLable =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(contentLable.frame)+kLablePadding, contentLable.frame.origin.y,kLableWidthRight,kLableHeight2)];
        contentDetailLable.font =[UIFont systemFontOfSize:14.0];
        contentDetailLable.text=content.name;
        contentDetailLable.textColor=[UIColor lightGrayColor];
        [view addSubview:contentDetailLable];
        
        CGFloat secondHeight=0;
        for (int j=0; j<content.sections.count; j++) {
            SMSafetyContentSecondDetail *secondDetail = content.sections[j];
            UIView *dotView=[[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(contentLable.frame)+secondHeight+(kLableHeight2-10)/2, 8, 8)];
            dotView.backgroundColor=NAVI_SECOND_COLOR;
            dotView.layer.cornerRadius=4.0;
            [view addSubview:dotView];
            UILabel *proLable =[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(contentLable.frame)+secondHeight,kLableWidthLeft,kLableHeight2)];
            proLable.backgroundColor=[UIColor clearColor];
            proLable.textAlignment=NSTextAlignmentCenter;
            proLable.font =[UIFont systemFontOfSize:14.0];
            proLable.text=@"检查项目";
            proLable.textColor=NAVI_SECOND_COLOR;
            [view addSubview:proLable];
            
            UILabel *proDetailLable =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(proLable.frame)+kLablePadding, proLable.frame.origin.y,kLableWidthRight,kLableHeight2)];
            proDetailLable.numberOfLines=0;
            proDetailLable.font =[UIFont systemFontOfSize:14.0];
            proDetailLable.text=secondDetail.name;
            proDetailLable.textColor=[UIColor lightGrayColor];
            [view addSubview:proDetailLable];
            
            CGFloat thirdHeight=0;
            for (int h=0; h<secondDetail.sections.count; h++) {
                
                SMSafetyContentThirdDetail *thirdDetail=secondDetail.sections[h];
                
                UILabel *issureLable =[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(proLable.frame)+thirdHeight,kLableWidthLeft,kLableHeight2)];
                issureLable.textAlignment=NSTextAlignmentCenter;
                issureLable.font =[UIFont systemFontOfSize:14.0];
                issureLable.text=@"检查问题";
                issureLable.textColor=[UIColor lightGrayColor];
                [view addSubview:issureLable];
                
                UILabel *issureDetailLable =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(issureLable.frame)+kLablePadding, issureLable.frame.origin.y,kLableWidthRight,kLableHeight2)];
                issureDetailLable.numberOfLines=0;
                issureDetailLable.font =[UIFont systemFontOfSize:14.0];
    
                issureDetailLable.text=thirdDetail.name;
   
                issureDetailLable.textColor=[UIColor lightGrayColor];
                [view addSubview:issureDetailLable];
                
                thirdHeight+=kLableHeight2;
                
                if (j==content.sections.count-1&&h==secondDetail.sections.count-1) {
                    firstHeight=CGRectGetMaxY(issureLable.frame);
                }
                
                if (i==firstArr.count-1&&j==content.sections.count-1&&h==secondDetail.sections.count-1) {
                    proHeight = CGRectGetMaxY(issureDetailLable.frame)+10;
                }
                
            }
            secondHeight+=thirdHeight+kLableHeight2;
        }
        
    }
    
    
    view.frame = CGRectMake(0, 0, WinWidth, proHeight);
    return view;
}

- (UIView *)listImageViewWithPicArr:(NSArray *)picArr WithTag:(NSInteger)tag{
    UIView *view=[[UIView alloc] init];
    CGFloat height=0;
    for (int i=0; i<picArr.count; i++) {
        int row=i/K_Count;
        int col=i%K_Count;
        
        int x=K_Orignx+(K_ImageWidth+K_Space)*col;
        int y=K_Orignx-10+(K_ImageWidth+K_Space)*row;
        
        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y,K_ImageWidth, K_ImageWidth)];
        imgView.tag=tag+i;
        [imgView sd_setImageWithURL:[NSURL URLWithString:picArr[i]] placeholderImage:[UIImage imageNamed:@"timeline_image_loading"]];
        [view addSubview:imgView];
        
        UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImgeView:)];
        imgView.userInteractionEnabled=YES;
        [imgView addGestureRecognizer:tapGesture];
        
        if (i==picArr.count-1) {
            height =CGRectGetMaxY(imgView.frame);
        }
    }
    view.frame = CGRectMake(0, 0, WinWidth, height+10);
    
    return  view;
}

- (void)showImgeView:(UITapGestureRecognizer *)tapGesture{
    UIImageView *imgView=(UIImageView *)tapGesture.view;
    
    NSArray *picArr=[self addHttpHeadToPic:@[self.checkImages.imagePath]];

    self.showImageView(picArr,imgView.tag-100);
    
}

- (NSArray *)addHttpHeadToPic:(NSArray  *)arr{
    NSMutableArray *picArr=[[NSMutableArray alloc] init];
    for (int i =0;  i<arr.count; i++) {
        NSString *str=arr[i];
        NSArray *tempArr=[str componentsSeparatedByString:@"|"];
        
        for (int i=0; i<tempArr.count; i++) {
            NSString *httpStr=kPort;
            httpStr = [httpStr stringByAppendingString:tempArr[i]];
            [picArr addObject:httpStr];
        }
        
    }
    return picArr;
}

-(void)removeSubViews{
    for (UIView *subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
}
@end
