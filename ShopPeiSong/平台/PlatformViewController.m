//
//  PlatformViewController.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/6.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "PlatformViewController.h"
#import "PlatformCell.h"
#import "KeQiangDiandanModel.h"
#import "PalmformDetailViewController.h"
#import "Header.h"
#import "ShouYinTaiPayWay.h"
#import "SubLBXScanViewController.h"
#import "PaymentPasswordView.h"
#import "LoginPasswordView.h"

#import "CustomerTabbatViewController.h"
#import "PHMap.h"
#import "daoHangOfXiangqing.h"

#import "OrdersModel.h"
#import "OrderDetailViewController.h"
#import "FenXiangWithLoginAfter.h"
#import "PHPush.h"
#import "PHAlertView.h"
//#import "GestureViewController.h"
#import "UpdateTipView.h"

#import "MoNiSystemAlert.h"

#import "ChainedView.h"

#import "KaiHuChengGongView.h"

#import "MoNiSystemAlert.h"

#import "PHButton.h"

#import "SystemMessageViewController.h"

@interface PlatformViewController ()<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate,PlatformCellDelegate>

@property(nonatomic,strong)UIButton *rightButton;
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)NSMutableArray *keqiangdingdanArray;
@property(nonatomic,assign)BOOL isRefresh,loadType;

@property (nonatomic,strong)UIView * maskView;
//@property(nonatomic,strong)SelectPayWay * selectPayWay;

@property (nonatomic,strong)PaymentPasswordView * passView;

@property (nonatomic,strong)UIImageView * redPoint;

@end

@implementation PlatformViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

//    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:2];
    [self getbumenDataWithStates:@"0"];
    
    NSLog(@"%@",user_Id);
    

    

    NSDictionary * shareDic = loginShareContent;
    NSString * shareContent = [NSString stringWithFormat:@"%@",[shareDic valueForKey:@"kaihufenxiang"]];
    if (![shareContent isEmptyString]) {
        FenXiangWithLoginAfter * fenxiang = [FenXiangWithLoginAfter new];
        NSLog(@"content --- - - %@",loginShareContent);
        [fenxiang appear];
        set_LoginShareContent(@{});
    }
    
    
    sharePush.localBlock=^(NSDictionary *info){
        NSString * type = [NSString stringWithFormat:@"%@",info[@"id"]];
        NSString * value = [NSString stringWithFormat:@"%@",info[@"value"]];
    
        switch ([type integerValue]) {
            case 1:
            {
//                set_Push_SystemValue(value);
                if ([UIApplication sharedApplication].applicationState==UIApplicationStateActive) {
                    [Request getSystemMessageInfoWithMessageId:value success:^(id json) {
                        NSString *filePath2 = [[NSBundle mainBundle] pathForResource:@"systemTui" ofType:@"wav"];
                        //构建URL
                        NSURL *url3 = [NSURL fileURLWithPath:filePath2];
                        //创建系统声音ID
                        SystemSoundID soundID;
                        //注册声音文件，并且将ID保存
                        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url3), &soundID);
                        //播放声音
                        AudioServicesPlaySystemSound(soundID);
                        
                        
                        NSString * title      = [NSString stringWithFormat:@"%@",[json valueForKey:@"image"]];
                        NSString * content    = [NSString stringWithFormat:@"%@",[json valueForKey:@"content"]];
//                        NSString * weiduCount = [NSString stringWithFormat:@"%@",[json valueForKey:@"shuliang"]];
                        
                        MoNiSystemAlert * moni = [MoNiSystemAlert new];
                        moni.title = title;
                        moni.content = content;
        
                        [moni appear];
                    } failure:^(NSError *error) {
                        
                    }];
                    
                    _redPoint.hidden = systemWeiDuCount ==0;
                    
//                    [((AppDelegate *)([UIApplication sharedApplication].delegate)) switchRootController];
                }
            }
                break;
            case 2:
            {
//                PHAlertView * alert = [[PHAlertView alloc]initWithTitle:@"员工信息,是否查看?" message:value delegate:nil cancelButtonTitle:@"忽略" otherButtonTitles:@"查看", nil];
//                [alert show];
//                alert.block=^(NSInteger index){
//                };
            }
                break;
            case 3:
            {
                
                if ([UIApplication sharedApplication].applicationState==UIApplicationStateActive) {
                    NSString *filePath2 = [[NSBundle mainBundle] pathForResource:@"dingdantixng" ofType:@"mp3"];
                    //构建URL
                    NSURL *url3 = [NSURL fileURLWithPath:filePath2];
                    //创建系统声音ID
                    SystemSoundID soundID;
                    //注册声音文件，并且将ID保存
                    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url3), &soundID);
                    //播放声音
                    AudioServicesPlaySystemSound(soundID);
                }
   
                
                
                
                
                PHAlertView * alert = [[PHAlertView alloc]initWithTitle:@"新订单,是否查看?" message:value delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
                [alert show];
                alert.block=^(NSInteger index){
                    if (index==1) {
                        [((CustomerTabbatViewController *)self.navigationController.tabBarController) setCustomIndex:0];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                };
            }
                break;
                
            default:
                break;
        }

        
    };
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     *  开户分享
     */
    [self getUpdateData];
 
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    if (iPhone) {
        
    }
    
    [self setNavigationItem];
    [self refresh];

    

 }
-(BOOL)isRefresh
{
    if (!_isRefresh) {
        _isRefresh = 0;
    }
    return _isRefresh;
}
-(BOOL)loadType
{
    if (!_loadType) {
        _loadType = 0;
    }
    return _loadType;
}
-(UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:self.view.bounds];
        _maskView.backgroundColor = [UIColor clearColor];
        _maskView.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewDisMiss)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

#pragma 设置导航栏
-(UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [BaseCostomer buttonWithFrame:CGRectMake(0, 0, NVbtnWight, NVbtnWight) backGroundColor:[UIColor clearColor] text:@"" image:@"saomiao"];
        [_rightButton addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
-(void)setNavigationItem
{
    [self.navigationItem setTitle:dianPuName];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    PHButton * leftBtn = [[PHButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [leftBtn setImage:[UIImage imageNamed:@"systemMessage"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    _redPoint = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 8, 8)];
    [leftBtn addSubview:_redPoint];
    _redPoint.right = leftBtn.width;
    _redPoint.backgroundColor=redTextColor;
    _redPoint.layer.cornerRadius = _redPoint.width/2;
    _redPoint.hidden=systemWeiDuCount==0;
    
    
    
    [leftBtn addAction:^{
        SystemMessageViewController * message = [SystemMessageViewController new];
        message.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:message animated:YES];
        
        set_SystemWeiDuCount(0);
        _redPoint.hidden=YES;
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }];
    
}

-(void)rightItemClick
{
 
    //设置扫码区域参数设置
    
    //创建参数对象
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    //矩形区域中心上移，默认中心点为屏幕中心点
    style.centerUpOffset = 44;
    
    
    //扫码框周围4个角的类型,设置为外挂式
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    
    //扫码框周围4个角绘制的线条宽度
    style.photoframeLineW = 6;
    
    //扫码框周围4个角的宽度
    style.photoframeAngleW = 24;
    
    //扫码框周围4个角的高度
    style.photoframeAngleH = 24;
    
    //扫码框内 动画类型 --线条上下移动
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //线条上下移动图片
    style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    
    //SubLBXScanViewController继承自LBXScanViewController
    //添加一些扫码或相册结果处理
    SubLBXScanViewController *vc = [SubLBXScanViewController new];
    vc.style = style;
    vc.isQQSimulator = YES;
    vc.isVideoZoom = YES;
    UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
    bar.title=@"";
    self.navigationItem.backBarButtonItem=bar;
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
    vc.block=^(NSString * string){
        [self shouyeJudgeWithRestultString:string];
    };
    //    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
    //    [window addSubview:vc.view];

    
}
-(NSMutableArray *)keqiangdingdanArray
{
    if (!_keqiangdingdanArray) {
        _keqiangdingdanArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _keqiangdingdanArray;
}
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self.view addSubview:_mainTableView];
        [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 49, 0));
        }];
    }
    return _mainTableView;
}

#pragma mark 获得部门信息
-(void)getbumenDataWithStates:(NSString *)states
{
    NSString *zhiwuStr  = [[NSUserDefaults standardUserDefaults]valueForKey:@"bumen"];
    NSString *bumenUrl;
    NSMutableDictionary *pram;
    if ([zhiwuStr isEqualToString:@"配送"]|| [zhiwuStr isEqualToString:@"管理"] ) {
        bumenUrl = @"getKQDingdan.action";
        pram = [NSMutableDictionary dictionaryWithDictionary:@{@"yuangong.id":user_id,@"status":states}];
    }
    else if ([zhiwuStr isEqualToString:@"供应"])
    {
        bumenUrl = @"gongyingDingdan.action";
        pram = [NSMutableDictionary dictionaryWithDictionary:@{@"yuangong.id":user_id}];
    }
    [self getDingdanMessagesWithBumenUrl:bumenUrl AndPram:pram];
}

-(void)getDingdanMessagesWithBumenUrl:(NSString *)bumenUrl AndPram:(NSMutableDictionary *)pram
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mHud.mode = MBProgressHUDModeIndeterminate;
    mHud.delegate = self;
    mHud.labelText = @"请稍等...";
    [mHud show:YES];
    [HTTPTool postWithUrl:bumenUrl params:pram success:^(id json) {
        [mHud hide:YES];
        NSLog(@"可抢订单 %@",json);
        if (self.isRefresh) {
            [self endRefresh];
        }
        
        [self.keqiangdingdanArray removeAllObjects];

        NSString * message = [json valueForKey:@"message"];
        if (!isZaiGang) {
            message = @"2";
        }
        
        if ([message integerValue]== 1) {
            [self promptMessageWithString:@"无此员工"];
        }
        else if ([message integerValue] == 2)
        {
            [self tableIsEmpty];
        }
        else
        {
            self.mainTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白底.jpg"]];
            NSArray *diandanList = [json valueForKey:@"dingdanlist"];
            
        
            for (NSDictionary *dic in diandanList) {
                KeQiangDiandanModel *model = [[KeQiangDiandanModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.keqiangdingdanArray addObject:model];
            }
        }
    
        
        [self.mainTableView reloadData];
        [self showGuideImageWithUrl:@"images/caozuotishi/saoma.png"];
        

    } failure:^(NSError *error) {
        [mHud hide:YES];
        [self promptMessageWithString:@"网络连接错误1"];
    }];
}
-(void)tableIsEmpty{
    if (isZaiGang) {
        self.mainTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"订单无内容"]];
    }else{
        self.mainTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ligangla"]];
    }

}
#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.keqiangdingdanArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    PlatformCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PlatformCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.platformDelagete = self;
    [cell reloadDataWithIndexpath:indexPath AndArray:self.keqiangdingdanArray];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    KeQiangDiandanModel *model = self.keqiangdingdanArray[indexPath.row];
    
    
    /**
     *   收银台
     */
     NSString * peisongfs = [NSString stringWithFormat:@"%@",model.peisongfangshi];
     BOOL isBenDi = [peisongfs isEqualToString:@"0"] || [peisongfs isEqualToString:@"3"]; //
    if (isBenDi) { // 本地 购买 显示收银台
        NSLog(@"%@",user_ShouYingTaiQX?@"YES":@"NO");
        if (!user_ShouYingTaiQX) { // 如果没有收银台权限 直接略过
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [MBProgressHUD promptWithString:@"没有权限进入收银台"];
            return;
        };
     
        ShouYinTaiPayWay * selePay = [ShouYinTaiPayWay new];
        selePay.danhao=model.danhao;
        [selePay appear];
        selePay.block=^(){
            [self getbumenDataWithStates:@"0"];
        };
        return;
    };
    
    /**
     *  进入详情
//     */
    if ([user_BuMen isEqualToString:@"管理"] || [user_BuMen isEqualToString:@"供应"]) {//
        PalmformDetailViewController *DetailVC = [[PalmformDetailViewController alloc]init];
        DetailVC.danhao = model.danhao;
        DetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:DetailVC animated:YES];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [MBProgressHUD promptWithString:@"配送员不能进入详情"];
    }
 
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100*MCscale;
}
// 添加侧滑按钮
//-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewRowAction * action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"查看详情" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        NSString *zhiwuStr  = [[NSUserDefaults standardUserDefaults]valueForKey:@"bumen"];
//        if ([zhiwuStr isEqualToString:@"供应"]|| [zhiwuStr isEqualToString:@"管理"] ) {
//           
//        
//        }
//    }];
//    return nil;
////    return @[action];
//    
//}


#pragma mark PlatformCellDelegate
-(void)qiangdanButtonClickWithDanhao:(NSString *)danhao
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mHud.mode = MBProgressHUDModeIndeterminate;
    mHud.delegate = self;
    mHud.labelText = @"请稍等...";
    [mHud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"yuangong.id":user_id,@"danhao":danhao}];
    [HTTPTool getWithUrl:@"qiangdan.action" params:pram success:^(id json) {
        NSLog(@"抢单%@",json);
        [mHud hide:YES];
        if ([[json valueForKey:@"message"]integerValue] == 0) {
            [self promptMessageWithString:@"参数不能为空"];
        }
        else if ([[json valueForKey:@"message"]integerValue] == 2)
        {
            [self promptMessageWithString:@"该订单已被抢"];
        }
        else
        {
            [((CustomerTabbatViewController *)self.navigationController.tabBarController) setCustomIndex:1];
            
            [self getbumenDataWithStates:@"0"];
            MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mHud.labelText = @"抢单成功";
            mHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
            mHud.mode = MBProgressHUDModeCustomView;
            [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
    } failure:^(NSError *error) {
        [mHud hide:YES];
        [self promptMessageWithString:@"网络连接错误2"];
    }];
}
-(void)jinRuXiangQing:(NSString *)danhao{
    

    OrdersModel *model = [OrdersModel new];
    model.button=@"6";
    OrderDetailViewController *orderDetailVC = [[OrderDetailViewController alloc]init];
    orderDetailVC.hidesBottomBarWhenPushed = YES;
    orderDetailVC.viewTag = 1;
    orderDetailVC.danhao = danhao;
    orderDetailVC.model = model;
    [self.navigationController pushViewController:orderDetailVC animated:YES];

}
-(void)refresh
{
    //下拉刷新
    [self.mainTableView addHeaderWithTarget:self action:@selector(headReFreshing)];
    self.mainTableView.headerPullToRefreshText = @"下拉刷新数据";
    self.mainTableView.headerReleaseToRefreshText = @"松开刷新";
    self.mainTableView.headerRefreshingText = @"拼命加载中";
}
-(void)headReFreshing
{
    self.isRefresh = 1;
    if (self.loadType) {
        [self getbumenDataWithStates:@"1"];
    }
    else
    {
    [self getbumenDataWithStates:@"0"];
    }
    self.loadType = 1;
}

-(void)endRefresh
{
    [self.mainTableView headerEndRefreshing];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)maskViewDisMiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        [self.maskView removeFromSuperview];
        [self.view endEditing:YES];

        
        self.passView.alpha=0;
        [self.passView removeFromSuperview];
    }];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark --- 二维码的处理事件
-(void)shouyeJudgeWithRestultString:(NSString *)resultStr{
//        resultStr = @" http://www.shp360.com/Store/suijishu=1494043347898&leixing=2";
    
    
    NSString * containStr = @"www.shp360.com/Store/";
    if (![resultStr containsString:containStr]){
        [MBProgressHUD promptWithString:@"不是有效的二维码"];
        return;
    }
    NSRange containRange = [resultStr rangeOfString:containStr];
    NSString * str1 = [resultStr substringWithRange:NSMakeRange(containRange.location+containRange.length, resultStr.length-(containRange.location+containRange.length))];
    
    
    
    if ([str1 containsString:@"?"]) {
        NSRange containRange1 = [str1 rangeOfString:@"?"];
        NSString * str2 = [str1 substringWithRange:NSMakeRange(containRange1.location+containRange1.length, str1.length-(containRange1.location+containRange1.length))];
        
        str1=str2;
    }
    
    
    
    NSArray * strs = [str1 componentsSeparatedByString:@"&"];
    

    
    NSMutableDictionary * contentDic = [NSMutableDictionary dictionary];///获得的所有内容
    for (NSString * str in strs) {
        NSArray<NSString *> * str1s = [str componentsSeparatedByString:@"="];
        NSDictionary * dic = @{str1s.firstObject:str1s.lastObject};
        [contentDic addEntriesFromDictionary:dic];
    }
    
    
    
    BOOL isValidEr = NO;
    isValidEr = [contentDic.allKeys containsObject:@"leixing"];
    
    if (!isValidEr) {
        [MBProgressHUD promptWithString:@"不包含类型值的无效二维码链接"];
        return;
    }
    
    
    //    [MBProgressHUD promptWithString:[NSString stringWithFormat:@"%@",contentDic]];
    NSString * leixing = [contentDic valueForKey:@"leixing"];
    switch ([leixing integerValue]) {
        case 0://
        {
            
        }
            break;
        case 1:// pc 登录
        {
            
            NSString * suijisu = [contentDic valueForKey:@"suijishu"];
            NSInteger nowInter = [NSDate timeIntervalSinceReferenceDate];
            
            
            if ([suijisu integerValue] > nowInter + 1000 * 3 ) {
                
                
                NSDictionary * dic = @{@"yuangongid":user_Id,
                                       @"suijishu":suijisu};
                
                
                [Request pcLoginWithScanWithDic:dic success:^(id json) {
                  [MBProgressHUD promptWithString:@"登陆成功"];
                } failure:^(NSError *error) {
                   
                }];
            }
            
            
        }
            break;
        case 2:// 扫码支付
        {
//            NSString * suijisu = [NSString stringWithFormat:@"%@",[contentDic valueForKey:@"suijishu"]];
//            NSString * yuangoId = [NSString stringWithFormat:@"%@",[contentDic valueForKey:@"yuangongid"]];
            NSString * yingyongId = [NSString stringWithFormat:@"%@",[contentDic valueForKey:@"yid"]];

            NSDictionary * pram = @{@"yuangongid":user_Id,
                                    @"yingyongid":yingyongId};
            
            __block PlatformViewController * weakSelf = self;
            [Request getMoneyIsEnoughWithDic:pram success:^(id json) {
                NSString * message = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
                if ([message isEqualToString:@"0"]) {//余额不足
                    [MBProgressHUD promptWithString:@"余额不足"];
                    
                    return ;
                }else{// 余额充足
                    //
                    [UIView animateWithDuration:0.3 animations:^{
                        self.maskView.alpha = 1;
                        [self.view addSubview:self.maskView];
                        self.passView.alpha = 0.95;
                        [self.view addSubview:self.passView];
                        [self.passView bringSubviewToFront:self.view];
                    } completion:^(BOOL finished) {
                        self.passView.block=^(){// 密码输入正确
//                            [self maskViewDisMiss];
                            [weakSelf maskViewDisMiss];
                            
                            [contentDic addEntriesFromDictionary:@{@"yuangongid":user_Id}];
                            
                            [Request payBySaomaWithDic:contentDic success:^(id json) {
                                
                                [MBProgressHUD promptWithString:@"支付成功!"];
                                
                            } failure:^(NSError *error) {
                                
                            }];
                            
                            
                        };
                    }];
   
                }

            } failure:^(NSError *error) {
                
            }];
        
        }
            break;
            
        default:
            break;
    }
}
#pragma mark -- 懒加载
-(PaymentPasswordView *)passView
{
    if (!_passView) {
        _passView = [[PaymentPasswordView alloc]initWithFrame:CGRectMake(40*MCscale, 100*MCscale, kDeviceWidth - 80*MCscale, 320*MCscale)];
        _passView.centerY=kDeviceHeight/2;
        
        //        [_passView reloadDataWithViewTag:100];
    }
    return _passView;
}
//获取后台版本(版本更新有关)
-(void)getUpdateData
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"banbenhao":appCurVersionNum,@"xitong":@"4"}];
    
//    [NSString stringWithFormat:@"%@%@",HTTPWeb];
    
    [HTTPTool getWithBaseUrl:HTTPShop url:@"banbenNew.action" params:pram success:^(id json) {
            NSString *message = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
                if ([message isEqualToString:@"3"]) {
                    NSString * jibie = [NSString stringWithFormat:@"%@",[json valueForKey:@"jibie"]];
                    NSString * description = [NSString stringWithFormat:@"%@",[json valueForKey:@"shuoming"]];
                   description = [description stringByReplacingOccurrencesOfString:@"#" withString:@"\n"];
                    
                    UpdateTipView * update = [UpdateTipView new];
                    __block UpdateTipView * weakUp = update;
                    update.content = description;
                    [update appear];
                    update.block=^(NSInteger index){
                        if (index == 0) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stor_url]];
                        }else{
                            if ([jibie isEqualToString:@"1"]) {
                                exit(0);
                            }
                        }
                        [weakUp disAppear];
                    };
                    
                }
        
    } failure:^(NSError *error) {
        
    }];
}

@end
