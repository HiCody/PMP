//
//  PhotoBrowserViewController.m
//  PMP
//
//  Created by steve on 15/12/1.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "PhotoBrowserViewController.h"

@interface PhotoBrowserViewController ()

@end

@implementation PhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [self addImageView];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissViewController)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)addImageView{
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, H(100), WinWidth, WinHeight - H(200))];
    self.imageView.image = self.image;
    [self.view addSubview:self.imageView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)dismissViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
