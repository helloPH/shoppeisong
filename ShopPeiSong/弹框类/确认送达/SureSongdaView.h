//
//  SureSongdaView.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/23.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SureSongdaViewDelegate <NSObject>

-(void)sureSongdaSuccessWithDanhao:(NSString *)danhao;

@end
@interface SureSongdaView : UIView
@property(nonatomic,strong)NSString *danhao;
@property(nonatomic,strong)id<SureSongdaViewDelegate>songdaDelegate;

@end
