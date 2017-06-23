//
//  AddShangpingView.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/21.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "AddShangpingView.h"
#import "ReviewSelectedView.h"
#import "FujiafeiView.h"
#import "Header.h"
@interface  AddShangpingView()<UITextFieldDelegate,ReviewSelectedViewDelegate,FujiafeiViewDelegate>

@property(nonatomic,strong)NSArray *titleArray1,*titleArray2,*placeoderArray;
@property(nonatomic,strong)ReviewSelectedView *selectedView;
@property(nonatomic,strong)FujiafeiView *fujiafeiView;
@property(nonatomic,strong)UIView *maskView;

@end
@implementation AddShangpingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
-(UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor clearColor];
        _maskView.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewDisMiss)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}
-(ReviewSelectedView *)selectedView
{
    if (!_selectedView) {
        _selectedView = [[ReviewSelectedView  alloc]initWithFrame:CGRectMake(60*MCscale,100*MCscale, kDeviceWidth - 120*MCscale, 240*MCscale)];
        _selectedView.selectedDelegate = self;
    }
    return _selectedView;
}

-(FujiafeiView *)fujiafeiView
{
    if (!_fujiafeiView) {
        _fujiafeiView = [[FujiafeiView alloc]initWithFrame:CGRectMake(60*MCscale,180*MCscale, kDeviceWidth - 120*MCscale,150*MCscale)];
        _fujiafeiView.fujiafeiDelegate = self;
    }
    return _fujiafeiView;
}
-(NSArray *)titleArray1
{
    if (!_titleArray1) {
        _titleArray1 = @[@"名称:",@"类别",@"库存量",@"原价",@"现价",@"成本价",@"附加费",@"标签",@"排序"];
    }
    return _titleArray1;
}
-(NSArray *)placeoderArray
{
    if (!_placeoderArray) {
        _placeoderArray = @[@"请输入名称",@"",@"请输入库存量",@"请输入原价",@"请输入现价",@"请输入成本价",@"",@"",@"请输入排序"];
    }
    return _placeoderArray;
}

-(void)createUI
{
    for (int i = 0; i<self.titleArray1.count; i++) {
        UILabel *titleLabel = [BaseCostomer labelWithFrame:CGRectMake(10*MCscale,40*MCscale*i+5*MCscale, 60*MCscale, 30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text:self.titleArray1[i]];
        [self addSubview:titleLabel];
        if (i == 0 ||i == 1||i==4||i==5||i==8) {
            titleLabel.textColor = redTextColor;
        }
        
        UIView *line = [BaseCostomer viewWithFrame:CGRectMake(10*MCscale, titleLabel.bottom+5*MCscale, kDeviceWidth-20*MCscale, 1) backgroundColor:lineColor];
        [self addSubview:line];
        
        if (i == 0 ||i == 2||i==3||i==4||i==5||i==8) {
            UITextField *textField = [BaseCostomer textfieldWithFrame:CGRectMake(kDeviceWidth-130*MCscale , titleLabel.top, 120*MCscale, 30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors textAlignment:2 keyboardType:UIKeyboardTypeNumbersAndPunctuation borderStyle:0 placeholder:self.placeoderArray[i]];
            textField.backgroundColor = [UIColor clearColor];
            textField.returnKeyType = UIReturnKeyDone;
            textField.tag = 10000+i;
            textField.delegate = self;
            [self addSubview:textField];
            if (i ==0) {
                textField.frame = CGRectMake(titleLabel.right +10*MCscale, titleLabel.top, kDeviceWidth - 90*MCscale, 30*MCscale);
                textField.textAlignment = NSTextAlignmentCenter;
                textField.keyboardType = 0;
            }
        }
        else
        {
            UIView *backView = [BaseCostomer viewWithFrame:CGRectMake(titleLabel.right +10*MCscale, titleLabel.top, kDeviceWidth - 90*MCscale, 30*MCscale) backgroundColor:[UIColor clearColor]];
            backView.tag = 20000+i;
            [self addSubview:backView];
            
            UITapGestureRecognizer *backViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backViewTapClick:)];
            [backView addGestureRecognizer:backViewTap];
            
            UIImageView *rightImage = [BaseCostomer imageViewWithFrame:CGRectMake(backView.width - 15*MCscale, 5*MCscale, 15*MCscale,20*MCscale) backGroundColor:[UIColor clearColor] image:@"xialas"];
            [backView addSubview:rightImage];
            
            UILabel *contentLabel = [BaseCostomer labelWithFrame:CGRectMake(30*MCscale,0, 150*MCscale, 30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_4] textColor:txtColors(216, 216, 216, 1) backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@""];
            contentLabel.tag = 30000+i;
            [backView addSubview:contentLabel];
            if (i == 6) {
                UILabel *contentLabel = [BaseCostomer labelWithFrame:CGRectMake(backView.width - 75*MCscale,0,50*MCscale, 30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_4] textColor:txtColors(216, 216, 216, 1) backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@""];
                contentLabel.tag = 40000+i;
                [backView addSubview:contentLabel];
            }
        }
    }
}

-(void)backViewTapClick:(UITapGestureRecognizer *)tap
{
    NSLog(@"%ld",tap.view.tag);
    if (tap.view.tag == 20001) {
        [UIView animateWithDuration:0.3 animations:^{
            self.maskView.alpha = 1;
            [self addSubview:self.maskView];
            self.selectedView.alpha = 0.95;
            self.selectedView.dianpuId = self.dianpuID;
            [self.selectedView reloadDataWithViewTag:3];
            [self addSubview:self.selectedView];
        }];
    }
    else if (tap.view.tag == 20006)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.maskView.alpha = 1;
            [self addSubview:self.maskView];
            self.fujiafeiView.alpha = 0.95;
            [self addSubview:self.fujiafeiView];
        }];
    }
    else if (tap.view.tag == 20007)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.maskView.alpha = 1;
            [self addSubview:self.maskView];
            self.selectedView.alpha = 0.95;
            //            self.selectedView.dianpuId = self.dianpuID;
            [self.selectedView reloadDataWithViewTag:4];
            [self addSubview:self.selectedView];
        }];
    }
}
#pragma mark 选择商品类别
-(void)selectedAddShangpinLeixinWithString:(NSString *)string AndId:(NSString *)ID
{
    UIView *backView1 = [self viewWithTag:20001];
    UILabel *leibieLabel = [backView1 viewWithTag:30001];
    leibieLabel.text = string;
    [self maskViewDisMiss];
}
#pragma mark 选择商品标签
-(void)selectedAddShangpinBiaoqianWithString:(NSString *)string AndId:(NSString *)ID
{
    UIView *backView1 = [self viewWithTag:20007];
    UILabel *leibieLabel = [backView1 viewWithTag:30007];
    leibieLabel.text = string;
    [self maskViewDisMiss];
}
#pragma mark 附加费(FujiafeiViewDelegate)
-(void)saveFujiafeiWithName:(NSString *)fujiafeiName AndMoney:(NSString *)fujiafeiMoney
{
    UIView *backView1 = [self viewWithTag:20006];
    UILabel *leibieLabel = [backView1 viewWithTag:30006];
    UILabel *leibieLabe2 = [backView1 viewWithTag:40006];
    leibieLabel.text = fujiafeiName;
    leibieLabe2.text = fujiafeiMoney;
    [self maskViewDisMiss];
}
-(void)maskViewDisMiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        [self.maskView removeFromSuperview];
        [self endEditing:YES];
        self.selectedView.alpha = 0;
        [self.selectedView removeFromSuperview];
        self.fujiafeiView.alpha = 0;
        [self.fujiafeiView removeFromSuperview];
    }];
}
#pragma mark UITextDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITextField *textfield1 = [self viewWithTag:10000];
    UITextField *textfield2 = [self viewWithTag:10002];
    UITextField *textfield3 = [self viewWithTag:10003];
    UITextField *textfield4 = [self viewWithTag:10004];
    UITextField *textfield5 = [self viewWithTag:10005];
    UITextField *textfield6 = [self viewWithTag:10008];
    [textfield1 resignFirstResponder];
    [textfield2 resignFirstResponder];
    [textfield3 resignFirstResponder];
    [textfield4 resignFirstResponder];
    [textfield5 resignFirstResponder];
    [textfield6 resignFirstResponder];
    
    return YES;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITextField *textfield1 = [self viewWithTag:10000];
    UITextField *textfield2 = [self viewWithTag:10002];
    UITextField *textfield3 = [self viewWithTag:10003];
    UITextField *textfield4 = [self viewWithTag:10004];
    UITextField *textfield5 = [self viewWithTag:10005];
    UITextField *textfield6 = [self viewWithTag:10008];
    [textfield1 resignFirstResponder];
    [textfield2 resignFirstResponder];
    [textfield3 resignFirstResponder];
    [textfield4 resignFirstResponder];
    [textfield5 resignFirstResponder];
    [textfield6 resignFirstResponder];
}
@end
