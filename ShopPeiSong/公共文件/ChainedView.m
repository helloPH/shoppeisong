//
//  ChainedView.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/30.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "ChainedView.h"
#import "UIViewExt.h"

@implementation ChainedView

- (ChainedView *(^)(UIColor *))backGroundColor
{
    return ^(UIColor * color) {
        self.backgroundColor=color;
        return self;
    };
}
- (ChainedView *(^)(CGRect))frame{
    return ^(CGRect rect){
        self.frame=rect;
        return self;
    };
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
