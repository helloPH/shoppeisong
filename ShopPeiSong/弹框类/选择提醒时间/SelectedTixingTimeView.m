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

@property(nonatomic,strong)UILabel *titleLabel;//提示文字
@property(nonatomic,strong)UIView *timeView;//提示文字
@property(nonatomic,strong)UIButton *sureBtn;//

@end
@implementation SelectedTixingTimeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15.0;
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.5;
        self.alpha = 0.95;
        self.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return self;
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
            if (i == 0) {
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
}
-(void)sureBtnClick
{
    
}

@end
