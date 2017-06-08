//
//  UIViewController+Helper.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/8.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "UIViewController+Helper.h"
#import "UIImageView+WebCache.h"
#import "Header.h"

@implementation UIViewController (Helper)
-(BOOL)isFirstLoad{
    if (![[NSUserDefaults standardUserDefaults]boolForKey:NSStringFromClass([self class])]) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:NSStringFromClass([self class])];
        return YES;
    };
    return NO;
}
-(UIImageView *)showGuideImageWithUrl:(NSString *)imgUrl{
    if (![self isFirstLoad]) {
        return nil;
    }
    
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HTTPHEADER,imgUrl]]];
    imgView.userInteractionEnabled=YES;
    imgView.alpha=0.9;
    
    [self.view addSubview:imgView];
    __weak UIImageView * weakImg = imgView;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:weakImg action:@selector(removeFromSuperview)];
    [imgView addGestureRecognizer:tap];
    return imgView;
}

@end
