//
//  YanzhengShenfenzhengView.h
//  GoodYeWu
//
//  Created by MIAO on 2017/2/28.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@protocol YanzhengShenfenzhengViewDelegate <NSObject>

-(void)YanzhengShenfenzhengViewSuccess;
@end
@interface YanzhengShenfenzhengView : UIView<MBProgressHUDDelegate>
@property(nonatomic,strong)id<YanzhengShenfenzhengViewDelegate>shenfenzhengDelegate;
@end
