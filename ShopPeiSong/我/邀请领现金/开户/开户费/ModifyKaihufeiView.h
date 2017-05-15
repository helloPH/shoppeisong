//
//  ModifyKaihufeiView.h
//  GoodYeWu
//
//  Created by MIAO on 16/11/17.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModifyKaihufeiViewDelegate <NSObject>

-(void)modifyKaihufeiWithString:(NSString *)string;

@end

@interface ModifyKaihufeiView : UIView
@property(nonatomic,strong)id<ModifyKaihufeiViewDelegate>modefyDelegate;


@end
