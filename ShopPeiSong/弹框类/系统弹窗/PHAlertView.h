//
//  PHAlertView.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/2.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHAlertView : UIAlertView<UIAlertViewDelegate>
@property (nonatomic,strong)void(^block)(NSInteger index);

@end
