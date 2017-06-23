//
//  SuperNavigationView.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/19.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "SuperNavigationView.h"
#import "Header.h"


@interface SuperNavigationView()

@end
@implementation SuperNavigationView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
        [self newView];
    }
    return self;
}
-(instancetype)init{
    if (self=[super init]) {
        self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
        [self newView];
    }
    return self;
}
-(void)newView{
    
    _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, self.frame.size.height-25-10, 25, 25)];
    self.tintColor=naviBarTintColor;
    [_leftBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [self addSubview:_leftBtn];
    [_leftBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _titleView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth*0.3, 25)];
    [_titleView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _titleView.centerX=self.width/2;
    _titleView.centerY=_leftBtn.centerY;

    _titleView.titleLabel.font=[UIFont systemFontOfSize:MLwordFont_3];
    [self addSubview:_titleView];
    [_titleView addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 50, 25)];
    _rightBtn.centerY=_leftBtn.centerY;
    [_rightBtn setTitleColor:textBlackColor forState:UIControlStateNormal];
    _rightBtn.titleLabel.font=[UIFont systemFontOfSize:MLwordFont_4];
    [self addSubview:_rightBtn];
    _rightBtn.right=kDeviceWidth-10;
    [_rightBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)btnAction:(UIButton *)sender{
    if ([sender isEqual:_leftBtn]) {
        if (_backBlock) {
            _backBlock();
        }
    }
    if (_block) {
        if ([sender isEqual:_leftBtn]) {
            _block(0);
        }
        if ([sender isEqual:_titleView]) {
            _block(1);
        }
        if ([sender isEqual:_rightBtn]) {
            _block(2);
        }
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
