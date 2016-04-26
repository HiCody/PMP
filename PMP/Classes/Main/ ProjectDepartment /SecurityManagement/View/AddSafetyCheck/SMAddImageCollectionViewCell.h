//
//  SMAddImageCollectionViewCell.h
//  PMP
//
//  Created by 顾佳洪 on 15/12/1.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMAddImageCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIImage *curTweetImg;//暂不采用对象封装image
@property (nonatomic, copy) void (^deleteImageBlock)(UIImage *toDelete);
+(CGSize)SecondccellSize;
@end
