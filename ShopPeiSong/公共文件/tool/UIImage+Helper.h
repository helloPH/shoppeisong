//
//  UIImage+Helper.h
//  TuLing
//
//  Created by apple on 15-2-3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(Helper)
/*
 *颜色这转为图片
 */
+(UIImage *)ImageForColor:(UIColor *)color;
/*
 *模糊图片
 */
+(UIImage *)blurryImage:(UIImage *)image
           withBlurLevel:(CGFloat)blur;
/* blur the current image with a box blur algoritm */
- (UIImage*)drn_boxblurImageWithBlur:(CGFloat)blur;

/* blur the current image with a box blur algoritm and tint with a color */
- (UIImage*)drn_boxblurImageWithBlur:(CGFloat)blur withTintColor:(UIColor*)tintColor;

+(UIImage *)setImgNameBianShen:(NSString *)Img;

/* 图片大小 */
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
/*
 *获取图片某个点的RGBA值
 */
+(NSMutableArray *)getImagePixel:(UIImage *)image point:(CGPoint)apoint;
/*
 *压缩图片 压缩后最多只有100k
 */
+(UIImage *) scaleImage: (UIImage *)image;
/*
 *获取当前屏幕截图
 */
+(UIImage *) getScreenShot;

@end
