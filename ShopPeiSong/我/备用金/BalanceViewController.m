//
//  BalanceViewController.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/24.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "BalanceViewController.h"
#import "BalanceCell.h"
#import "BalanceRecordCell.h"
#import "BalanceModel.h"
#import "BalanceRecordModel.h"
#import "PaymentPasswordView.h"
#import "getBalanceViewController.h"
#import "DataAggregateViewController.h"
#import "ShuomingView.h"
#import "OnLinePayView.h"
#import "Header.h"
#import "XuFeiViewController.h"
#import "TopUpView.h"

@interface BalanceViewController()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate,PaymentPasswordViewDelegate,BalanceCellDelegate>
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)UIButton *leftButton;
@property(nonatomic,strong)UILabel *yueLabel,*moneyLabel;
@property(nonatomic,strong)UIView *headView,*maskView;
@property(nonatomic,strong)NSMutableArray *recordArray,*DataAggregateArray;
@property(nonatomic,strong)NSString *quanxianStr;
@property(nonatomic,strong)PaymentPasswordView *passPopView;
@property(nonatomic,strong)ShuomingView *shuomingView;
@property(nonatomic,strong)OnLinePayView *rechargePopView;//充值弹框
@end

@implementation BalanceViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationItem];
    [self getRecentRecordData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainTableView];

    [self getRecentRecordDataAggregate];
}
#pragma mark 设置导航栏
-(UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [BaseCostomer buttonWithFrame:CGRectMake(0, 0, NVbtnWight, NVbtnWight) backGroundColor:[UIColor clearColor] text:@"" image:@"返回按钮"];
        [_leftButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
-(void)setNavigationItem
{
    [self.navigationItem setTitle:@"账户记录"];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName, nil]];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
//    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"续费" style:UIBarButtonItemStyleDone target:self action:@selector(xufei)];
//    self.navigationItem.rightBarButtonItem= rightItem;
}
-(void)xufei{
    [self.navigationController pushViewController:[XuFeiViewController new] animated:YES];
}

-(UILabel *)yueLabel
{
    if (!_yueLabel) {
        _yueLabel = [BaseCostomer labelWithFrame:CGRectMake(20*MCscale, 10*MCscale, 100*MCscale, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_7] textColor:textColors text:@"当前余额"];
        _yueLabel.backgroundColor = [UIColor clearColor];
        [self.headView addSubview:self.yueLabel];
    }
    return _yueLabel;
}

-(UILabel *)moneyLabel
{
    if (!_moneyLabel) {
        _moneyLabel = [BaseCostomer labelWithFrame:CGRectMake(40*MCscale,self.yueLabel.bottom + 5*MCscale,kDeviceWidth - 80*MCscale, 30*MCscale) font:[UIFont boldSystemFontOfSize:MLwordFont_1] textColor:redTextColor text:@"0.00元"];
        _moneyLabel.backgroundColor = [UIColor clearColor];
        [self.headView addSubview:self.moneyLabel];
    }
    return _moneyLabel;
}
-(UIView *)headView
{
    if (!_headView) {
        _headView = [BaseCostomer viewWithFrame:CGRectMake(0,64, kDeviceWidth,130*MCscale) backgroundColor:[UIColor clearColor]];
        
        NSArray *buttonTitle = @[@"余额提现",@"充值"];
        for (int i = 0; i<2; i++) {
            UIButton *button = [BaseCostomer buttonWithFrame:CGRectMake((120*MCscale+(kDeviceWidth - 40*MCscale - 240*MCscale))*i+20*MCscale, self.moneyLabel.bottom +15*MCscale, 120*MCscale,35*MCscale) font:[UIFont systemFontOfSize:MLwordFont_2] textColor:[UIColor whiteColor] backGroundColor:redTextColor cornerRadius:3.0 text:buttonTitle[i] image:@""];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 1200+i;
            if (i == 1) {
                button.backgroundColor = mainColor;
            }
            [_headView addSubview:button];
        }
        [self.view addSubview:self.headView];
    }
    return _headView;
}
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,self.headView.bottom,kDeviceWidth, kDeviceHeight - 64-130*MCscale) style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return _mainTableView;
}

-(NSMutableArray *)recordArray
{
    if (!_recordArray) {
        _recordArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _recordArray;
}
-(NSMutableArray *)DataAggregateArray
{
    if (!_DataAggregateArray) {
        _DataAggregateArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _DataAggregateArray;
}

-(UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64)];
        _maskView.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewDisMiss)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}
-(PaymentPasswordView *)passPopView
{
    if (!_passPopView) {
        //支付密码
        _passPopView = [[PaymentPasswordView alloc]initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 360*MCscale)];
        _passPopView.paymentPasswordDelegate = self;
        _passPopView.alpha = 0;
    }
    return _passPopView;
}

-(ShuomingView *)shuomingView
{
    if (!_shuomingView) {
        _shuomingView = [[ShuomingView alloc]initWithFrame:CGRectMake(30*MCscale, 180*MCscale, kDeviceWidth-60*MCscale, 200*MCscale)];
    }
    return _shuomingView;
}
-(OnLinePayView *)rechargePopView
{
    if (!_rechargePopView) {
        _rechargePopView = [[OnLinePayView alloc]initWithFrame:CGRectMake(30*MCscale, 180*MCscale, kDeviceWidth - 60*MCscale, 220*MCscale)];
    }
    return _rechargePopView;
}

/**
 
 nextPayPas  = [[SetPaymentPasswordView alloc] initWithFrame:CGRectMake(kDeviceWidth/20.0, 180*MCscale, kDeviceWidth*9/10.0, 232*MCscale)];
 nextPayPas.setPaymentDelegate = self;
 nextPayPas.alpha = 0;
 nextPayPas.tag = 101;
 
 rechargePopView = [[OnLinePayView alloc]initWithFrame:CGRectMake(30*MCscale, 180*MCscale, kDeviceWidth - 60*MCscale, 260*MCscale)];
 */
#pragma mark 获取近期记录
-(void)getRecentRecordData
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mHud.mode = MBProgressHUDModeIndeterminate;
    mHud.delegate = self;
    mHud.labelText = @"请稍等...";
    [mHud show:YES];
    
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"yuangong.id":user_id}];
    [HTTPTool getWithUrl:@"zhanghuRecord.action" params:pram success:^(id json){
        [mHud hide:YES];
        NSLog(@"近期记录 %@",json);
        [self.recordArray removeAllObjects];
        
        
//        if (![[NSString stringWithFormat:@"%@",[json valueForKey:@"xufei"]] isEqualToString:@"1"]) {
//            self.navigationItem.rightBarButtonItem=nil;
//        }
        
        
        if ([[json valueForKey:@"message"]integerValue]== 1){
            [self promptMessageWithString:@"参数不能为空"];
        }
        else if([[json valueForKey:@"message"]integerValue]== 1)
        {
            [self promptMessageWithString:@"无账户记录"];
        }
        else
        {
            NSArray *dingdanInfo = [json valueForKey:@"listzhanghu"];
            for (NSDictionary *dict in dingdanInfo) {
                BalanceModel *model = [[BalanceModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.recordArray addObject:model];
            }
            
            NSString * money = [NSString stringWithFormat:@"%@",[json valueForKey:@"money"]];
            money = [money isEmptyString]?@"0":money;
            
            
            self.moneyLabel.text = [NSString stringWithFormat:@"%@元",money];
            self.quanxianStr = [NSString stringWithFormat:@"%@",[json valueForKey:@"quanxian"]];
        }
        [self.mainTableView reloadData];
        
    } failure:^(NSError *error) {
        [mHud hide:YES];
        [self promptMessageWithString:@"网络连接错误"];
    }];
}
#pragma mark 获取前日记录
-(void)getRecentRecordDataAggregate
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mHud.mode = MBProgressHUDModeIndeterminate;
    mHud.delegate = self;
    mHud.labelText = @"请稍等...";
    [mHud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"yuangong.id":user_id}];
    [HTTPTool getWithUrl:@"zhanghuRecordByDay.action" params:pram success:^(id json){
        [mHud hide:YES];
        NSLog(@"近期记录合计信息 %@",json);
        [self.DataAggregateArray removeAllObjects];
        
        if ([[json valueForKey:@"message"]integerValue]== 2){
            [self promptMessageWithString:@"参数不能为空"];
        }
        else if([[json valueForKey:@"message"]integerValue]== 3)
        {
            [self promptMessageWithString:@"无账户记录"];
        }
        else
        {
            NSArray *listinfo = [json valueForKey:@"zhangdanlist"];
            for (NSDictionary *dict in listinfo) {
                BalanceRecordModel *model = [[BalanceRecordModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.DataAggregateArray addObject:model];
            }
        }
        [self.mainTableView reloadData];
        
    } failure:^(NSError *error) {
        [mHud hide:YES];
        [self promptMessageWithString:@"网络连接错误"];
    }];
}
#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.DataAggregateArray.count !=0) return 2;
    else return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return self.recordArray.count;
    else return self.DataAggregateArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *identifier = @"cell";
        BalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[BalanceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.balanceDelegate = self;
        [cell reloadDataWithIndexPath:indexPath AndArray:self.recordArray];
        return cell;
    }
    else
    {
        static NSString *identifier = @"cellTwo";
        BalanceRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[BalanceRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell reloadDataWithIndexPath:indexPath AndArray:self.DataAggregateArray];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        BalanceRecordModel *model = self.DataAggregateArray[indexPath.row];
        DataAggregateViewController *DataAggregateVC = [[DataAggregateViewController alloc]init];
        DataAggregateVC.hidesBottomBarWhenPushed = YES;
        DataAggregateVC.dateStr = model.date;
        DataAggregateVC.ViewTag = 1;
        [self.navigationController pushViewController:DataAggregateVC animated:YES];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [BaseCostomer viewWithFrame:CGRectMake(0, 10, kDeviceWidth, 30*MCscale) backgroundColor:[UIColor clearColor]];
    UILabel *label = [BaseCostomer labelWithFrame:CGRectMake(0,0, kDeviceWidth, view.height) font:[UIFont systemFontOfSize:MLwordFont_2] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter numOfLines:1 text:@""];
    [view addSubview:label];
    if (section == 0) {
        label.text = @"近期记录";
    }
    else
    {
        label.text = @"前日记录";
    }
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70*MCscale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30*MCscale;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
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

-(void)buttonClick:(UIButton *)button
{
    if (button.tag == 1200) {//余额提现
       
        
        if ([self.quanxianStr isEqualToString:@"1"]) {
            [UIView animateWithDuration:0.3 animations:^{
                self.maskView.alpha = 1;
                [self .view addSubview:self.maskView];
                self.passPopView.alpha = 0.95;
                [self.view addSubview:self.passPopView];
            }];
        }
        else if ([self.quanxianStr isEqualToString:@"2"])
        {
            [self promptMessageWithString:@"未授权"];
        }
        else if ([self.quanxianStr isEqualToString:@"3"])
        {
            [self promptMessageWithString:@"今天已提现"];
        }
        else if ([self.quanxianStr isEqualToString:@"4"])
        {
            [self promptMessageWithString:@"未设置提现密码"];
        }else{
            [MBProgressHUD promptWithString:@"不能提现"];
        }
    }
    else
    {
        
        TopUpView * topup = [TopUpView new];
        __block TopUpView * weakTopup =topup;
        [topup setMoney:50 limitMoney:50 title:[NSString stringWithFormat:@"妙生活城+%@备用金充值",user_tel] body:user_Id canChange:YES];
        topup.payBlock=^(BOOL isSuccess){
            [weakTopup disAppear];
            if (isSuccess) {// 成功
                getBalanceViewController *balVc = [[getBalanceViewController alloc]init];
                balVc.hidesBottomBarWhenPushed = YES;
                UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
                bar.title=@"";
                //        bar.image = [UIImage imageNamed:@"返回"];
                self.navigationItem.backBarButtonItem=bar;
                [self.navigationController pushViewController:balVc animated:YES];
            
                
                [MBProgressHUD promptWithString:@"充值成功"];
            }else{
                [MBProgressHUD promptWithString:@"充值失败"];
            }
            
        };
        [topup appear];
        
        
//        //充值
//        [UIView animateWithDuration:0.3 animations:^{
//            self.maskView.alpha = 1;
//            [self.view addSubview:self.maskView];
//            self.rechargePopView.alpha = 0.95;
//            [self.view addSubview:self.rechargePopView];
//        }];
    }
}

#pragma  mark  PaymentPasswordViewDelegate
-(void)PaymentSuccess
{
    [self maskViewDisMiss];
    //
    getBalanceViewController *balVc = [[getBalanceViewController alloc]init];
    balVc.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
    bar.title=@"";
    //        bar.image = [UIImage imageNamed:@"返回"];
    self.navigationItem.backBarButtonItem=bar;
    [self.navigationController pushViewController:balVc animated:YES];
}

#pragma mark BalanceDelegate(账单说明)
-(void)getZhangdanShuomingDataWithZhangdanID:(NSString *)zhangdanId
{
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 1;
        [self .view addSubview:self.maskView];
        self.shuomingView.alpha = 0.95;
        [self.shuomingView reloadDataWithZhangdanId:zhangdanId];
        [self.view addSubview:self.shuomingView];
    }];
}
-(void)maskViewDisMiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        [self.maskView removeFromSuperview];
        //        nextPayPas.alpha = 0;
        //        [nextPayPas removeFromSuperview];
        self.rechargePopView.alpha = 0;
        [self.rechargePopView removeFromSuperview];
        [self.view endEditing:YES];
        self.shuomingView.alpha = 0;
        [self.shuomingView removeFromSuperview];
        self.passPopView.alpha = 0;
        [self.passPopView removeFromSuperview];
    }];
}

-(void)btnAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

