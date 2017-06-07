//
//  PHPush.h
//  PHPackAge
//
//  Created by MIAO on 2017/5/4.
//  Copyright © 2017年 wdx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^DicBlock)(NSDictionary * dic);
typedef void(^StringBlock)(NSString  * string);
typedef void(^RegistBlock)(NSData * token,NSError * error);
#define sharePush [PHPush share]

@interface PHPush : NSObject

@property (nonatomic,strong)DicBlock localBlock;
@property (nonatomic,strong)DicBlock remoteBlock;
@property (nonatomic,strong)RegistBlock registBlock;
+(instancetype)share;
-(void)registWithBlock:(RegistBlock)block;
-(void)localPushWithTitle:(NSString *)title body:(NSString *)body time:(NSInteger)time sound:(NSString *)soundName pram:(NSDictionary *)pram;

@end
