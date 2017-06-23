//
//  PersonViewController.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/19.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "PersonViewController.h"
#import "Header.h"
#import "PersonTableViewCell.h"
#import "PHAlertView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <sharesdkui/SSUIShareActionSheetStyle.h>


#import "BalanceViewController.h"
#import "ReceivingAwardViewController.h"
#import "InvitationViewController.h"
#import "ShopManagerViewController.h"
#import "ShangpinManageViewController.h"
#import "helpCenterViewController.h"
#import "SuperNavigationView.h"
#import "SecurityViewController.h"
#import "ShopDetailViewController.h"


#import "ReviewSelectedView.h"


#import "QianDaoView.h"

@interface PersonViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

/**
 *   数据属性
 */
@property (nonatomic,strong)NSArray * tableContentArray;

@property (nonatomic,strong)NSMutableDictionary * personDic;

/**
 *  视图属性
 */
@property (nonatomic,strong)UIView * navi;

@property (nonatomic,strong)UITableView * mainTableView;
@end

@implementation PersonViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
    
    [self reshData];
    
    NSLog(@"%@",user_dianpuID);
    NSLog(@"%@",user_Id);
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     self.navigationController.navigationBar.hidden=NO;
}
//-(void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//   
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newNavi];
    [self newView];
    [self reshData];
    
    // Do any additional setup after loading the view.
}
-(void)initData{
    
    
    _personDic = [NSMutableDictionary dictionary];
    [self reshCellContentArray];
    [self newView];
}
-(void)reshCellContentArray{
    _tableContentArray = @[@[@{@"img":@"我_钱包",@"title":@"钱包",@"controller":NSStringFromClass([BalanceViewController class])},
                             @{@"img":@"我_订单",@"title":@"订单",@"controller":@"ReceivingAwardViewController"}],
                           @[@{@"img":@"我_邀请",@"title":@"邀请",@"controller":@"InvitationViewController"}],
                           
                           @[@{@"img":@"我_签到",@"title":@"签到",@"controller":@"noPush_qiandao"},
                             @{@"img":@"我_分享",@"title":@"分享",@"controller":@"noPush_fenxiang"},
                             @{@"img":@"我_帮助",@"title":@"帮助",@"controller":@"helpCenterViewController"}]
                           ];
    
    NSMutableArray * sectionArr = [[NSMutableArray alloc]initWithArray:_tableContentArray];
    NSMutableArray * thirdArr = [[NSMutableArray alloc]initWithArray:sectionArr[2]];
    
    NSString * shangpuqx = [NSString stringWithFormat:@"%@",_personDic[@"shangpuqx"]];
    NSString * hudongqx  = [NSString stringWithFormat:@"%@",_personDic[@"hudongqx"]];
    NSString * shangpinqx = [NSString stringWithFormat:@"%@",_personDic[@"shangpinguanli"]];
    
//    shangpuqx=@"1";
//    shangpinqx=@"1";
//    hudongqx =@"1";
    

    if ([hudongqx isEqualToString:@"1"]) {
        [thirdArr insertObject:@{@"img":@"我_互动",@"title":@"互动",@"controller":NSStringFromClass([ShopDetailViewController class])} atIndex:0];
    }
    if ([shangpinqx isEqualToString:@"1"]) {
        [thirdArr insertObject:@{@"img":@"我_商品",@"title":@"商品",@"controller":@"ShangpinManageViewController"} atIndex:0];
    }
    if ([shangpuqx isEqualToString:@"1"]) {
        [thirdArr insertObject:@{@"img":@"我_商铺",@"title":@"商铺",@"controller":@"ShopManagerViewController"} atIndex:0];
    }

    [sectionArr replaceObjectAtIndex:2 withObject:thirdArr];
    
    _tableContentArray = sectionArr;
}
-(void)newNavi{
    
    self.navigationController.navigationBar.tintColor=naviBarTintColor;
    SuperNavigationView * navi = [[SuperNavigationView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 64)];
    [navi.leftBtn setImage:nil forState:UIControlStateNormal];
    [navi.leftBtn removeFromSuperview];
    [navi.titleView setTitle:@"我" forState:UIControlStateNormal];
    [navi.rightBtn setTitle:@"设置" forState:UIControlStateNormal];
    navi.block=^(NSInteger index){
        if (index == 2) {
            SecurityViewController * set = [SecurityViewController new];
            set.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:set animated:YES];
        }
    };
   
    
    [self.view addSubview:navi];
    navi.backgroundColor=naviBarTintColor;
    _navi = navi;
    
   
    
    
}
-(void)newView{
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-114) style:UITableViewStyleGrouped];
    [self.view addSubview:_mainTableView];
    _mainTableView.tableHeaderView=[self tableHeaderView];
    [_mainTableView registerClass:[PersonTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    _mainTableView.delegate=self;
    _mainTableView.dataSource=self;
    
}
-(void)reshData{

    [Request  getPersonInfoWithDic:@{@"yuangong.id":user_id} success:^(id json) {
        if ([[json valueForKey:@"message"]integerValue]== 2){
            [MBProgressHUD promptWithString:@"参数不能为空"];
        }
        else
        {
            [_personDic removeAllObjects];
            [_personDic addEntriesFromDictionary:(NSDictionary *)json];
            NSString * banben = [NSString stringWithFormat:@"%@",_personDic[@"banben"]];
            set_dianpu_banben(banben);
            
            
            [self reshView];
            
        }
      
        
    } failure:^(NSError *error) {
        
    }];
}
-(void)reshView{
    set_User_Logo([self.personDic valueForKey:@"image"]);
    [self reshCellContentArray];
    
    UIImageView * headerView = [self.mainTableView.tableHeaderView viewWithTag:100];
    
    UILabel * headerLable = [self.mainTableView.tableHeaderView viewWithTag:101];
    
    
    [headerView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.personDic valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"] options:SDWebImageRefreshCached];
    

    
    
    NSString *phoneNum = [BaseCostomer phoneNumberJiamiWithString:[NSString stringWithFormat:@"%@",[self.personDic valueForKey:@"tel"]]];
    
    NSString *zhiwuAndName = [NSString stringWithFormat:@"%@ %@",[self.personDic valueForKey:@"zhiwu"],[self.personDic valueForKey:@"name"]];
    
    NSMutableAttributedString * attriHeaderLable = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@",zhiwuAndName,phoneNum]];
    [attriHeaderLable addAttribute:NSForegroundColorAttributeName value:textBlackColor range:NSMakeRange(0, attriHeaderLable.length)];
    
    
    headerLable.attributedText =attriHeaderLable;
    [headerLable sizeToFit];
    headerLable.centerY=headerView.centerY;

    
    [[NSUserDefaults standardUserDefaults]setValue:[self.personDic valueForKey:@"show"] forKey:@"show"];
    
      [self.mainTableView reloadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -- tableview
-(UIView*)tableHeaderView{
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 100*MCscale)];
    backView.backgroundColor=naviBarTintColor;
    
    
    UIImageView * headImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    [backView addSubview:headImg];
    headImg.centerY=backView.height/2;
    headImg.centerX=backView.width*0.3;
    headImg.tag=100;
    
    
    UILabel * content = [[UILabel alloc]initWithFrame:CGRectZero];
    [backView addSubview:content];
    content.left=headImg.right+20;
    content.centerY=headImg.centerY;
    content.numberOfLines=2;
    content.tag=101;

    
    return backView;
}

#pragma mark -- tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   NSArray * cellArray = _tableContentArray[section];
   return  cellArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _tableContentArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    return 50;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSArray * cellArray = _tableContentArray[indexPath.section];
    NSDictionary * cellDic = cellArray[indexPath.row];
    
    
    cell.leftImg.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[cellDic valueForKey:@"img"]]];
    cell.rightImg.image=[UIImage imageNamed:@"xialas"];
    
    cell.titleLabel.text=[NSString stringWithFormat:@"%@",[cellDic valueForKey:@"title"]];
    
    cell.bottomLine.hidden=YES;
    
    NSString * classString = [NSString stringWithFormat:@"%@",cellDic[@"controller"]];
    if ([classString hasPrefix:@"noPush"] && [classString hasSuffix:@"qiandao"]) {
        cell.contentLabel.text=[self getQianDaoStatus];
        [cell.contentLabel sizeToFit];
        cell.contentLabel.textColor=redTextColor;
    }else{
        cell.contentLabel.text=@"";
    }
    
//    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[cellDic valueForKey:@"img"]]];
//    cell.textLabel.text= [NSString stringWithFormat:@"%@",[cellDic valueForKey:@"title"]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    PersonTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//
    NSArray * cellArray =_tableContentArray[indexPath.section];
    
    NSDictionary * cellDic = cellArray[indexPath.row];
    NSString * classString = [NSString stringWithFormat:@"%@",cellDic[@"controller"]];

    if ([classString hasPrefix:@"noPush"]) {
        if ([classString hasSuffix:@"fenxiang"]) {
            [self shareMessage];
        }
        if ([classString hasSuffix:@"qiandao"]) {
            QianDaoView * qiandao = [QianDaoView new];
            __block QianDaoView * weakQian = qiandao;
            
            qiandao.status=[NSString stringWithFormat:@"%@",self.personDic[@"clockstatus"]];
            [qiandao appear];
            qiandao.block=^(NSInteger index){
                [weakQian disAppear];
                if (index==1) {
                    [self reshData];
                }
            };
            
        }
        
    }else{
        UIViewController * controller = [NSClassFromString(classString) new];
  
        if ([controller isKindOfClass:[ShangpinManageViewController class]]) {
            
            NSDictionary * pram = @{@"dianpuid":user_dianpuID};
            [Request getShenHeStatusWithDic:pram Success:^(id json) {
                NSString * message = [NSString stringWithFormat:@"%@",[json valueForKey:@"messages"]];
                switch ([message integerValue]) {
                    case 0:
                    {
                        [self showShangpinFenLei];
                    }
                        break;
                    case 1:
                    {
                        PHAlertView * alert = [[PHAlertView alloc]initWithTitle:@"" message:@"店铺已经审核，店铺二维码已生成。" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                        [alert show];
                        alert.block=^(NSInteger index){
                            
                            
                            [self showShangpinFenLei];
                            
                        };
                    }
                        break;
                    case 2:
                    {
                        [self showShangpinFenLei];
                    }
                        break;
                    case 3:
                    {
                        PHAlertView * alert = [[PHAlertView alloc]initWithTitle:@"" message:@"店铺信息未完善，状态暂无法审核通过。" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                        [alert show];
                        alert.block=^(NSInteger index){
                            [self showShangpinFenLei];
                        };
                    }
                        break;
                    default:
                        break;
                }
            } failure:^(NSError *error) {
                
            }];
                       return;
        }
        
        
        if ([controller isKindOfClass:[ReceivingAwardViewController class]]) {
            ((ReceivingAwardViewController *)controller).jiadanMoney=@"2";
        }
        if ([controller isKindOfClass:[helpCenterViewController class]]) {
        }
        if ([controller isKindOfClass:[ShopDetailViewController class]]) {
        
        }
        
        controller.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offY = self.mainTableView.contentOffset.y;
 
    if (offY<0) {
        _navi.height=64-offY;
        [self.view bringSubviewToFront:_navi];
    }else{
        [self.view sendSubviewToBack:_navi];
    }
}


-(NSString *)getQianDaoStatus{
    NSString * status=[NSString stringWithFormat:@"%@",[_personDic valueForKey:@"clockstatus"]];
    if ([status integerValue]%2==0) {
        set_IsZaiGang(NO);
    }else{
        set_IsZaiGang(YES);
    }
    NSArray<NSString *> * titleArray = @[@"签到",
                                         @"第一时段 签到",
                                         @"第一时段 离岗",
                                         @"第二时段 签到",
                                         @"第二时段 离岗",
                                         @"第三时段 签到",
                                         @"第三时段 离岗",
                                         @"第四时段 签到",
                                         @"第四时段 离岗"
                                         ];
    NSInteger statusIndex =[status integerValue];
    
    NSString * title;
    if (0<=statusIndex&&statusIndex<9) {
        title =titleArray[[status integerValue]];
//        rightLabel.text=title;
    }else{
         title=@"未知";
        [MBProgressHUD promptWithString:@"签到状态获取失败"];
    }
    
    return title;
}
#pragma mark -- 分享
-(void)shareMessage
{
    NSDictionary *pram = @{@"dianpuid":[NSString stringWithFormat:@"%@",user_dianpuID]};
    [Request getFenXiangContentWithDic:pram success:^(id json) {
        NSDictionary *mesDic = (NSDictionary *)json;
        NSString * message = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
        if ([message isEqualToString:@"0"]) {
            [MBProgressHUD promptWithString:@"暂无分享信息"];
            return ;
        }
        [self share:mesDic];
    } failure:^(NSError *error) {
        
    }];
    
}
-(void)share:(NSDictionary *)shareDic
{
    
    NSString *shareImg = [NSString stringWithFormat:@"%@",[shareDic valueForKey:@"tubiao"]];
    NSLog(@"-- %@",shareImg);
    NSString *shareUrl = [NSString stringWithFormat:@"%@",[shareDic valueForKey:@"url"]];
    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareImg]]];
    NSString *shareCont = [NSString stringWithFormat:@"%@",[shareDic valueForKey:@"wenzi"]];
    //    构造分享内容
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKSetupShareParamsByText:shareCont
                                     images:img
                                        url:[NSURL URLWithString:shareUrl]
                                      title:@"分享标题"
                                       type:SSDKContentTypeAuto];
    [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
                [MBProgressHUD promptWithString:@"分享成功"];
                
                break;
            case SSDKResponseStateFail:
                [MBProgressHUD promptWithString:@"分享失败"];
                
                break;
            case SSDKResponseStateCancel:
                //                [MBProgressHUD promptWithString:@"分享被取消"];
                
                break;
            default:
                break;
        }
    }];
 
}
-(void)showShangpinFenLei{
    
    if ([self.personDic[@"shangpinguanli"] integerValue]== 0) {
        [MBProgressHUD promptWithString:@"未授权"];
    }
    else
    {
        ReviewSelectedView * sele = [ReviewSelectedView new];
        sele.dianpuId=user_dianpuID;
        [sele reloadDataWithViewTag:1];
        [sele appear];
        sele.block=^(id data){
            ShangpinManageViewController *shangpingVC = [[ShangpinManageViewController alloc]init];
            shangpingVC.hidesBottomBarWhenPushed = YES;
            shangpingVC.dianpuID = [NSString stringWithFormat:@"%@",[data valueForKey:@"dianpuid"]];
            shangpingVC.dianpuName = [NSString stringWithFormat:@"%@",[data valueForKey:@"dianpuname"]];
            [self.navigationController pushViewController:shangpingVC animated:YES];
        };
    }

}

@end
