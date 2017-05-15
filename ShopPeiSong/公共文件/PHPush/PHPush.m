//
//  PHPush.m
//  PHPackAge
//
//  Created by MIAO on 2017/5/4.
//  Copyright © 2017年 wdx. All rights reserved.
//

#import "PHPush.h"

@interface PHPush()

@end
@implementation PHPush
+(instancetype)share{
    static dispatch_once_t once;
    static PHPush * push;
    dispatch_once(&once, ^{
        push = [PHPush new];
    });
   return   push;
}

-(void)localPushWithTitle:(NSString *)title body:(NSString *)body time:(NSInteger)time pram:(NSDictionary *)pram{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:time];
    NSLog(@"fireDate=%@",fireDate);
    
    notification.fireDate = fireDate;
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔
    notification.repeatInterval = kCFCalendarUnitSecond;
    
    // 通知内容'
    notification.alertBody =  body;
    notification.alertTitle = title;
//    notification.applicationIconBadgeNumber = 1;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
  
    notification.userInfo = pram;
     notification.repeatInterval = NSCalendarUnitDay;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];

}
-(void)registWithBlock:(RegistBlock)block{
    // ios8后，需要添加这个注册，才能得到授权
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        }
        [[UIApplication sharedApplication]registerForRemoteNotifications];
        
    }else {
       
         [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIUserNotificationTypeSound];
    }
    _registBlock=block;

}
@end
