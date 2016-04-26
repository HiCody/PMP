//
//  PopMenuTableView.h
//  PMP
//
//  Created by mac on 15/12/7.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopMenuDelegate<NSObject>

- (void)openWithTitle:(NSString *)title;


@end

@interface PopMenuTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSArray *arr;

@property(nonatomic,weak)id<PopMenuDelegate>menuDelegate;


@end
