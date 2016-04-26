//
//  SMCheckIssureCell.h
//  PMP
//
//  Created by mac on 15/12/2.
//  Copyright © 2015年 mac. All rights reserved.
//
typedef NS_OPTIONS(NSUInteger, MultiSelectTableViewSelectState) {
    MultiSelectTableViewSelectStateNoSelected = 0,
    MultiSelectTableViewSelectStateSelected,
};

#import <UIKit/UIKit.h>

@interface SMCheckIssureCell : UITableViewCell
@property (strong, nonatomic)  UIImageView *selectImageView;
@property(nonatomic,strong)UILabel *nameLable;
@property(nonatomic,strong)NSString *title;
@property (nonatomic, assign) MultiSelectTableViewSelectState selectState;

@property(nonatomic,assign)CGFloat cellHeight;//cell的高度
@end
