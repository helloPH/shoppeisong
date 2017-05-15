//
//  FujiafeiView.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/22.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FujiafeiViewDelegate <NSObject>

-(void)saveFujiafeiWithName:(NSString *)fujiafeiName AndMoney:(NSString *)fujiafeiMoney;

@end
@interface FujiafeiView : UIView
@property(nonatomic,strong)id<FujiafeiViewDelegate>fujiafeiDelegate;
@end
