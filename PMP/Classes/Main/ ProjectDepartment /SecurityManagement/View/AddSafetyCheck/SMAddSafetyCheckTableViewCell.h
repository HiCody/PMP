//
//  AddSafetyCheckTableViewCell.h
//  PMP
//
//  Created by 顾佳洪 on 15/12/1.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMAddSafetyCheckTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate>

@property (nonatomic, strong) NSMutableArray *sendImageArr;
@property (strong, nonatomic) UICollectionView *mediaView;
@property (nonatomic, copy) void(^addImagesBlock)();//不带参数

@property(nonatomic,strong)NSArray *itemArr;

@property(nonatomic,assign)CGFloat cellHeight;

@property(nonatomic,copy)void(^deletateImageBlock)();

@property(nonatomic,copy)void(^showImageView)(NSArray *,NSInteger);

@property(nonatomic,assign)NSInteger proInTeger;

- (void)updateImageCell;

+ (CGFloat)SecondcellHeightWithObj:(id)obj;

@end
