//
//  YanZhengMaViewController.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/26.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "YanZhengMaViewController.h"
#import "YanButton.h"


@interface YanZhengMaViewController ()<UITextFieldDelegate>


@property (nonatomic,strong)UITextField * textF;

@property (nonatomic,strong)YanButton * yanBtn;
@end

@implementation YanZhengMaViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden=NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self newView];
    [self initNavi];
    // Do any additional setup after loading the view.
}

-(void)initNavi{
    self.navigationController.navigationBar.hidden=YES;
    SuperNavigationView * navi = [SuperNavigationView new];
    [navi.leftBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [navi.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [navi.leftBtn setTitleColor:textBlackColor forState:UIControlStateNormal];
    [navi.leftBtn sizeToFit];
    
    
    [self.view addSubview:navi];
    navi.block=^(NSInteger index){
        if (index==0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    };
}
-(void)newView{
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 170, kDeviceWidth, 49)];
    titleLabel.font=[UIFont systemFontOfSize:MLwordFont_2];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.text=[NSString stringWithFormat:@"我们已向%@发送\n验证码短信息",_phone];
    titleLabel.numberOfLines=2;
    [self.view addSubview:titleLabel];
    
    
    UILabel * titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, titleLabel.bottom+30, kDeviceWidth, 25)];
    titleLabel1.font=[UIFont systemFontOfSize:MLwordFont_1];
    titleLabel1.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:titleLabel1];
    titleLabel1.text=@"请输入验证码";
    
    
    CGFloat lw = 60;
    CGFloat lh = 60;
    CGFloat ly = titleLabel1.bottom +5;
    CGFloat ls = 10;
    
    for (int i =0;  i < 3; i++) {
        CGFloat lx = kDeviceWidth/2 - lw/2 - ls - lw + (lw + ls)*i;
    
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(lx, ly  , lw , lh)];
        label.layer.borderWidth=1;
        label.layer.borderColor=textBlackColor.CGColor;
        [self.view addSubview:label];
        label.tag=i +100;
        label.font=[UIFont systemFontOfSize:MLwordFont_2];
        label.textColor=textBlackColor;
        label.textAlignment=NSTextAlignmentCenter;
        label.userInteractionEnabled=YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(apperKeyBoard)];
        [label addGestureRecognizer:tap];
        
    }
    
    
    _yanBtn = [YanButton insButtonWithFrame:CGRectMake(0, ly + lh +20, kDeviceWidth, 40) title:@"重新获取验证码" time:180];
    _yanBtn.titleLabel.font=[UIFont systemFontOfSize:MLwordFont_5];
    [_yanBtn setTitleColor:naviBarTintColor forState:UIControlStateNormal];
    _yanBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_yanBtn];
    [_yanBtn addTarget:self action:@selector(yanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self yanBtnClick:_yanBtn];
    
    
    _textF = [[UITextField alloc]initWithFrame:CGRectZero];
    _textF.delegate=self;
    [self.view addSubview:_textF];
    _textF.keyboardType=UIKeyboardTypeNumberPad;
    [self apperKeyBoard];
}
-(void)reshViewWithString:(NSString *)string{
    for (int i = 0 ; i < 3; i ++) {
        UILabel * label = [self.view viewWithTag:100+i];
        label.text = @"";
    }
    
    for (int i = 0; i < string.length; i ++) {
        UILabel * label = [self.view viewWithTag:100+i];
        label.text = [string substringWithRange:NSMakeRange(i, 1)];
    }
    
    if (string.length==3) {
        if (_block) {
            _block(string);
        }
    }
}
-(void)apperKeyBoard{
    [_textF becomeFirstResponder];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   
    NSString * newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (newString.length > 3) {
        return NO;
    }
    
 
    [self reshViewWithString:newString];
    return YES;
}

-(void)yanBtnClick:(YanButton *)sender{


    
    sender.code=@"   ";
    [Request getYanMaWithDic:@{@"dianpu.yidongtel":_phone} success:^(id json) {
        sender.code= [json valueForKey:@"code"];
        NSLog(@"----验证码:%@",sender.code);
        [sender startTimer];
    } failure:^(NSError *error) {
        sender.code=@"   ";
    }];
}
-(void)clear{
    _textF.text=@"";
    [self reshViewWithString:@""];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
