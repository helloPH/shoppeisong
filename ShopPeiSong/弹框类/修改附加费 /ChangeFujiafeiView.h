//
//  ChangeFujiafeiView.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/4/12.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangeFujiafeiViewDelegate <NSObject>

-(void)changeFujiafeiSuccessWithMoney:(NSString *)money AndIndex:(NSInteger)index;

@end
@interface ChangeFujiafeiView : UIView
@property(nonatomic,strong)UITextField *moneyTextField;
@property(nonatomic,strong)NSString *danhaoStr;
@property(nonatomic,assign)float buchaMoney;

@property(nonatomic,strong)id<ChangeFujiafeiViewDelegate>changeFujiaDelegate;
-(void)getFujiafeiMoney:(NSString *)fujiafeiMoney AndViewTag:(NSInteger)viewTag;
@end
