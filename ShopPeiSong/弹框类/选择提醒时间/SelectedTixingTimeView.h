//
//  SelectedTixingTimeView.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/20.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedTixingTimeView : UIView
@property (nonatomic,strong)void (^block)(BOOL isSuccess);
-(void)appear;
-(void)disAppear;
@end
