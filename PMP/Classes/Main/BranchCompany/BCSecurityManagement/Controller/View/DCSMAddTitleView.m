//
//  DCSMAddTitleView.m
//  PMP
//
//  Created by mac on 16/1/12.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "DCSMAddTitleView.h"
#import "BCSMSpotCheckListViewController.h"
@implementation DCSMAddTitleView


+ (instancetype)addTitleView{
    return [[NSBundle mainBundle] loadNibNamed:@"DCSMAddTitleView" owner:nil options:nil].lastObject;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame ]) {
        
    }
   
    return self;
}


- (IBAction)spotChecks:(id)sender {
    NSLog(@"%@",@"2015-01-17 go go go");

}



- (IBAction)collapse:(id)sender {
    
    
}

- (IBAction)moreContacts:(id)sender {
    
}
- (IBAction)detailed:(id)sender {
    
    
}

- (IBAction)secondCollaose:(id)sender {
    
}

//收回键盘的方法

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  {
    [self  endEditing:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}



@end
