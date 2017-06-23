//
//  DatePickerView.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/20.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "DatePickerView.h"
#import "Header.h"


@interface DatePickerView()

@property (nonatomic,strong)UIScrollView * backView;

@property (nonatomic,strong)UIDatePicker * datePicker;
@end
@implementation DatePickerView
-(instancetype)init{
    if (self=[super init]) {
        [self newView];
    }
    return self;
}
-(void)newView{
    _backView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
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
    
    
    
    
 
    
    
    
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, self.width, self.width*0.6)];
    _datePicker.datePickerMode=UIDatePickerModeTime;
    [self addSubview:_datePicker];
    
    
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(10*MCscale, _datePicker.bottom+10*MCscale, self.width-20*MCscale, 40*MCscale);
    sureBtn.backgroundColor = txtColors(249, 54, 73, 1);
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 5.0;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureBtn];
    
    
    self.height=sureBtn.bottom+10;
    self.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
}
-(void)sureBtnClick:(UIButton *)sender{
    NSDateFormatter * format = [[NSDateFormatter alloc]init];
    format.dateFormat=@"hh:mm";
    NSString * timeString = [format stringFromDate:_datePicker.date];
    
    if (_block) {
        _block(timeString);
        [self disAppear];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)appear{
    [[UIApplication sharedApplication].delegate.window addSubview:_backView];
    //    [[self getCurrentVC].view addSubview:_backView];
    //    [[UIViewController presentingVC].view addSubview:_backView];
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
