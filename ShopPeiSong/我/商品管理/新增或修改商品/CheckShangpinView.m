//
//  CheckShangpinView.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/22.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "CheckShangpinView.h"
#import "ReviewSelectedView.h"
#import "FujiafeiView.h"
#import "Header.h"
@interface  CheckShangpinView()<UITextFieldDelegate,ReviewSelectedViewDelegate,FujiafeiViewDelegate,MBProgressHUDDelegate>

@property(nonatomic,strong)NSArray *titleArray1,*placeoderArray;
@property(nonatomic,strong)ReviewSelectedView *selectedView;
@property(nonatomic,strong)FujiafeiView *fujiafeiView;
@property(nonatomic,strong)UIView *maskView;
@property(nonatomic,strong)NSDictionary *shangpinDict;

@end
@implementation CheckShangpinView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

//#pragma mark 获得商品数据
//-(void)getShangpinMessagesDataWithshangpinId:(NSString *)shangpinID
//{
//    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
//    mHud.mode = MBProgressHUDModeIndeterminate;
//    mHud.delegate = self;
//    mHud.labelText = @"请稍等...";
//    [mHud show:YES];
//    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"shop.id":shangpinID}];
//    [HTTPTool postWithUrl:@"enterShangpin.action" params:pram success:^(id json){
//        [mHud hide:YES];
//        NSLog(@"商品信息 %@",json);
//        
//        if ([[json valueForKey:@"message"] integerValue] == 0) {
//            [self promptMessageWithString:@"参数不能为空"];
//        }
//        else if ([[json valueForKey:@"message"] integerValue] == 1)
//        {
//            [self promptMessageWithString:@"无此商品信息"];
//        }
//        else
//        {
//            /**
//             *  shop =     {
//             biaoqian = 1;
//             caigoujia = 3;
//             canpinpic = "http://www.shp360.com/Store/images/shangpin/8220160407104001.png";
//             dianleipaixu = 0;
//             "fujiafeiyong_money" = 0;
//             "fujiafeiyong_name" = 0;
//             id = 3447;
//             shangpinname = "\U65b9\U4fbf\U9762/\U4efd";
//             xianjia = 3;
//             yuanjia = 0;
//             zhuangtai = 1;
//             };
//             */
//            
//            self.shangpinDict = [json valueForKey:@"shop"];
//        }
//    } failure:^(NSError *error) {
//        [mHud hide:YES];
//        [self promptMessageWithString:@"网络连接错误"];
//    }];
//}

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
        _selectedView = [[ReviewSelectedView  alloc]initWithFrame:CGRectMake(60*MCscale,120*MCscale, kDeviceWidth - 120*MCscale, 240*MCscale)];
        _selectedView.selectedDelegate = self;
    }
    return _selectedView;
}

-(FujiafeiView *)fujiafeiView
{
    if (!_fujiafeiView) {
        _fujiafeiView = [[FujiafeiView alloc]initWithFrame:CGRectMake(60*MCscale,150*MCscale, kDeviceWidth - 120*MCscale,150*MCscale)];
        _fujiafeiView.fujiafeiDelegate = self;
    }
    return _fujiafeiView;
}
-(NSArray *)titleArray1
{
    if (!_titleArray1) {
        _titleArray1 = @[@"原价",@"现价",@"采购价",@"排序",@"标签",@"附加费",@"商品状态"];
    }
    return _titleArray1;
}
-(NSArray *)placeoderArray
{
    if (!_placeoderArray) {
        _placeoderArray = @[@"请输入原价",@"请输入现价",@"请输入采购价",@"请输入排序",@"",@"",@""];
    }
    return _placeoderArray;
}

-(void)createUI
{
    for (int i = 0; i<self.titleArray1.count; i++) {
        UILabel *titleLabel = [BaseCostomer labelWithFrame:CGRectMake(10*MCscale,40*MCscale*i+5*MCscale,80*MCscale, 30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:0 numOfLines:1 text:self.titleArray1[i]];
        [self addSubview:titleLabel];
        
        UIView *line = [BaseCostomer viewWithFrame:CGRectMake(10*MCscale, titleLabel.bottom+5*MCscale, kDeviceWidth-20*MCscale, 1) backgroundColor:lineColor];
        [self addSubview:line];
        
        if (i < 4) {
            UITextField *textField = [BaseCostomer textfieldWithFrame:CGRectMake(kDeviceWidth-130*MCscale , titleLabel.top, 120*MCscale, 30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_4] textColor:redTextColor textAlignment:2 keyboardType:UIKeyboardTypeNumbersAndPunctuation borderStyle:0 placeholder:self.placeoderArray[i]];
            textField.backgroundColor = [UIColor clearColor];
            textField.returnKeyType = UIReturnKeyDone;
            textField.tag = 11000+i;
            textField.delegate = self;
            [self addSubview:textField];
            }
        else
        {
            UIView *backView = [BaseCostomer viewWithFrame:CGRectMake(titleLabel.right +10*MCscale, titleLabel.top, kDeviceWidth - 110*MCscale, 30*MCscale) backgroundColor:[UIColor clearColor]];
            backView.tag = 21000+i;
            [self addSubview:backView];
            
            UITapGestureRecognizer *backViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backViewTapClick:)];
            [backView addGestureRecognizer:backViewTap];
            
            UIImageView *rightImage = [BaseCostomer imageViewWithFrame:CGRectMake(backView.width - 15*MCscale, 5*MCscale, 15*MCscale,20*MCscale) backGroundColor:[UIColor clearColor] image:@"xialas"];
            [backView addSubview:rightImage];
            
            UILabel *contentLabel = [BaseCostomer labelWithFrame:CGRectMake(30*MCscale,0, 150*MCscale, 30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_4] textColor:txtColors(216, 216, 216, 1) backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@""];
            contentLabel.tag = 31000+i;
            [backView addSubview:contentLabel];
            if (i == 5) {
                UILabel *contentLabel = [BaseCostomer labelWithFrame:CGRectMake(backView.width - 75*MCscale,0,50*MCscale, 30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_4] textColor:txtColors(216, 216, 216, 1) backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@""];
                contentLabel.tag = 41000+i;
                [backView addSubview:contentLabel];
            }
        }
    }
}

-(void)backViewTapClick:(UITapGestureRecognizer *)tap
{
    NSLog(@"%ld",tap.view.tag);
    if (tap.view.tag == 21004) {
        self.selectedView.frame =CGRectMake(60*MCscale,120*MCscale, kDeviceWidth - 120*MCscale, 240*MCscale);
        [UIView animateWithDuration:0.3 animations:^{
            self.maskView.alpha = 1;
            [self addSubview:self.maskView];
            self.selectedView.alpha = 0.95;
            self.selectedView.dianpuId = self.dianpuID;
            [self.selectedView reloadDataWithViewTag:4];
            [self addSubview:self.selectedView];
        }];
    }
    else if (tap.view.tag == 21005)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.maskView.alpha = 1;
            [self addSubview:self.maskView];
            self.fujiafeiView.alpha = 0.95;
            [self addSubview:self.fujiafeiView];
        }];
    }
    else if (tap.view.tag == 21006)
    {
        self.selectedView.frame = CGRectMake(60*MCscale,180*MCscale, kDeviceWidth - 120*MCscale, 120*MCscale);
        [UIView animateWithDuration:0.3 animations:^{
            self.maskView.alpha = 1;
            [self addSubview:self.maskView];
            self.selectedView.alpha = 0.95;
            [self.selectedView reloadDataWithViewTag:5];
            [self addSubview:self.selectedView];
        }];
    }
}

#pragma mark 选择商品标签
-(void)selectedAddShangpinBiaoqianWithString:(NSString *)string AndId:(NSString *)ID
{
    UIView *backView1 = [self viewWithTag:21004];
    UILabel *leibieLabel = [backView1 viewWithTag:31004];
    leibieLabel.text = string;
    [self maskViewDisMiss];
}
#pragma mark 附加费(FujiafeiViewDelegate)
-(void)saveFujiafeiWithName:(NSString *)fujiafeiName AndMoney:(NSString *)fujiafeiMoney
{
    UIView *backView1 = [self viewWithTag:21005];
    UILabel *leibieLabel = [backView1 viewWithTag:31005];
    UILabel *leibieLabe2 = [backView1 viewWithTag:41005];
    leibieLabel.text = fujiafeiName;
    leibieLabe2.text = fujiafeiMoney;
    [self maskViewDisMiss];
}

#pragma mark 商品状态
-(void)selectedStatesWithString:(NSString *)string
{
    UIView *backView1 = [self viewWithTag:21006];
    UILabel *leibieLabel = [backView1 viewWithTag:31006];
    leibieLabel.text = string;
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
-(void)promptMessageWithString:(NSString *)string
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    mHud.labelText = string;
    mHud.mode = MBProgressHUDModeText;
    [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
-(void)myTask
{
    sleep(1);
}
#pragma mark UITextDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITextField *textfield1 = [self viewWithTag:11000];
    UITextField *textfield2 = [self viewWithTag:11001];
    UITextField *textfield3 = [self viewWithTag:11002];
    UITextField *textfield4 = [self viewWithTag:11003];

    [textfield1 resignFirstResponder];
    [textfield2 resignFirstResponder];
    [textfield3 resignFirstResponder];
    [textfield4 resignFirstResponder];
    return YES;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITextField *textfield1 = [self viewWithTag:11000];
    UITextField *textfield2 = [self viewWithTag:11001];
    UITextField *textfield3 = [self viewWithTag:11002];
    UITextField *textfield4 = [self viewWithTag:11003];
    
    [textfield1 resignFirstResponder];
    [textfield2 resignFirstResponder];
    [textfield3 resignFirstResponder];
    [textfield4 resignFirstResponder];
}
@end
