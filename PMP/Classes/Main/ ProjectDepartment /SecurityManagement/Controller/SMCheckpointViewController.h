//
//  SMCheckpointViewController.h
//  PMP
//
//  Created by mac on 15/12/22.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCheckpointModel.h"
@interface SMCheckpointViewController : UIViewController

@property(nonatomic,copy)void(^passValue)(SMCheckpointModel *);

@property(nonatomic,strong)SMCheckpointModel *checkpoint;

@end
