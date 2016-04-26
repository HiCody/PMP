//
//  BCSMAddSafetyCheckTableViewCell.h
//  PMP
//
//  Created by mac on 16/1/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSafetyContent.h"
@interface BCSMAddSafetyCheckTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate>

@property (nonatomic, strong) NSMutableArray *sendImageArr;

@property (strong, nonatomic) UICollectionView *mediaView;

@property(nonatomic,strong)NSString *checkPointName;

//@property(nonatomic,strong)SMSafetyContent *content;
@property(nonatomic,strong)NSArray *contentArr;

@property(nonatomic,assign)CGFloat cellHeight;

@property (nonatomic, copy) void(^addImagesBlock)();//不带参数

@property(nonatomic,copy)void(^deletateImageBlock)();

@property(nonatomic,copy)void(^showImageView)(NSArray *,NSInteger);

@property(nonatomic,copy)void(^addProblem)();

@property(nonatomic,copy) void(^deleteProCell)(SMSafetyContent *);

@property(nonatomic,copy)void(^editProblem)(SMSafetyContent *);

@property(nonatomic,copy)void(^deleteAll)();

- (void)updateImageCell;

+ (CGFloat)SecondcellHeightWithObj:(id)obj;

@end
