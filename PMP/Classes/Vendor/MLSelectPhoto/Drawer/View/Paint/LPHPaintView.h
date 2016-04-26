//
//  LPHPaintView.h
//  小画板2
//
//  Created by Mac on 15/12/21.
//  Copyright © 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPHPaintView : UIView

@property(nonatomic,strong)UIColor * lineColor;

@property(nonatomic,assign)CGFloat lineWidth;

@property(nonatomic,strong)UIImage * pickedImage;

@property(nonatomic,strong)NSMutableArray * paints;

//清屏
-(void)clearScreen;

//回退
-(void)backspace;

//檫除

-(void)erasure;

@end
