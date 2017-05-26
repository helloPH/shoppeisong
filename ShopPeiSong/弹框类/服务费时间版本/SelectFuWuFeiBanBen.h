//
//  SelectFuWuFeiBanBen.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/5/23.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectFuWuFeiBanBen : UIView
@property (nonatomic,strong)NSMutableArray * datas;
@property (nonatomic,strong)void (^block)(NSDictionary *dic);
-(void)appear;
-(void)disAppear;
@end
