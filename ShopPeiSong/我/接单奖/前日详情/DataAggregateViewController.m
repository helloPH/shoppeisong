//
//  DataAggregateViewController.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/30.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "DataAggregateViewController.h"
#import "ReceivingCellOne.h"
#import "ReceivedDingdanModel.h"
#import "OrderDetailViewController.h"
#import "BalanceModel.h"
#import "BalanceCell.h"
#import "Header.h"
#import "ShuomingView.h"

@interface DataAggregateViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate,BalanceCellDelegate>
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)UIButton *leftButton;
@property(nonatomic,strong)NSMutableArray *recordArray;
@property(nonatomic,strong)UIView *maskView;
@property(nonatomic,strong)ShuomingView *shuomingView;

@end

@implementation DataAggregateViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationItem];
    if (self.ViewTag == 1) {//备用金
        [self getBalanceRecordData];
    }
    else
    {//接单奖
        [self getRecentRecordData];
        
    }
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
    [self.navigationItem setTitle:@"前日详情"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName, nil]];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64,kDeviceWidth, kDeviceHeight - 64) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self.view addSubview:_mainTableView];
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
-(ShuomingView *)shuomingView
{
    if (!_shuomingView) {
        _shuomingView = [[ShuomingView alloc]initWithFrame:CGRectMake(30*MCscale, 180*MCscale, kDeviceWidth-60*MCscale, 200*MCscale)];
    }
    return _shuomingView;
}
#pragma mark 获取近期余额记录
-(void)getBalanceRecordData
{
    [self.recordArray removeAllObjects];
    
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mHud.mode = MBProgressHUDModeIndeterminate;
    mHud.delegate = self;
    mHud.labelText = @"请稍等...";
    [mHud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"yuangong.id":user_id,@"date":self.dateStr}];
    [HTTPTool getWithUrl:@"zhanghuRecordByDayInfo.action" params:pram success:^(id json){
        [mHud hide:YES];
        NSLog(@"近期记录 %@",json);
        
        if ([[json valueForKey:@"message"]integerValue]== 1){
            [self promptMessageWithString:@"参数不能为空"];
        }
        else if([[json valueForKey:@"message"]integerValue]== 2)
        {
            [self promptMessageWithString:@"暂无记录"];
        }
        else
        {
            NSArray *dingdanInfo = [json valueForKey:@"listzhanghu"];
            for (NSDictionary *dict in dingdanInfo) {
                BalanceModel *model = [[BalanceModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.recordArray addObject:model];
            }
            
        }
        [self.mainTableView reloadData];
    } failure:^(NSError *error) {
        [mHud hide:YES];
        [self promptMessageWithString:@"网络连接错误"];
    }];
}
#pragma mark 获取近期接单记录
-(void)getRecentRecordData
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mHud.mode = MBProgressHUDModeIndeterminate;
    mHud.delegate = self;
    mHud.labelText = @"请稍等...";
    [mHud show:YES];
    [self.recordArray removeAllObjects];
    
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"yuangong.id":user_id,@"date":self.dateStr}];
    [HTTPTool getWithUrl:@"fentianPeisongInfo.action" params:pram success:^(id json){
        [mHud hide:YES];
        NSLog(@"近期记录 %@",json);
        if ([[json valueForKey:@"message"]integerValue]== 2){
            [self promptMessageWithString:@"参数不能为空"];
        }
        else if([[json valueForKey:@"message"]integerValue]== 3)
        {
            [self promptMessageWithString:@"无可显示订单"];
        }
        else
        {
            NSArray *dingdanInfo = [json valueForKey:@"listinfo"];
            for (NSDictionary *dict in dingdanInfo) {
                ReceivedDingdanModel *model = [[ReceivedDingdanModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.recordArray addObject:model];
            }
        }
        [self.mainTableView reloadData];
    } failure:^(NSError *error) {
        [mHud hide:YES];
        [self promptMessageWithString:@"网络连接错误"];
    }];
}

#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recordArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.ViewTag == 1) {
        static NSString *identifier = @"BalanceCell";
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
        static NSString *identifier = @"ReceivingCellOne";
        ReceivingCellOne *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[ReceivingCellOne alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell reloadDataWithIndexPath:indexPath AndArray:self.recordArray];
        return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.ViewTag == 2){
        ReceivedDingdanModel *model = self.recordArray[indexPath.row];
        OrderDetailViewController *orderDetailVC = [[OrderDetailViewController alloc]init];
        orderDetailVC.viewTag = 2;
        orderDetailVC.hidesBottomBarWhenPushed = YES;
        orderDetailVC.danhao = model.danhao;
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70*MCscale;
}
-(void)promptMessageWithString:(NSString *)string
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mHud.labelText = string;
    mHud.mode = MBProgressHUDModeText;
    [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
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
        [self.view endEditing:YES];
        self.shuomingView.alpha = 0;
        [self.shuomingView removeFromSuperview];
    }];
}

-(void)myTask
{
    sleep(1);
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


