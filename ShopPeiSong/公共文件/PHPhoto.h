//
//  PHPhoto.h
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/20.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHPhoto : NSObject
@property (nonatomic,strong)void(^block)(UIImage * image);
-(void)showPicker;
@end
