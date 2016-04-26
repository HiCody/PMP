//
//  SMImage.m
//  PMP
//
//  Created by mac on 15/12/8.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMImage.h"

@implementation SMImage
+(UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end
