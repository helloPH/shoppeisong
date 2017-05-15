//
//  feedbackViewController.m
//  LifeForMM
//
//  Created by 时元尚品 on 15/7/22.
//  Copyright (c) 2015年 时元尚品. All rights reserved.
//

#import "feedbackViewController.h"
#import "Header.h"
@interface feedbackViewController ()<MBProgressHUDDelegate,UIGestureRecognizerDelegate,UITextViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UIButton *leftButton,*submitBtn;
@property(nonatomic,strong)UILabel *tishiLabel;//提示label
@property(nonatomic,strong)UITextField *numTextField; //电话号码
@property(nonatomic,strong)UIView *selectView,*line1,*line2;
@property(nonatomic,strong)UIImageView *selectImage;//选中图片
@property(nonatomic,strong)UITextView *opinionTextView;//意见

@end

@implementation feedbackViewController
{
    UIView *maskView;
    BOOL isChooseNum;
    CGRect numFrame;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:txtColors(4, 196, 153, 1)];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    isChooseNum = 0;
    [self initNavigation];
    [self initSubViews];
    [self initMaskView];
}
-(UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [BaseCostomer buttonWithFrame:CGRectMake(0, 0, NVbtnWight, NVbtnWight) backGroundColor:[UIColor clearColor] text:@"" image:@"返回按钮"];
        [_leftButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
#pragma mark 设置导航栏
-(void)initNavigation
{
    self.navigationItem.title = @"意见反馈";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];
    
    UIBarButtonItem *leftbarBtn = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
    self.navigationItem.leftBarButtonItem =leftbarBtn;
}

-(UIView *)line1
{
    if (!_line1) {
        _line1 = [BaseCostomer viewWithFrame:CGRectMake(0, 190*MCscale,kDeviceWidth , 1) backgroundColor:txtColors(88, 89, 90, 0.5)];
    }
    return _line1;
}
-(UITextView *)opinionTextView
{
    if (!_opinionTextView) {
        _opinionTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, self.line1.bottom, kDeviceWidth, 120)];
        _opinionTextView.text= @"     请留下您的宝贵意见和建议，我们将努力改进";
        _opinionTextView.textColor = txtColors(182, 183, 184, 1);
        _opinionTextView.delegate = self;
        _opinionTextView.font = [UIFont systemFontOfSize:MLwordFont_5];
        _opinionTextView.backgroundColor = [UIColor clearColor];
    }
    return _opinionTextView;
}
-(UIView *)line2
{
    if (!_line2) {
        _line2 = [BaseCostomer viewWithFrame:CGRectMake(0, self.opinionTextView.bottom+5,kDeviceWidth , 5) backgroundColor:txtColors(234, 235, 236, 1)];
    }
    return _line2;
}
-(UIImageView *)selectImage
{
    if (!_selectImage) {
        _selectImage = [BaseCostomer imageViewWithFrame:CGRectMake(0,3*MCscale, 24*MCscale, 24*MCscale) backGroundColor:[UIColor clearColor] image:@"选中"];
    }
    return _selectImage;
}
-(UILabel *)tishiLabel
{
    if (!_tishiLabel) {
        _tishiLabel = [BaseCostomer labelWithFrame:CGRectMake(self.selectImage.right+10*MCscale,5*MCscale, 180,20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_5] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft numOfLines:1 text:@"使用账号绑定手机号联系"];
    }
    return _tishiLabel;
}
-(UIView *)selectView
{
    if (!_selectView) {
        _selectView = [BaseCostomer viewWithFrame:CGRectMake(30*MCscale,self.line2.bottom+10*MCscale, kDeviceWidth-60*MCscale, 30*MCscale) backgroundColor:[UIColor clearColor]];
        [_selectView addSubview:self.selectImage];
        [_selectView addSubview:self.tishiLabel];
        UITapGestureRecognizer *selectedTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bangdingNumAction)];
        [_selectView addGestureRecognizer:selectedTap];
    }
    return _selectView;
}
-(UITextField *)numTextField
{
    if (!_numTextField) {
        _numTextField = [BaseCostomer textfieldWithFrame:CGRectMake(0, self.selectView.bottom+10, kDeviceWidth, 40) font:[UIFont systemFontOfSize:MLwordFont_2] textColor:textBlackColor textAlignment:NSTextAlignmentCenter keyboardType:UIKeyboardTypeNumberPad borderStyle:UITextBorderStyleNone placeholder:@"请输入有效手机号 以便我们联系您"];
        _numTextField.backgroundColor = txtColors(236, 237, 239, 1);
        _numTextField.delegate = self;
        numFrame = _numTextField.frame;
    }
    return _numTextField;
}

-(UIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [BaseCostomer buttonWithFrame:CGRectMake(kDeviceWidth/10.0, self.selectView.bottom+44, kDeviceWidth*4/5.0, 48*MCscale) font:[UIFont boldSystemFontOfSize:MLwordFont_2] textColor:[UIColor whiteColor] backGroundColor:txtColors(249, 54, 73, 1) cornerRadius:5.0 text:@"提交" image:@""];
        [_submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}
-(void)initSubViews
{
    [self.view addSubview:self.line1];
    [self.view addSubview:self.opinionTextView];
    [self.view addSubview:self.line2];
    [self.view addSubview:self.selectView];
    [self.view addSubview:self.submitBtn];
}
//手势遮罩
-(void)initMaskView
{
    maskView = [[UIView alloc]initWithFrame:self.view.bounds];
    maskView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [maskView addGestureRecognizer:tap];
}
-(void)submitAction:(UIButton *)btn
{
    NSString *numString;
    BOOL isMatch = [BaseCostomer panduanPhoneNumberWithString:self.numTextField.text];
    BOOL isOk = 0;
    BOOL isMesg = 0;
    if (![self.opinionTextView.text isEqualToString:@"     请留下您的宝贵意见和建议，我们将努力改进"]) {
        isMesg = 1;
    }
    else{
        [self promptMessageWithString:@"反馈意见不能为空"];
        isMesg = 0;
    }
    NSMutableDictionary *pram;
    if(isChooseNum){
        if (isMatch) {
            numString = self.numTextField.text;
            isOk = 1;
        }
        else{
            [self promptMessageWithString:@"手机格式错误"];
        }
    }
    else{
        numString = @"0";
        isOk = 1;
    }
    if (isOk && isMesg) {
        btn.enabled = NO;
        [btn setBackgroundColor:[UIColor grayColor]];
        
        MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mHud.mode = MBProgressHUDModeIndeterminate;
        mHud.delegate = self;
        mHud.labelText = @"努力提交中";
        [mHud show:YES];
        
        pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"yuangong.id":user_id,@"tel":numString,@"content":self.opinionTextView.text}];
        [HTTPTool postWithUrl:@"yijianfankui.action" params:pram success:^(id json) {
            [mHud hide:YES];
            NSString *message =[NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
            if ([message isEqualToString:@"1"]) {
                
                MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                mHud.labelText = @"提交成功";
                mHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
                mHud.mode = MBProgressHUDModeCustomView;
                [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                [self performSelector:@selector(btnAction) withObject:self afterDelay:1.5];
            }
            else{
                [self promptMessageWithString:@"意见反馈失败!请稍后再试"];
            }
            btn.enabled = YES;
            btn.backgroundColor = txtColors(249, 54, 73, 1);
        } failure:^(NSError *error) {
            [mHud hide:YES];
            [self promptMessageWithString:@"网络连接错误"];
        }];
    }
}
-(void)bangdingNumAction
{
    if(isChooseNum == 0){
        self.selectImage.image = [UIImage imageNamed:@"选择"];
        isChooseNum = 1;
        [self.view addSubview:self.numTextField];
        CGRect fram = self.submitBtn.frame;
        fram.origin.y +=40;
        self.submitBtn.frame = fram;
    }
    else{
        self.selectImage.image = [UIImage imageNamed:@"选中"];
        isChooseNum = 0 ;
        [self.numTextField removeFromSuperview];
        CGRect fram = self.submitBtn.frame;
        fram.origin.y -=40;
        self.submitBtn.frame = fram;
    }
}
#pragma mark 键盘弹出与隐藏
//键盘弹出
-(void)keyboardWillShow:(NSNotification *)notifaction
{
    NSDictionary *userInfo = [notifaction userInfo];
    NSValue *userValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [userValue CGRectValue];
    NSTimeInterval animationDuration = [[[notifaction userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView setAnimationDuration:animationDuration];
    CGRect nframe = self.numTextField.frame;
    if(nframe.origin.y>keyboardRect.origin.y-40){
        nframe.origin.y = keyboardRect.origin.y-40;
    }
    self.numTextField.frame = nframe;
    [self.view addSubview:maskView];
}
-(void)promptMessageWithString:(NSString *)string
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mHud.labelText = string;
    mHud.mode = MBProgressHUDModeText;
    [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
-(void)myTask
{
    sleep(1);
}
//键盘隐藏
-(void)keyboardWillHide:(NSNotification *)notifaction
{
    self.numTextField.frame = numFrame;
    [maskView removeFromSuperview];
}

-(void)btnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}
#pragma mark UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqual:@"     请留下您的宝贵意见和建议，我们将努力改进"]) {
        textView.textColor = [UIColor blackColor];
        textView.text = @"";
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqual:@""]) {
        textView.text = @"     请留下您的宝贵意见和建议，我们将努力改进";
        textView.textColor = txtColors(182, 183, 184, 1);
    }
}

#pragma mark UITextfiledDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.numTextField){
        NSInteger leng = textField.text.length;
        NSInteger selectLeng = range.length;
        NSInteger replaceLeng = string.length;
        if (leng - selectLeng + replaceLeng > 11){
            return NO;
        }
        else
            return YES;
    }
    return YES;
}
@end
