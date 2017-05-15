//
//  AutographView.h
//  GoodYeWu
//
//  Created by MIAO on 2017/2/20.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AutographViewDelegate <NSObject>

-(void)setImageWithIndex:(NSInteger )index WithDict:(NSDictionary *)dict;

@end
@interface AutographView : UIView

@property(nonatomic,strong)id<AutographViewDelegate>autoDelegate;

@property (nonatomic,strong)void (^Block)(NSInteger index,NSDictionary * dict);
-(void)appear;
-(void)disAppear;
@end
