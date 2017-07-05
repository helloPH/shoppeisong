//
//  SelectedTixingTimeView.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/20.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "SelectedTixingTimeView.h"
#import "Header.h"
@interface SelectedTixingTimeView ()
@property(nonatomic,strong)UIButton * backView;

@property(nonatomic,strong)UILabel *titleLabel;//提示文字
@property(nonatomic,strong)UIView *timeView;//提示文字
@property(nonatomic,strong)UIButton *sureBtn;//
@property(nonatomic,assign)NSInteger seleIndex;


@end
@implementation SelectedTixingTimeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _seleIndex=0;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15.0;
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.5;
        self.alpha = 0.95;
        self.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return self;
}
-(instancetype)init{
    if (self=[super init]) {
        [self newView];
    }
    return self;
}
-(void)newView{
    _backView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [_backView addTarget:self action:@selector(disAppear) forControlEvents:UIControlEventTouchUpInside];
    
    
    _seleIndex=0;
    [_backView addSubview:self];
    self.center=CGPointMake(_backView.width/2, _backView.height/2);
    self.frame=CGRectMake(30*MCscale, 230*MCscale, kDeviceWidth - 60*MCscale,130*MCscale);
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 15.0;
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOpacity = 0.5;
    self.alpha = 0.95;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    
}
-(void)appear{
    [[UIApplication sharedApplication].delegate.window addSubview:_backView];
    _backView.alpha=0;
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha=0.95;
    }];
}
-(void)disAppear{
    if (_block) {
        _block(NO);
    }
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha=0;
    }completion:^(BOOL finished) {
        [_backView removeFromSuperview];
    }];
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@"提醒周时"];
        
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}
-(UIView *)timeView
{
    if (!_timeView) {
        _timeView = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:[UIColor clearColor]];
        [self addSubview:_timeView];
        
        CGFloat viewWidth = (self.width - 40*MCscale)/3.0;
        NSArray *titleArray = @[@"2分钟",@"4分钟",@"8分钟"];
        for (int i = 0; i<3; i++) {
            UIView *view = [BaseCostomer viewWithFrame:CGRectMake((viewWidth +10*MCscale)*i+10*MCscale, 0, viewWidth,30*MCscale) backgroundColor:[UIColor clearColor]];
            view.tag = 1000+i;
            [_timeView addSubview:view];
            UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapClick:)];
            [view addGestureRecognizer:viewTap];
            
            UIImageView *selectedImage = [BaseCostomer imageViewWithFrame:CGRectMake(10*MCscale,6*MCscale,18*MCscale,18*MCscale) backGroundColor:[UIColor clearColor] image:@"选择"];
            selectedImage.tag = 2000+i;
            [view addSubview:selectedImage];
            if (i == _seleIndex) {
                selectedImage.image = [UIImage imageNamed:@"选中"];
            }
            
            UILabel *timeLabel = [BaseCostomer labelWithFrame:CGRectMake(selectedImage.right +5*MCscale,5*MCscale, view.width - 40*MCscale, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_5] textColor:textBlackColor text:titleArray[i]];
            [view addSubview:timeLabel];
        }
    }
    return _timeView;
}

-(UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [BaseCostomer buttonWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_2] textColor:[UIColor whiteColor] backGroundColor:redTextColor cornerRadius:3.0 text:@"保存" image:@""];
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sureBtn];
    }
    return _sureBtn;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(10*MCscale, 20*MCscale, self.width - 20*MCscale, 20*MCscale);
    self.timeView.frame = CGRectMake(0, self.titleLabel.bottom +10*MCscale, self.width,30*MCscale);
    self.sureBtn.frame = CGRectMake(self.width/2.0-50*MCscale, self.timeView.bottom +10*MCscale, 100*MCscale, 30*MCscale);
}
-(void)viewTapClick:(UITapGestureRecognizer *)tap
{
    for (UIView *view in self.timeView.subviews) {
        UIImageView *image = view.subviews[0];
        image.image = [UIImage imageNamed:@"选择"];
    }
    UIImageView *image = tap.view.subviews[0];
    image.image = [UIImage imageNamed:@"选中"];
    _seleIndex = image.tag-2000;
}
-(void)sureBtnClick
{
    NSInteger timeInter = 0;
    switch (_seleIndex) {
        case 0:
            timeInter = 60*2;
            break;
        case 1:
            timeInter = 60*4;
            break;
        case 2:
            timeInter = 60*8;
            break;
        default:
            break;
    }
    set_PushTimeInter(timeInter);
//    if (timeInter==120) {
//        set_PushTimeInter(5);
//    }
    
    NSLog(@"%ld",(long)pushTimeInter);
    [self disAppear];
    if (_block) {
        _block(YES);
    }
}

@end
