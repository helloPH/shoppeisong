//
//  KaiHuChengGongView.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/7/14.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KaiHuChengGongView : UIView
@property (nonatomic,strong)void (^block)();
-(void)appear;
-(void)disAppear;
@end
