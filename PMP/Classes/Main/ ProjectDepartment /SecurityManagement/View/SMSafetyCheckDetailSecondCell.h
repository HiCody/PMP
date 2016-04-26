//
//  SMSafetyCheckDetailSecondCell.h
//  PMP
//
//  Created by mac on 15/12/4.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMIssureDetailModel.h"

@interface SMSafetyCheckDetailSecondCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong)Checkinfoproblemclasslist  *infoProLst;
@property(nonatomic,strong)Recheckproblemlist *recheckProList;

@property(nonatomic,assign)CGFloat cellHeight;

@property(nonatomic,assign)NSInteger state;

@property (nonatomic, strong) NSMutableArray *sendImageArr;

@property (strong, nonatomic) UICollectionView *mediaView;

@property (nonatomic, copy) void(^addImagesBlock)();//不带参数

@property(nonatomic,copy)void(^deletateImageBlock)();

@property(nonatomic,copy)void(^showImageView)(NSArray *,NSInteger);

@property(nonatomic,copy)void(^showPhotoView)(NSArray *,NSInteger);
- (void)updateImageCell;

+ (CGFloat)SecondcellHeightWithObj:(id)obj;

- (void)setInfoProLst:(Checkinfoproblemclasslist *)infoProLst andRecheckproblemlist:(Recheckproblemlist *)recheckProList;

@end
