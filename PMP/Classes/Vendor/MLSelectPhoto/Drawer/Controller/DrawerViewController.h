//
//  DrawerViewController.h
//  PMP
//
//  Created by mac on 16/1/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawerViewController : UIViewController

@property(nonatomic,strong)UIImage *doodleImage;


@property(nonatomic,copy)void(^passImage)(UIImage *);
@end







