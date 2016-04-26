//
//  SMAddSafetyCheckCell.h
//  PMP
//
//  Created by mac on 15/12/2.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_OPTIONS(NSUInteger, MultiSelectTableViewSelectState) {
    MultiSelectTableViewSelectStateNoSelected = 0,
    MultiSelectTableViewSelectStateSelected,
};
@interface SMAddSafetyCheckCell : UITableViewCell
@property(nonatomic,strong)UILabel *nameLable;

@property (strong, nonatomic)  UIImageView *selectImageView;

@property (nonatomic, assign) MultiSelectTableViewSelectState selectState;
@end
