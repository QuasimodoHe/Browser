//
//  UIImage+UIImageExtras.m
//  六合神坛
//
//  Created by  Quan He on 2017/7/22.
//  Copyright © 2017年 f. All rights reserved.
//

#import "UIImage+UIImageExtras.h"

@implementation UIImage (UIImageExtras)
- (UIImage *)imageByScalingToSize:(CGSize)targetSize
{
        UIGraphicsBeginImageContext(targetSize);
        [self drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
        UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    
        return scaledImage;
}


@end
