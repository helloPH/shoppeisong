//
//  ChangeImageView.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/20.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangeImageViewDelegate <NSObject>

-(void)changeImageWithIndex:(NSInteger)index;

@end
@interface ChangeImageView : UIView

@property(nonatomic,strong)id<ChangeImageViewDelegate>changeImageDelegate;
@end
