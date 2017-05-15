//
//  ChangeImageView.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/20.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "ChangeImageView.h"
#import "Header.h"
@interface ChangeImageView()<MBProgressHUDDelegate>

@property(nonatomic,strong)UILabel *titleLabel1,*titleLabel2;//提示信息
@property(nonatomic,strong)UIView *lineView;//
@property(nonatomic,strong)UIButton *cancalBtn,*sureBtn;

@end
@implementation ChangeImageView

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

-(UILabel *)titleLabel1
{
    if (!_titleLabel1) {
        _titleLabel1 = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_2] textColor:txtColors(193, 188, 188, 1) backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter numOfLines:2 text:@"流量使用过大,"];
        [self addSubview:_titleLabel1];
    }
    return _titleLabel1;
}
-(UILabel *)titleLabel2
{
    if (!_titleLabel2) {
        _titleLabel2 = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_2] textColor:txtColors(193, 188, 188, 1) backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter numOfLines:2 text:@"建议在WIFI下下载"];
        [self addSubview:_titleLabel2];
    }
    return _titleLabel2;
}
-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
        [self addSubview:_lineView];
    }
    return _lineView;
}

-(UIButton *)cancalBtn
{
    if (!_cancalBtn) {
        _cancalBtn = [BaseCostomer buttonWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:[UIColor whiteColor] backGroundColor:redTextColor cornerRadius:3.0 text:@"取消" image:@""];
        [_cancalBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancalBtn];
    }
    return _cancalBtn;
}
-(UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [BaseCostomer buttonWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:[UIColor whiteColor] backGroundColor:redTextColor cornerRadius:3.0 text:@"下载" image:@""];
        [_sureBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sureBtn];
    }
    return _sureBtn;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel1.frame = CGRectMake(20*MCscale,25*MCscale, self.width-40*MCscale,25*MCscale);
    self.titleLabel2.frame = CGRectMake(20*MCscale,self.titleLabel1.bottom, self.width-40*MCscale,25*MCscale);
    self.lineView.frame = CGRectMake(10*MCscale, self.titleLabel2.bottom +5*MCscale, self.width - 20*MCscale, 1);
    self.cancalBtn.frame = CGRectMake(20*MCscale, self.lineView.bottom+18*MCscale, 100*MCscale, 30*MCscale);
    self.sureBtn.frame = CGRectMake(self.width - 120*MCscale, self.lineView.bottom+18*MCscale, 100*MCscale, 30*MCscale);
}
-(void)buttonClick:(UIButton *)button
{
    if (button == self.cancalBtn) {
        if ([self.changeImageDelegate respondsToSelector:@selector(changeImageWithIndex:)]) {
            [self.changeImageDelegate changeImageWithIndex:0];
        }
    }
    else
    {
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        mbHud.mode = MBProgressHUDModeIndeterminate;
        mbHud.delegate = self;
        mbHud.labelText = @"请稍等...";
        [mbHud show:YES];
        NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"shequid":user_id}];
        [HTTPTool getWithUrl:@"getDianpuLogo.action" params:pram success:^(id json) {
            [mbHud hide:YES];
            NSLog(@"json %@",json);
            if ([[json valueForKey:@"message"]integerValue]==1) {
                NSArray *dianpuLogo = [json valueForKey:@"dianpuLogo"];
                for (NSDictionary *dict in dianpuLogo) {
                    [[NSUserDefaults standardUserDefaults] setValue:dict[@"dianpuid"] forKey:@"dianpuID"];
                    [[NSUserDefaults standardUserDefaults] setValue:dict[@"dianpulogo"] forKey:@"dianpulogo"];
                }
            }
            if ([self.changeImageDelegate respondsToSelector:@selector(changeImageWithIndex:)]) {
                [self.changeImageDelegate changeImageWithIndex:[[json valueForKey:@"message"]integerValue]];
            }
        } failure:^(NSError *error) {
            [self promptMessageWithString:@"网络连接错误"];
        }];
    }
}

-(void)promptMessageWithString:(NSString *)string
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    mHud.labelText = string;
    mHud.mode = MBProgressHUDModeText;
    [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
-(void)myTask
{
    sleep(1.5);
}

@end
