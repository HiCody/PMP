//
//  SMAddImageCollectionViewCell.m
//  PMP
//
//  Created by 顾佳洪 on 15/12/1.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMAddImageCollectionViewCell.h"
#import "UIImage+Common.h"
#define kTweetSendImageCCell_Width floorf((WinWidth-20*2- 10*3)/4)
@implementation SMAddImageCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setCurTweetImg:(UIImage *)curTweetImg{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kTweetSendImageCCell_Width, kTweetSendImageCCell_Width)];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
        _imgView.layer.masksToBounds = YES;
        _imgView.layer.cornerRadius = 2.0;
        [self.contentView addSubview:_imgView];
    }
    _curTweetImg = curTweetImg;
    if (_curTweetImg) {
        _imgView.image = [_curTweetImg scaledToSize:_imgView.bounds.size highQuality:YES];
        if (!_deleteBtn) {
            _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(kTweetSendImageCCell_Width-20, 0, 20, 20)];
            [_deleteBtn setImage:[UIImage imageNamed:@"icon-close"] forState:UIControlStateNormal];
           
            [_deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.contentView addSubview:_deleteBtn];
        }
    
        _deleteBtn.hidden = NO;
    }else{
        _imgView.image = [UIImage imageNamed:@"upimg"];
        if (_deleteBtn) {
            _deleteBtn.hidden = YES;
        }
    }
}
- (void)deleteBtnClicked:(id)sender{
    if (_deleteImageBlock) {
        _deleteImageBlock(_curTweetImg);
    }
}
+(CGSize)SecondccellSize{
    return CGSizeMake(kTweetSendImageCCell_Width, kTweetSendImageCCell_Width);
}


@end
