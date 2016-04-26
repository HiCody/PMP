//
//  BCSMAddSafetyCheckTableViewCell.m
//  PMP
//
//  Created by mac on 16/1/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "BCSMAddSafetyCheckTableViewCell.h"
#import "SMAddImageCollectionViewCell.h"
#define kCCellIdentifier_TweetSendImage @"SecondTweetSendImageCCell"

#define kLableHeight  50
#define K_ImageWidth  floorf((WinWidth-20*2- 10*3)/4)
#define K_Count 4
#define K_Space 5
#define K_Orignx 20

#define k_LineColor [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0]


#define kLableHeight2 38
#define kLableWidthLeft W(100)
#define kLableWidthRight W(200)
#define kLablePadding  15

@implementation BCSMAddSafetyCheckTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setCheckPointName:(NSString *)checkPointName{
    _checkPointName = checkPointName;
     [self setUpFrame];
}


- (void)setUpFrame{
    [self removeSubViews];
    
    UIView *view = [[UIView alloc] init];
//    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 0.5)];
//    lineView1.backgroundColor=k_LineColor;
//    [view addSubview:lineView1];
 
    //检查部位
    UILabel *piclable = [[UILabel alloc] initWithFrame:CGRectMake(16 , 0.5, WinWidth, kLableHeight)];
    piclable.text = self.checkPointName;
    [view addSubview:piclable];
    
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(WinWidth-80,0 , 50, kLableHeight)];
    deleteBtn.tag=500;
    deleteBtn.titleLabel.font=[UIFont systemFontOfSize:15.0];
    [deleteBtn setTitleColor:[UIColor colorWithRed:41/255.0 green:163/255.0 blue:226/255.0 alpha:1.0] forState:UIControlStateNormal];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [deleteBtn addTarget:self action:@selector(deleteWhole:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:deleteBtn];

    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(piclable.frame), WinWidth, 0.5)];
    lineView.backgroundColor=k_LineColor;
    [view addSubview:lineView];
    
    //图片添加
    [BCSMAddSafetyCheckTableViewCell SecondcellHeightWithObj:self.sendImageArr];
    
    self.mediaView.frame=CGRectMake(20,CGRectGetMaxY(lineView.frame)+10, WinWidth-2*20,  [BCSMAddSafetyCheckTableViewCell SecondcellHeightWithObj:self.sendImageArr]);
    [view addSubview:self.mediaView];
    
    self.cellHeight = CGRectGetMaxY(self.mediaView.frame);
    
    //检查问题添加
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mediaView.frame), WinWidth, 0.5)];
    lineView3.backgroundColor=k_LineColor;
    [view addSubview:lineView3];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(lineView3.frame), WinWidth, kLableHeight)];
    lable.text = @"检查问题";
    [view addSubview:lable];
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lable.frame), WinWidth, 0.5)];
    lineView2.backgroundColor=k_LineColor;
    [view addSubview:lineView2];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(WinWidth-80,self.cellHeight , 50, 55.0)];
    btn.tag=50;
    btn.titleLabel.font=[UIFont systemFontOfSize:15.0];
    [btn setTitleColor:[UIColor colorWithRed:41/255.0 green:163/255.0 blue:226/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btn setTitle:@"添加" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [btn addTarget:self action:@selector(checkIssure:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    self.cellHeight = CGRectGetMaxY(lineView2.frame);
    
    for (int i=0;i<self.contentArr.count;i++) {
        SMSafetyContent *content = self.contentArr[i];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(WinWidth-105, self.cellHeight , 105, 40)];
        btn.tag = 1000+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitle:@"删除" forState:UIControlStateNormal];
        [btn setTitleColor:NAVI_SECOND_COLOR forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(deletePro:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        UIView *proView = [self problemViewWithSafetyContent:content];
        [view addSubview:proView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPro:)];
        
        [proView addGestureRecognizer:tapGesture];
        proView.tag = 500+i;
        
        proView.top = self.cellHeight+25;
        self.cellHeight = CGRectGetMaxY(proView.frame);
        
        if (i!=self.contentArr.count) {
            UIView *lineView5 = [[UIView alloc] initWithFrame:CGRectMake(0,  self.cellHeight-0.5, WinWidth, 0.5)];
            lineView5.backgroundColor=k_LineColor;
            [view addSubview:lineView5];
        }
   
    }
   
  
    view.frame = CGRectMake(0, 0, WinWidth, self.cellHeight);
    [self.contentView addSubview:view];
    
}

- (void)deleteWhole:(UIButton *)btn{
    
    self.deleteAll();
    
}

- (void)editPro:(UITapGestureRecognizer *)tapGesture{
    UIView *view =  tapGesture.view;
    SMSafetyContent *content = self.contentArr[view.tag- 500];
    self.editProblem(content);
}

- (void)deletePro:(UIButton *)btn{
    SMSafetyContent *cotent = self.contentArr[btn.tag-1000];
     self.deleteProCell(cotent);
    
}

- (void)checkIssure:(UIButton *)btn{
    
    self.addProblem();
    
}

- (UIView *)problemViewWithSafetyContent:(SMSafetyContent *)safetyContent{
    
    UIView *view = [[UIView alloc] init];
    
    CGFloat proHeight = 0;
    
    SMSafetyContent *content=safetyContent;
    
    UILabel *contentLable =[[UILabel alloc] initWithFrame:CGRectMake(15,0, kLableWidthLeft, kLableHeight2)];
    
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
    if (content.sections.count) {
        for (int j=0; j<content.sections.count; j++) {
            SMSafetyContentSecondDetail *secondDetail = content.sections[j];
            if (!secondDetail.isOpen) {
                continue;
            }
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
            if (secondDetail.sections.count) {
                for (int h=0; h<secondDetail.sections.count; h++) {
                    
                    SMSafetyContentThirdDetail *thirdDetail=secondDetail.sections[h];
                    if (!thirdDetail.isOpen) {
                        continue;
                    }
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
                    
                    
                    proHeight = CGRectGetMaxY(issureDetailLable.frame)+10;
                    
                    
                }
            }
            
            secondHeight+=thirdHeight+kLableHeight2;
            
        }
        
    }
    UIImageView *img =[[UIImageView alloc]initWithFrame:CGRectMake(WinWidth-20,(proHeight-15)/2, 15, 15)];
    img.image = [UIImage imageNamed:@"arrow_right.png"];
    img.contentMode =NSTextAlignmentRight;
    img.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:img];
    
    
    view.frame = CGRectMake(0, 0, WinWidth, proHeight);
    return view;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        
        if (!self.mediaView) {
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.minimumLineSpacing=5;
            layout.minimumInteritemSpacing=5;
            
            self.mediaView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 10 , WinWidth-2*20,0) collectionViewLayout:layout];
            self.mediaView.scrollEnabled = NO;
            [self.mediaView setBackgroundView:nil];
            [self.mediaView setBackgroundColor:[UIColor whiteColor]];
            [self.mediaView registerClass:[SMAddImageCollectionViewCell class] forCellWithReuseIdentifier:kCCellIdentifier_TweetSendImage];
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

//直接 用UIimage对象
- (void)setCurTweet:(UIImage *)curTweet{
    //所有图片
    [self.mediaView setHeight:[BCSMAddSafetyCheckTableViewCell SecondcellHeightWithObj:self.sendImageArr]];
    [_mediaView reloadData];
}

- (void)updateImageCell
{
    //所有图片
    [self.mediaView setHeight:[BCSMAddSafetyCheckTableViewCell SecondcellHeightWithObj:self.sendImageArr]];
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

#pragma mark Collection M
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  [self.sendImageArr count] +1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    
    SMAddImageCollectionViewCell *ccell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellIdentifier_TweetSendImage forIndexPath:indexPath];
    if (indexPath.row==0) {
        ccell.curTweetImg = nil;
    }else{
        
        UIImage *curImage = [weakSelf.sendImageArr objectAtIndex:indexPath.row-1];
        ccell.curTweetImg = curImage;
        
        UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImgeView:)];
        ccell.imgView.userInteractionEnabled=YES;
        ccell.imgView.tag = indexPath.row-1+100;
        [ccell.imgView addGestureRecognizer:tapGesture];
        
    }
    
    //删除的方法
    ccell.deleteImageBlock = ^(UIImage *toDelete){
        
        [weakSelf.sendImageArr removeObject:toDelete];
        [weakSelf.mediaView reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setFrame" object:self];
        _deletateImageBlock();
    };
    
    return ccell;
}

- (void)showImgeView:(UITapGestureRecognizer *)tapGesture{
    UIImageView *imgView=(UIImageView *)tapGesture.view;
    self.showImageView(self.sendImageArr,imgView.tag-100);
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

-(void)removeSubViews{
    for (UIView *subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
}


@end
