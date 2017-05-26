//
//  NumberPassWordView.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/5/24.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumberPassWordView : UIView
@property (nonatomic,strong)void (^block)(NSString * passWord);
-(void)appear;
-(void)disAppear;
@end
