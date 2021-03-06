//
//  PHButton.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/12.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "PHButton.h"
#import "UIViewExt.h"

@implementation PHButton
-(void)addAction:(Block)block{
    [self addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    _block=block;
}
-(void)action:(PHButton *)sender{
    if (_block) {
         _block();
    }
   
}
-(void)setImgDirection:(ImgDirection)imgDirection{
    _imgDirection = imgDirection;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (_imgDirection == imgRight) {
        self.titleLabel.left = 0;
        self.imageView.left = self.titleLabel.right + 1;
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
