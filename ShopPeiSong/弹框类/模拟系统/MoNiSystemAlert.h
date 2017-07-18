//
//  MoNiSystemAlert.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/28.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoNiSystemAlert : UIView
@property (nonatomic,strong)NSString * title;
@property (nonatomic,strong)NSString * content;
-(void)appear;
-(void)disAppear;

@end
