//
//  SMSafetyCheckDetailSecondCell.m
//  PMP
//
//  Created by mac on 15/12/4.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMSafetyCheckDetailSecondCell.h"
#import "SMSafetyContent.h"
#import "SMAddImageCollectionViewCell.h"
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
@implementation SMSafetyCheckDetailSecondCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setInfoProLst:(Checkinfoproblemclasslist *)infoProLst andRecheckproblemlist:(Recheckproblemlist *)recheckProList{
    _infoProLst = infoProLst;
    _recheckProList = recheckProList;
    [self setUpFrame];
}

- (void)setUpFrame{
    [self removeSubViews];
    self.cellHeight = 0;
    UIView *view = [[UIView alloc] init];
    if (self.infoProLst) {
        if (self.infoProLst.imagePath.length) {
            
            UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 0.5)];
            lineView1.backgroundColor=k_LineColor;
            [view addSubview:lineView1];
            
            UILabel *piclable = [[UILabel alloc] initWithFrame:CGRectMake(16 , 0.5, WinWidth, kLableHeight)];
            piclable.text = @"检查图片";
            [view addSubview:piclable];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(piclable.frame), WinWidth, 0.5)];
            lineView.backgroundColor=k_LineColor;
            [view addSubview:lineView];
            
            NSMutableArray *picArr=[self addHttpHeadToPic:self.infoProLst.imagePath];
            UIView *picView = [self listImageViewWithPicArr:picArr];
            picView.top = CGRectGetMaxY(piclable.frame);
            
            [view addSubview:picView];
            self.cellHeight = CGRectGetMaxY(picView.frame);
           
            //判断是否是待处理
            if (self.state!=2) {
                
                UILabel *recheckLable = [[UILabel alloc] initWithFrame:CGRectMake(piclable.frame.origin.x, CGRectGetMaxY(picView.frame)+0.5, WinWidth, kLableHeight)];
                recheckLable.text=@"复查图片";
                [view addSubview:recheckLable];
                
                UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(picView.frame), WinWidth, 0.5)];
                lineView3.backgroundColor=k_LineColor;
                [view addSubview:lineView3];
                
                UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(recheckLable.frame), WinWidth, 0.5)];
                lineView4.backgroundColor=k_LineColor;
                [view addSubview:lineView4];
                
                [view addSubview:self.mediaView];
                self.mediaView.frame=CGRectMake(20,CGRectGetMaxY(lineView4.frame)+10, WinWidth-2*20,  [SMSafetyCheckDetailSecondCell SecondcellHeightWithObj:self.sendImageArr]);
                
                self.cellHeight = CGRectGetMaxY(self.mediaView.frame);
       
            }
            
            UIView *proView = [self problemViewWithArr:[self.infoProLst.checkInfoDetailList mutableCopy]];
            
            proView.top =self.cellHeight;
            
            self.cellHeight = CGRectGetMaxY(proView.frame);
            
            [view addSubview:proView];
            
        }else{
            UILabel *recheckLable = [[UILabel alloc] initWithFrame:CGRectMake(16, 0.5, WinWidth, kLableHeight)];
            recheckLable.text=@"复查图片";
            [view addSubview:recheckLable];
            
            UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 0.5)];
            lineView3.backgroundColor=k_LineColor;
            [view addSubview:lineView3];
            
            UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(recheckLable.frame), WinWidth, 0.5)];
            lineView4.backgroundColor=k_LineColor;
            [view addSubview:lineView4];
            
            //添加collectionView
            
          
            [SMSafetyCheckDetailSecondCell SecondcellHeightWithObj:self.sendImageArr];
         
            self.mediaView.frame=CGRectMake(20,CGRectGetMaxY(lineView4.frame)+10, WinWidth-2*20,  [SMSafetyCheckDetailSecondCell SecondcellHeightWithObj:self.sendImageArr]);
            [view addSubview:self.mediaView];
            
             self.cellHeight = CGRectGetMaxY(self.mediaView.frame);
            
            UIView *proView = [self problemViewWithArr:[self.infoProLst.checkInfoDetailList mutableCopy]];
            [view addSubview:proView];
            proView.top = self.cellHeight;
            self.cellHeight = CGRectGetMaxY(proView.frame);
        }
        view.frame = CGRectMake(0, 0, WinWidth, self.cellHeight);
        [self.contentView addSubview:view];
        
    }
}




- (UIView *)problemViewWithArr:(NSMutableArray *)arr{
    
    NSMutableArray *dateMutablearray=[[NSMutableArray alloc] init];
    for (int i = 0; i < arr.count; i ++) {
        Checkinfodetaillist *checkInfoDelist = arr[i];
        NSMutableArray *tempArray = [@[] mutableCopy];
        [tempArray addObject:checkInfoDelist];
        for (int j = i+1; j < arr.count; j ++) {
            Checkinfodetaillist *checkInfoDelist2 = arr[j];
            
            if([checkInfoDelist.checkContentId isEqualToString:checkInfoDelist2.checkContentId]){
                [tempArray addObject:checkInfoDelist2];
            }
        }
        [arr removeObjectsInArray:tempArray];
        i=-1;
        [dateMutablearray addObject:tempArray];
    }
    
    //    for (Checkinfodetaillist *checkInfoDelist2 in dateMutablearray.lastObject) {
    //        NSLog(@"%@",checkInfoDelist2.checkContentId);
    //    }
    
    NSMutableArray *firstArr=[[NSMutableArray alloc] init];
    for (int i=0; i<dateMutablearray.count;i++) {
        SMSafetyContent *content = [[SMSafetyContent alloc] init];
        NSArray *tempArr  =dateMutablearray[i];
        Checkinfodetaillist *detailList=tempArr.firstObject;
        content.classID =detailList.checkContentId;
        content.name = detailList.checkContentName;
        NSMutableArray *secondArr=[[NSMutableArray alloc] init];
        NSInteger classIndex=-1;
        for (Checkinfodetaillist *detailList1 in tempArr) {
            SMSafetyContentSecondDetail *secondDetail =[[SMSafetyContentSecondDetail alloc] init];
            if (classIndex==detailList1.checkItemId.integerValue) {
                continue;
            }else{
                secondDetail.name = detailList1.checkItemName;
                secondDetail.classID = detailList1.checkItemId;
                classIndex=detailList1.checkItemId.integerValue;
                NSMutableArray *thirdArr=[[NSMutableArray alloc] init];
                for (Checkinfodetaillist *detailList2 in tempArr) {
                    if ([detailList2.checkItemId isEqualToString:secondDetail.classID]) {
                        SMSafetyContentThirdDetail *thirdDetail = [[SMSafetyContentThirdDetail alloc] init];
                        if (detailList2.checkProblemId) {
                            thirdDetail.name =detailList2.checkProblemName;
                            thirdDetail.classID = detailList2.checkProblemId;
                        }else{
                            thirdDetail.name =detailList2.problemDesc;
                            thirdDetail.classID = @"-1";
                        }
                        [thirdArr addObject:thirdDetail];
                        NSLog(@"%@",thirdDetail.name);
                    }
                }
                secondDetail.sections = thirdArr;
                [secondArr addObject:secondDetail];
                
           }
            
        }
        content.sections = secondArr;
        [firstArr addObject:content];
    }
    
    //    for (SMSafetyContent *content in firstArr) {
    //        NSLog(@"%@",content.name);
    //    }
    
    UIView *view = [[UIView alloc] init];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, WinWidth, kLableHeight)];
    lable.text = @"检查问题";
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

- (UIView *)listImageViewWithPicArr:(NSArray *)picArr{
    UIView *view=[[UIView alloc] init];
    CGFloat height=0;
    for (int i=0; i<picArr.count; i++) {
        int row=i/K_Count;
        int col=i%K_Count;
        
        int x=K_Orignx+(K_ImageWidth+K_Space)*col;
        int y=K_Orignx-10+(K_ImageWidth+K_Space)*row;
        
        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y,K_ImageWidth, K_ImageWidth)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:picArr[i]] placeholderImage:[UIImage imageNamed:@"timeline_image_loading"]];
        imgView.tag=100+i;
        UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImgeView:)];
        imgView.userInteractionEnabled=YES;
        [imgView addGestureRecognizer:tapGesture];
        
        [view addSubview:imgView];
        if (i==picArr.count-1) {
            height =CGRectGetMaxY(imgView.frame);
        }
    }
    view.frame = CGRectMake(0, 0, WinWidth, height+10);
    
    return  view;
}

- (void)showImgeView:(UITapGestureRecognizer *)tapGesture{
    UIImageView *imgView=(UIImageView *)tapGesture.view;
    NSArray *picArr=[self addHttpHeadToPic:self.infoProLst.imagePath];

    self.showImageView(picArr,imgView.tag-100);
}

- (NSMutableArray *)addHttpHeadToPic:(NSString  *)str{
    NSArray *tempArr=[str componentsSeparatedByString:@"|"];
    NSMutableArray *picArr=[[NSMutableArray alloc] init];
    for (int i=0; i<tempArr.count; i++) {
        NSString *httpStr=kPort;
        httpStr =[httpStr stringByAppendingString:tempArr[i]];
        [picArr addObject:httpStr];
    }
    return picArr;
}

#pragma mark Collection M
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  [self.sendImageArr count] +1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    
    SMAddImageCollectionViewCell *ccell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ccell" forIndexPath:indexPath];
    if (indexPath.row==0) {
        ccell.curTweetImg = nil;
    }else{
        UIImage *curImage = [weakSelf.sendImageArr objectAtIndex:indexPath.row-1];
        ccell.curTweetImg = curImage;
        
        UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPhotoView:)];
        ccell.imgView.userInteractionEnabled=YES;
        ccell.imgView.tag = indexPath.row-1+1000;
        [ccell.imgView addGestureRecognizer:tapGesture];
    }
    
    //删除的方法
    ccell.deleteImageBlock = ^(UIImage *toDelete){
        
        [weakSelf.sendImageArr removeObject:toDelete];
        [weakSelf.mediaView reloadData];
        _deletateImageBlock();
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setFrame" object:self];
        
    };
    
    return ccell;
}

- (void)showPhotoView:(UITapGestureRecognizer *)tapGesture{
    UIImageView *imgView=(UIImageView *)tapGesture.view;
    self.showPhotoView(self.sendImageArr,imgView.tag-1000);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return [SMAddImageCollectionViewCell SecondccellSize];
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (self.sendImageArr.count >= 5) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多选择5张" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        if (_addImagesBlock) {
            _addImagesBlock();
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//直接 用UIimage对象
- (void)setCurTweet:(UIImage *)curTweet{
    //所有图片
    [self.mediaView setHeight:[SMSafetyCheckDetailSecondCell SecondcellHeightWithObj:self.sendImageArr]];
    [_mediaView reloadData];
}
- (void)updateImageCell
{
    //所有图片
    [self.mediaView setHeight:[SMSafetyCheckDetailSecondCell SecondcellHeightWithObj:self.sendImageArr]];
    [_mediaView reloadData];
}
+ (CGFloat)SecondcellHeightWithObj:(id)obj{
    CGFloat cellHeight = 0;
    
    //四个一排,原先他的项目是四个图片一排的，不过设置好宽度的话，三个一排之后，+号按钮也会显示在下一排里面
    
    if ([obj isKindOfClass:[NSArray class]]) {
        NSArray *arr = obj;
        NSInteger row = ceilf((float)([arr count] +1)/4.0);
        cellHeight = ([SMAddImageCollectionViewCell SecondccellSize].height + 10) *row ;
        
    }
    
    return cellHeight;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!self.mediaView) {
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.minimumLineSpacing=5;
            layout.minimumInteritemSpacing=5;
            
            self.mediaView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 10 , WinWidth-2*20,100) collectionViewLayout:layout];
            self.mediaView.scrollEnabled = NO;
            [self.mediaView setBackgroundView:nil];
            [self.mediaView setBackgroundColor:[UIColor clearColor]];
            [self.mediaView registerClass:[SMAddImageCollectionViewCell class] forCellWithReuseIdentifier:@"ccell"];
            self.mediaView.dataSource = self;
            self.mediaView.delegate = self;
            //[self.contentView addSubview:self.mediaView];
        }

        
        if (self.sendImageArr == nil) {
            self.sendImageArr = [NSMutableArray array];
        }
        
    }
    return self;
}

-(void)removeSubViews{
    for (UIView *subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
}

@end
