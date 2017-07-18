//
//  CaptchaTimerManager.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/7/10.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaptchaTimerManager : NSObject

@property (nonatomic, assign)__block int timeout;

+ (id)sharedTimerManager;

- (void)countDown;

@end
