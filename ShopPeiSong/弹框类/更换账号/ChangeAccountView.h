//
//  ChangeAccountView.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/27.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeAccountView : UIView
@property (nonatomic,strong)void (^block)(NSString * string);

-(void)appear;
-(void)disAppear;
@end
