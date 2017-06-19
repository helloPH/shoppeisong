//
//  UIViewController+Helper.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/8.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Helper)
-(BOOL)isFirstLoad;
-(UIImageView *)showGuideImageWithUrl:(NSString *)imgUrl;
+ (UIViewController *)presentingVC;
@end
