//
//  BaseNavigationController.m
//  PMP
//
//  Created by mac on 15/11/30.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "BaseNavigationController.h"

@implementation BaseNavigationController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(void)initialize{
    
    UINavigationBar *naviBar=[UINavigationBar appearance];
    naviBar.tintColor=[UIColor whiteColor];
    naviBar.barTintColor=[UIColor colorWithHexString:Navi_hexcolor];
    //   // [naviBar setBackgroundImage:[UIImage imageNamed:bgImage] forBarMetrics:UIBarMetricsDefault];
    
    
    NSMutableDictionary *attrs=[[NSMutableDictionary alloc]init];
    attrs[NSForegroundColorAttributeName]=[UIColor whiteColor];
    attrs[NSFontAttributeName]=[UIFont boldSystemFontOfSize:17];
    [naviBar setTitleTextAttributes:attrs];
    
    
    UIBarButtonItem *item=[UIBarButtonItem appearance];
    NSMutableDictionary *attrs1=[[NSMutableDictionary alloc]init];
    attrs1[NSForegroundColorAttributeName]=[UIColor whiteColor];
    attrs1[NSFontAttributeName]=[UIFont systemFontOfSize:16];
    [item setTitleTextAttributes:attrs1 forState:UIControlStateNormal];
    
   UIImage *backButtonImage = [[UIImage imageNamed:@"login_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [item setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    
    //将返回按钮的文字position设置不在屏幕上显示
//    [item setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];

}


//-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    viewController.hidesBottomBarWhenPushed=YES;
//
//    [super pushViewController:viewController animated:animated];
//}


@end
