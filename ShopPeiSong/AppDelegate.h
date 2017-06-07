//
//  AppDelegate.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/6.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)endBgTask;
- (void)beginBgTask;
- (void)switchRootController;
@end

