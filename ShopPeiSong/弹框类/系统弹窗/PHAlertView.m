//
//  PHAlertView.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/2.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "PHAlertView.h"

@implementation PHAlertView
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    if (self=[super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles,nil]) {
        self.delegate=self;
    }
    return self;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (_block) {
        _block(buttonIndex);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
