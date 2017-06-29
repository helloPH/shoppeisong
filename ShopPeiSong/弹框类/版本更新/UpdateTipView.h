//
//  UpdateTipView.h
//  LifeForMM
//
//  Created by HUI on 16/3/17.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UpdateTipView;

@interface UpdateTipView : UIView



@property (nonatomic,strong)NSString * content;

@property (nonatomic,strong)void (^block)(NSInteger index);


-(void)appear;
-(void)disAppear;
@end
