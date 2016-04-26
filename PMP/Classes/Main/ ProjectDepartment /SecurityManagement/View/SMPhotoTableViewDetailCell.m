//
//  SMPhotoTableViewDetailCell.m
//  PMP
//
//  Created by mac on 15/12/1.
//  Copyright © 2015年 mac. All rights reserved.
//
#import "SMPhotoTableViewDetailCell.h"
#import "SMPhotoItem.h"
#define K_Orignx 10
#define K_ImageWidth  W(70)
#define K_ImageHeight W(70)
#define K_Count 4
#define K_Space (WinWidth-K_Orignx*2-K_ImageWidth*K_Count)/(K_Count-1)
@implementation SMPhotoTableViewDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(void)setDetailList:(NSArray *)detailList{
    [self removeSubViews];//因为复用cell的关系，移除之前正在被复用的cell中的视图，然后通过代码重新给cell添加子视图
    _detailList=detailList;
    NSInteger detailCount=_detailList.count;
    for (int i=0; i<detailCount; i++) {
        int row=i/K_Count;
        int col=i%K_Count;
        
        int x=K_Orignx+(K_ImageWidth+K_Space)*col;
        int y=10+K_Orignx+(K_ImageHeight+K_Space+20)*row;
        
        
        Resultlist  *list=_detailList[i];
        
        UIImageView *imgView =[[UIImageView alloc] initWithFrame:CGRectMake(x, y, K_ImageWidth, K_ImageHeight)];
        imgView.userInteractionEnabled=YES;
        if (list.fileType==1) {
            NSString *str = [NSString stringWithFormat:@"%@%@",kPort,list.thumbnailPath];
             str=[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSURL *url =[NSURL URLWithString:str];
            
            [imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"timeline_image_loading"]];
            
        }else if(list.fileType==2){
            
            imgView.image = [UIImage imageNamed:@"attachment_img_file_doc"];
        }else if(list.fileType==3){
            
            imgView.image = [UIImage imageNamed:@"attachment_img_file_xls"];
            
        }else if(list.fileType==4){
            
            imgView.image = [UIImage imageNamed:@"attachment_img_file_zip"];
        }
        
        [self.contentView addSubview:imgView];
        
        imgView.tag =i;
        
        UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reviewPhoto:)];
        
        [imgView addGestureRecognizer:tapGesture];
        
        UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(x, CGRectGetMaxY(imgView.frame)+4, K_ImageWidth, 15)];
        nameLable.text = list.fileName;
        nameLable.lineBreakMode = NSLineBreakByTruncatingMiddle;
        nameLable.font  =[UIFont systemFontOfSize:14.0];
        nameLable.textColor = [UIColor lightGrayColor];
        nameLable.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:nameLable];

        if (i==detailCount-1) {
            
            _cellHeight=CGRectGetMaxY(nameLable.frame)+K_Orignx+5;
            
        }
    }
}


-(void)removeSubViews{
    for (UIView *subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
}

- (void)reviewPhoto:(UITapGestureRecognizer *)gesture{
    UIImageView *imageView = (UIImageView *)gesture.view;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kSMPhoto" object:imageView];
}




@end
