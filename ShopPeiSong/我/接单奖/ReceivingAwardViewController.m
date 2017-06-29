//
//  ReceivingAwardViewController.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/9.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "ReceivingAwardViewController.h"
#import "ReceivingCellOne.h"
#import "ReceivingCellTwo.h"
#import "ReceivedDingdanModel.h"
#import "ReceivedModelTwo.h"
#import "OrderDetailViewController.h"
#import "DataAggregateViewController.h"
#import "Header.h"
@interface ReceivingAwardViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)UIButton *leftButton;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)NSArray *nameArray;
@property(nonatomic,strong)NSMutableArray *recordArray,*DataAggregateArray;
@end

@implementation ReceivingAwardViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headView];
    [self.view addSubview:self.mainTableView];
    [self setNavigationItem];
    [self getRecentRecordData];
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
    [self.navigationItem setTitle:@"接单奖励"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName, nil]];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}
-(NSArray *)nameArray
{
    if (!_nameArray) {
        if ([user_show integerValue] == 1) {
            _nameArray = @[@"接单金额",@"当前接单",@"未评价"];
        }
        else if ([user_show integerValue] == 2)
        {
        _nameArray = @[@"接单奖励",@"当前接单",@"未评价"];
        }
    }
    return _nameArray;
}
-(UIView *)headView
{
    if (!_headView) {
        _headView = [BaseCostomer viewWithFrame:CGRectMake(0,64, kDeviceWidth,70*MCscale) backgroundColor:[UIColor clearColor]];
        for (int i = 0; i < 3; i ++) {
            UILabel *label = [BaseCostomer labelWithFrame:CGRectMake(kDeviceWidth/3.0*i, 10*MCscale, kDeviceWidth/3.0, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_5] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter numOfLines:1 text:self.nameArray[i]];
            [_headView addSubview:label];
            
            UILabel *countlabel = [BaseCostomer labelWithFrame:CGRectMake(kDeviceWidth/3.0*i,label.bottom+5*MCscale, kDeviceWidth/3.0,30*MCscale) font:[UIFont boldSystemFontOfSize:MLwordFont_1] textColor:redTextColor backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter numOfLines:1 text:@""];
            countlabel.tag = 1100+i;
            [_headView addSubview:countlabel];
            
            if (i<2) {
                UIView *line = [BaseCostomer viewWithFrame:CGRectMake(kDeviceWidth/3.0*(i+1), 5*MCscale, 1,60*MCscale) backgroundColor:lineColor];
                [_headView addSubview:line];
            }
        }
    }
    return _headView;
}
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,self.headView.bottom,kDeviceWidth, kDeviceHeight - 64-70*MCscale) style:UITableViewStyleGrouped];
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

#pragma mark 获取近期记录
-(void)getRecentRecordData
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mHud.mode = MBProgressHUDModeIndeterminate;
    mHud.delegate = self;
    mHud.labelText = @"请稍等...";
    [mHud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"yuangong.id":user_id,@"jiedan":self.jiadanMoney}];
    [HTTPTool getWithUrl:@"jinqiDingdan.action" params:pram success:^(id json){
        [mHud hide:YES];
        NSLog(@"近期记录 %@",json);
        if ([[json valueForKey:@"message"]integerValue]== 2){
            [self promptMessageWithString:@"参数不能为空"];
        }
        else if([[json valueForKey:@"message"]integerValue]== 3)
        {
//            [self promptMessageWithString:@"无可显示订单"];
        }
        else
        {
            NSArray *dingdanInfo = [json valueForKey:@"dingdaninfo"];
            for (NSDictionary *dict in dingdanInfo) {
                ReceivedDingdanModel *model = [[ReceivedDingdanModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.recordArray addObject:model];
            }
            
            UILabel *jiadanjiangliLabel = [self.headView viewWithTag:1100];
            UILabel *dangqianjiadanLabel = [self.headView viewWithTag:1101];
            UILabel *weipingjiaLabel = [self.headView viewWithTag:1102];
            jiadanjiangliLabel.text = [NSString stringWithFormat:@"%@",[json valueForKey:@"jiedan"]];
            dangqianjiadanLabel.text = [NSString stringWithFormat:@"%@",[json valueForKey:@"dangqianjiedan"]];
            weipingjiaLabel.text = [NSString stringWithFormat:@"%@",[json valueForKey:@"weipingjia"]];
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
    [HTTPTool getWithUrl:@"fentian.action" params:pram success:^(id json){
        [mHud hide:YES];
        NSLog(@"近期记录合计信息 %@",json);
        if ([[json valueForKey:@"message"]integerValue]== 2){
            [self promptMessageWithString:@"参数不能为空"];
        }
        else if([[json valueForKey:@"message"]integerValue]== 3)
        {
//            [self promptMessageWithString:@"无可显示订单"];
        }
        else
        {
            NSArray *listinfo = [json valueForKey:@"listinfo"];
            for (NSDictionary *dict in listinfo) {
                ReceivedModelTwo *model = [[ReceivedModelTwo alloc]init];
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
    ReceivingCellOne *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ReceivingCellOne alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
        [cell reloadDataWithIndexPath:indexPath AndArray:self.recordArray];
    return cell;
    }
    else
    {
        static NSString *identifier = @"cellTwo";
        ReceivingCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[ReceivingCellTwo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell reloadDataWithIndexPath:indexPath AndArray:self.DataAggregateArray];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        ReceivedDingdanModel *model = self.recordArray[indexPath.row];
        OrderDetailViewController *orderDetailVC = [[OrderDetailViewController alloc]init];
        orderDetailVC.viewTag = 2;
        orderDetailVC.hidesBottomBarWhenPushed = YES;
        orderDetailVC.danhao = model.danhao;
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    }
    else
    {
        ReceivedModelTwo *model = self.DataAggregateArray[indexPath.row];
        DataAggregateViewController *DataAggregateVC = [[DataAggregateViewController alloc]init];
        DataAggregateVC.hidesBottomBarWhenPushed = YES;
        DataAggregateVC.dateStr = model.date;
        DataAggregateVC.ViewTag = 2;
        [self.navigationController pushViewController:DataAggregateVC animated:YES];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [BaseCostomer viewWithFrame:CGRectMake(0, 10*MCscale, kDeviceWidth, 30*MCscale) backgroundColor:[UIColor clearColor]];
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

