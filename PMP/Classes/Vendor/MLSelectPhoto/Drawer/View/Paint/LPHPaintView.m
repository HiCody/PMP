//
//  LPHPaintView.m
//  小画板2
//
//  Created by Mac on 15/12/21.
//  Copyright © 2015年 Mac. All rights reserved.
//

#import "LPHPaintView.h"
#import "LPHBezierPath.h"

@interface LPHPaintView()



@end


@implementation LPHPaintView


-(void)clearScreen{

    [self.paints removeAllObjects];
    
    [self setNeedsDisplay];

}

-(void)backspace{

    [self.paints removeLastObject];
    
    [self setNeedsDisplay];
    
    if (self.paints.count==1) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"btnEnable" object:@"0"];
    }

}

-(void)erasure{

    self.lineColor=[[UIColor alloc]initWithPatternImage:self.pickedImage];

}




#pragma mark - 数组懒加载

-(NSMutableArray *)paints{

    if (_paints==nil) {
        
        _paints=[NSMutableArray array];
        
    }

    return _paints;

}



#pragma mark - 手指点击事件

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    //获取对象
    UITouch * toch =touches.anyObject;
    //获取点击点
    
    CGPoint loc =[toch locationInView:toch.view];
    
    //创建路径对象
    
    LPHBezierPath * path =[[LPHBezierPath alloc] init];
    
    [path moveToPoint:loc];
    
    //设置线条颜色
    
    path.lineColor=self.lineColor;
    
    //设置线宽
    path.lineWidth=self.lineWidth;
    
    //把路径对象添加到数组中

    [self.paints addObject:path];
    
    if (self.paints.count) {
          [[NSNotificationCenter defaultCenter] postNotificationName:@"btnEnable" object:@"1"];
    }
  
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

   //获取当前触摸点
    
    UITouch * toch =touches.anyObject;
    
    CGPoint loc =[toch locationInView:toch.view];
    
    LPHBezierPath * path =[self.paints lastObject];
    
    [path addLineToPoint:loc];
    
    
    //重绘
    
    [self setNeedsDisplay];

}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    for (LPHBezierPath * path  in self.paints) {
        
        //设置线条圆角
        path.lineCapStyle=kCGLineCapRound;
        
        //设置链接处
        
        path.lineJoinStyle=kCGLineJoinRound;
        
        //渲染
        
        [path.lineColor set];
        
        if (path.image) {
            
            [path.image drawAtPoint:CGPointZero];
            
        }else{
        
            [path stroke];
        
        }
        
    }
    
    
    
}

-(void)setPickedImage:(UIImage *)pickedImage{

    _pickedImage=pickedImage;
    
    //创建一个路径对象
    
    LPHBezierPath * path =[[LPHBezierPath alloc] init];
    
    path.lineColor = [UIColor redColor];
    NSLog(@"111");
    path.image=pickedImage;
    
    [self.paints addObject:path];
    
    //重写渲染
    [self setNeedsDisplay];

}


@end
