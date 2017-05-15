//
//  GetLocationView.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/5/9.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetLocationView : UIView
@property (nonatomic,strong)void (^block)(double  latitude,double longitude);
-(void)appear;
-(void)disAppear;

@end
