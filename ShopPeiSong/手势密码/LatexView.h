//
//  LatexView.h
//  九宫格
//
//  Created by alive on 16/8/15.
//  Copyright © 2016年 alive. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,LockBtnType) {
    lockBtnTypeSelected,
    lockBtnTypeNoSelected,
    lockBtnTypeWrong,
};

@interface LatexView : UIView
@property (nonatomic,strong)NSString * passWord;
@property (nonatomic,strong)void (^block)(NSString * passWord);
-(void)setStatus:(LockBtnType)lockBtnType;
@end
