//
//  UpdateTipView.m
//  LifeForMM
//
//  Created by HUI on 16/3/17.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "UpdateTipView.h"
#import "Header.h"
@interface UpdateTipView()
@property (nonatomic,strong)UIScrollView * backView;

@property (nonatomic,strong)UITextView * txtView;

@property (nonatomic,retain)UIButton *updateBtn;//更新btn
@property (nonatomic,retain)UIButton *rejectBtn;//拒绝更新btn

@end
@implementation UpdateTipView
-(instancetype)init{
    if (self=[super init]) {
        [self newView];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
  
        [self newView];
    }
    return self;
}
-(void)setContent:(NSString *)content{
    _content = content;
    _txtView.text = content;
    
}
-(void)newView
{
    
    _backView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disAppear)];
    [_backView addGestureRecognizer:tap];
    
    
    
    //    [_backView addTarget:self action:@selector(disAppear) forControlEvents:UIControlEventTouchUpInside];
    self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width*0.8, [UIScreen mainScreen].bounds.size.width*0.6);
    self.backgroundColor=[UIColor whiteColor];
    self.layer.cornerRadius = 15.0;
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOpacity = 0.5;
    self.alpha = 0.95;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    //    self.clipsToBounds=YES;
    self.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    [_backView addSubview:self];
    
    
    //更新内容
    _txtView = [[UITextView alloc]initWithFrame:CGRectZero];
    _txtView.backgroundColor = [UIColor clearColor];
    _txtView.textAlignment = NSTextAlignmentLeft;
    _txtView.textColor = textBlackColor;
    _txtView.font = [UIFont systemFontOfSize:MLwordFont_3];
    _txtView.editable = NO;
    _txtView.frame=CGRectMake(15*MCscale, 20*MCscale, self.width-30*MCscale, self.height-85*MCscale);
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
    _updateBtn.frame = CGRectMake(8, self.height-56*MCscale, self.width/2.0-8, 50*MCscale);

    
    
    
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
    _rejectBtn.frame = CGRectMake(self.width/2.0+1, self.height-56*MCscale, self.width/2.0-9, 50*MCscale);
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0,self.height-60*MCscale, self.width, 1)];
    line1.backgroundColor = lineColor;
    [self addSubview:line1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(self.width/2.0, self.height-59*MCscale, 1, 59*MCscale)];
    line2.backgroundColor = lineColor;
    [self addSubview:line2];
}

-(void)btnAction:(UIButton *)btn
{
    if (_block) {
        if ([btn isEqual:_updateBtn]) {
            _block(0);
        }
        if ([btn isEqual:_rejectBtn]) {
            _block(1);
        }
    }
    

    
    
}
-(void)appear{
    [[UIApplication sharedApplication].delegate.window addSubview:_backView];
    _backView.alpha=0;
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha=0.95;
    }];
}
-(void)disAppear{
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha=0;
    }completion:^(BOOL finished) {
        [_backView removeFromSuperview];
    }];
}

@end
