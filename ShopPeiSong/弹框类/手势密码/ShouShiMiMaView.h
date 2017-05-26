//
//  ShouShiMiMaView.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/5/25.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShouShiMiMaView : UIView
@property (nonatomic,strong)void (^passBlock)(NSString * passWord);
@property (nonatomic,strong)NSString * passWord;
-(void)setTitle:(NSString *)title;
-(void)appear;
-(void)disAppear;
@end
