//
//  ChangePhoneNumber.h
//  LifeForMM
//
//  Created by MIAO on 16/6/20.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@protocol ChangePhoneNumberDelegate <NSObject>

-(void)ChangePhoneNumberWithString:(NSString *)string AndIndex:(NSInteger)index;

@end
@interface ChangePhoneNumber : UIView<UITextFieldDelegate>

@property(nonatomic,strong)id<ChangePhoneNumberDelegate>changeDelegate;

@end
