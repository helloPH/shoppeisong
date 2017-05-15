//
//  CheckShangpinView.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/22.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckShangpinView : UIView
@property(nonatomic,strong)NSString *dianpuID;
-(void)getShangpinMessagesDataWithshangpinId:(NSString *)shangpinID;
@end
