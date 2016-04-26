//
//  SMSafetyCheckShowView.h
//  PMP
//
//  Created by mac on 15/12/2.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SMSafetyCheckShowViewDelegate <NSObject>

@required

-(void)SMSafetyCheckShowViewFinishedPickkingFilter:(NSArray *)Filter;

-(void)SMSafetyCheckShowViewCancelled;

@end

@interface SMSafetyCheckShowView : UIView
@property (nonatomic,assign) id<SMSafetyCheckShowViewDelegate> delegate;
@property(nonatomic,strong)NSArray *dataArr;

@end
