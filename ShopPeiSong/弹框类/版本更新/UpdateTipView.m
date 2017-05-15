//
//  UpdateTipView.m
//  LifeForMM
//
//  Created by HUI on 16/3/17.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "UpdateTipView.h"
#import "Header.h"
@implementation UpdateTipView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15.0;
        self.layer.shadowRadius = 10.0;
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews
{
    //更新内容
    _txtView = [[UITextView alloc]initWithFrame:CGRectZero];
    _txtView.backgroundColor = [UIColor clearColor];
    _txtView.textAlignment = NSTextAlignmentLeft;
    _txtView.textColor = textBlackColor;
    _txtView.font = [UIFont systemFontOfSize:MLwordFont_3];
    _txtView.editable = NO;
    [self addSubview:_txtView];
    
    //升级btn
    _updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _updateBtn.frame = CGRectZero;
    _updateBtn.backgroundColor = [UIColor clearColor];
    _updateBtn.tag = 101;
    [_updateBtn setTitle:@"更新版本" forState:UIControlStateNormal];
    [_updateBtn setTitleColor:txtColors(255, 79, 90, 1) forState:UIControlStateNormal];
    _updateBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    [_updateBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_updateBtn];
    
    //拒绝升级
    _rejectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rejectBtn.backgroundColor = [UIColor clearColor];
    _rejectBtn.frame = CGRectZero;
    _rejectBtn.tag = 102;
    [_rejectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_rejectBtn setTitle:@"残忍拒绝" forState:UIControlStateNormal];
    _rejectBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    [_rejectBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rejectBtn];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0,self.height-60*MCscale, self.width, 1)];
    line1.backgroundColor = lineColor;
    [self addSubview:line1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(self.width/2.0, self.height-59*MCscale, 1, 59*MCscale)];
    line2.backgroundColor = lineColor;
    [self addSubview:line2];
}
-(void)layoutSubviews
{
    _txtView.frame = CGRectMake(15*MCscale, 20*MCscale, self.width-30*MCscale, self.height-85*MCscale);
    _updateBtn.frame = CGRectMake(8, self.height-56*MCscale, self.width/2.0-8, 50*MCscale);
    _rejectBtn.frame = CGRectMake(self.width/2.0+1, self.height-56*MCscale, self.width/2.0-9, 50*MCscale);
}
-(void)btnAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(updateTip:tapIndex:)]) {
        [self.delegate updateTip:self tapIndex:btn.tag];
    }
}

@end
