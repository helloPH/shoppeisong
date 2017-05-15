//
//  AddShangpingView.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/21.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddShangpingViewDelegate <NSObject>

//-(void)selectedLeibieAndBiaoqianWithIndex:(NSInteger)index;

@end
@interface AddShangpingView : UIView

@property(nonatomic,strong)NSString *dianpuID;
@property(nonatomic,strong)id<AddShangpingViewDelegate>addDelegate;
@end
