//
//  QianDaoView.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/4/26.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface QianDaoView : UIView

@property (nonatomic,strong)NSString * status;
@property (nonatomic,strong)void (^block)(NSInteger index);

-(void)appear;
-(void)disAppear;

@end
