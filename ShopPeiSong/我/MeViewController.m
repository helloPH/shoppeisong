//
//  MeViewController.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/6.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "MeViewController.h"
#import "PersonalCell.h"
#import "SecurityViewController.h"
#import "ReviewSelectedView.h"
#import "ReceivingAwardViewController.h"
#import "InvitationViewController.h"
#import "helpCenterViewController.h"
#import "ShangpinManageViewController.h"
#import "BalanceViewController.h"
#import "Header.h"
#import "QianDaoView.h"
#import "OpenAccountViewController.h"
#import "ShengJiViewController.h"
#import "TopUpView.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <sharesdkui/SSUIShareActionSheetStyle.h>

#import "XuFeiViewController.h"
#import "getBalanceViewController.h"
#import "NumberPassWordView.h"


@interface MeViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,ReviewSelectedViewDelegate,MBProgressHUDDelegate>
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)UIView *headView,*lineView,*yueView,*jiangliView,*lineViewV;
@property(nonatomic,strong)UIImageView *headImageView,*iconImageView;
@property(nonatomic,strong)UILabel *nameLabel,*telLabel,*banbenLabel,*yueLabel,*yueStrLabel,*jiangliLabel,*jiangliStrLabel;
@property(nonatomic,strong)UIImagePickerController *imagePicker;
@property(nonatomic,strong)ReviewSelectedView *selectedView;
@property(nonatomic,strong)QianDaoView        *qianDanView;

@property(nonatomic,strong)UIView *maskView;
@property(nonatomic,strong)NSDictionary *personDic;

@end
@implementation MeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self getPersonalData];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.banbenLabel];
    [self.navigationItem setTitle:@"个人中心"];
    if (!banben_IsAfter) {
        [Request getAppStatusSuccess:^(id json) {/// 该方法 主要是来获取 版本是否上线
           NSString * status = [NSString stringWithFormat:@"%@",json];
            if ([status isEqualToString:@"1"]) {// 1 为上线
                set_Banben_IsAfter(YES);
                [self getPersonalData];
            }
        } failure:^(NSError *error) {
        }];
    }
}

#pragma mark 获取个人中心信息
-(void)getPersonalData
{
    [Request  getPersonInfoWithDic:@{@"yuangong.id":user_id} success:^(id json) {
        
        
        
        self.personDic = (NSDictionary *)json;
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:self.personDic];
//        [mdic setValue:@"1" forKey:@"dodo"];
//        [mdic setValue:@"1" forKey:@"banben"];
        self.personDic=mdic;
        
        
        if ([[json valueForKey:@"message"]integerValue]== 2){
            [self promptMessageWithString:@"参数不能为空"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setValue:[self.personDic valueForKey:@"image"] forKey:@"touxiangImage"];
            [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.personDic valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"] options:SDWebImageRefreshCached];
            NSString *phoneNum = [BaseCostomer phoneNumberJiamiWithString:[NSString stringWithFormat:@"%@",[self.personDic valueForKey:@"tel"]]];
            self.telLabel.text = phoneNum;
            self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",[self.personDic valueForKey:@"zhiwu"],[self.personDic valueForKey:@"name"]];
            self.yueLabel.text = [NSString stringWithFormat:@"%@",[self.personDic valueForKey:@"beiyongjin"]];
            self.jiangliLabel.text = [NSString stringWithFormat:@"%@",[self.personDic valueForKey:@"jiedan"]];
            [[NSUserDefaults standardUserDefaults]setValue:[self.personDic valueForKey:@"show"] forKey:@"show"];
            
        }
        [self.mainTableView reloadData];

    } failure:^(NSError *error) {
        
    }];
    
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
-(ReviewSelectedView *)selectedView
{
    if (!_selectedView) {
        _selectedView = [[ReviewSelectedView  alloc]initWithFrame:CGRectMake(30*MCscale,230*MCscale, kDeviceWidth - 60*MCscale, 240*MCscale)];
        _selectedView.selectedDelegate = self;
    }
    return _selectedView;
}
-(QianDaoView *)qianDanView{
    if (!_qianDanView) {
       _qianDanView = [[QianDaoView  alloc]initWithFrame:CGRectMake(30*MCscale,230*MCscale, kDeviceWidth - 60*MCscale, 110*MCscale)];
    }
    return _qianDanView;
}
-(UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [BaseCostomer imageViewWithFrame:CGRectMake(0, 0, kDeviceWidth, 140*MCscale) backGroundColor:[UIColor clearColor] image:@"geren_beijing_icon"];
    }
    return _headImageView;
}

-(UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [BaseCostomer imageViewWithFrame:CGRectMake(0, 0,80*MCscale,80*MCscale) backGroundColor:[UIColor clearColor] cornerRadius:40*MCscale userInteractionEnabled:YES image:@"yonghutouxiang"];
        _iconImageView.center = CGPointMake(kDeviceWidth/2.0,47*MCscale);
        
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapClick:)];
        [_iconImageView addGestureRecognizer:imageTap];
    }
    return _iconImageView;
}

-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [BaseCostomer labelWithFrame:CGRectMake(self.iconImageView.left, self.iconImageView.bottom +5*MCscale,self.iconImageView.width, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@""];
    }
    return _nameLabel;
}

-(UILabel *)telLabel
{
    if (!_telLabel) {
        _telLabel = [BaseCostomer labelWithFrame:CGRectMake(self.nameLabel.left,self.nameLabel.bottom +5*MCscale,self.nameLabel.width, 15*MCscale) font:[UIFont systemFontOfSize:MLwordFont_7] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@""];
    }
    return _telLabel;
}

-(UILabel *)yueLabel
{
    if (!_yueLabel) {
        _yueLabel = [BaseCostomer labelWithFrame:CGRectMake(0,5*MCscale, self.yueView.width, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_2] textColor:redTextColor backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@""];
    }
    return _yueLabel;
}

-(UILabel *)yueStrLabel
{
    if (!_yueStrLabel) {
        _yueStrLabel = [BaseCostomer labelWithFrame:CGRectMake(0, self.yueLabel.bottom+2*MCscale, self.yueView.width,20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_3] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter numOfLines:1 text:@"备用金"];
    }
    return  _yueStrLabel;
}

-(UIView *)yueView
{
    if (!_yueView) {
        _yueView = [BaseCostomer viewWithFrame:CGRectMake(0, self.headImageView.bottom, kDeviceWidth/2.0,55*MCscale) backgroundColor:[UIColor clearColor]];
        [_yueView addSubview:self.yueLabel];
        [_yueView addSubview:self.yueStrLabel];
        
        UITapGestureRecognizer *yueViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapClick:)];
        [_yueView addGestureRecognizer:yueViewTap];
    }
    return _yueView;
}

-(UIView *)lineViewV
{
    if (!_lineViewV) {
        _lineViewV = [BaseCostomer viewWithFrame:CGRectMake(self.yueView.right,self.headImageView.bottom, 1,55*MCscale) backgroundColor:lineColor];
    }
    return _lineViewV;
}

-(UILabel *)jiangliLabel
{
    if (!_jiangliLabel) {
        _jiangliLabel = [BaseCostomer labelWithFrame:CGRectMake(0, 5*MCscale, self.jiangliView.width, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_2] textColor:txtColors(237, 189, 108, 1) backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter numOfLines:1 text:@"0"];
    }
    return _jiangliLabel;
}
-(UILabel *)jiangliStrLabel
{
    if (!_jiangliStrLabel) {
        _jiangliStrLabel = [BaseCostomer labelWithFrame:CGRectMake(0, self.jiangliLabel.bottom+2*MCscale, self.jiangliView.width, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_3] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter numOfLines:1 text:@"接单奖"];
    }
    return _jiangliStrLabel;
}
-(UIView *)jiangliView
{
    if (!_jiangliView) {
        _jiangliView = [BaseCostomer viewWithFrame:CGRectMake(self.lineViewV.right, self.headImageView.bottom,kDeviceWidth/2.0-1, 55*MCscale) backgroundColor:[UIColor clearColor]];
        [_jiangliView addSubview:self.jiangliLabel];
        [_jiangliView addSubview:self.jiangliStrLabel];
        
        UITapGestureRecognizer *jiangliTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapClick:)];
        [_jiangliView addGestureRecognizer:jiangliTap];
    }
    return _jiangliView;
}

-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [BaseCostomer viewWithFrame:CGRectMake(0,self.headView.height-10*MCscale, kDeviceWidth, 10*MCscale) backgroundColor:lineColor];
    }
    return _lineView;
}
-(UIView *)headView
{
    if (!_headView) {
        _headView = [BaseCostomer viewWithFrame:CGRectMake(0, 0, kDeviceWidth,205*MCscale) backgroundColor:[UIColor clearColor]];
        [_headView addSubview:self.headImageView];
        [_headView addSubview:self.iconImageView];
        [_headView addSubview:self.nameLabel];
        [_headView addSubview:self.telLabel];
        [_headView addSubview:self.lineView];
        [_headView addSubview:self.yueView];
        [_headView addSubview:self.lineViewV];
        [_headView addSubview:self.jiangliView];
    }
    return _headView;
}
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64,kDeviceWidth, kDeviceHeight - 64 - 49) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _mainTableView.tableHeaderView = self.headView;
        _mainTableView.scrollEnabled = NO;
    }
    return _mainTableView;
}

-(UILabel *)banbenLabel
{
    if (!_banbenLabel) {
        NSString *versionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *banbenStr = [NSString stringWithFormat:@"版本号:%@",versionStr];
        _banbenLabel = [BaseCostomer labelWithFrame:CGRectMake(0, kDeviceHeight - 49-40*MCscale, kDeviceWidth, 20*MCscale) font:[UIFont systemFontOfSize:MLwordFont_5] textColor:txtColors(236, 236, 236, 1) backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter numOfLines:1 text:banbenStr];
    }
    return _banbenLabel;
}

#pragma mark 账户余额及近期订单
-(void)viewTapClick:(UITapGestureRecognizer *)tap
{
    if (tap.view == self.yueView) {
//        if ([[self.personDic valueForKey:@"beiyongjin"]floatValue] == 0) {
//          
//            TopUpView * topup = [TopUpView new];
//            __block TopUpView * weakTopup =topup;
//            [topup setMoney:50 limitMoney:50 title:[NSString stringWithFormat:@"妙店佳商铺端+%@备用金充值",user_tel] body:user_Id canChange:YES];
//            topup.payBlock=^(BOOL isSuccess){
//                [weakTopup disAppear];
//                if (isSuccess) {// 成功
//                    [self getPersonalData];
//                    [MBProgressHUD promptWithString:@"充值成功"];
//                }else{
//                    [MBProgressHUD promptWithString:@"充值失败"];
//                }
//                
//            };
//            [topup appear];
//            
//          [MBProgressHUD promptWithString:@"余额为零,请充值!"];
//        }
//        else
//        {
            //进入余额
            BalanceViewController *BalanceVC = [[BalanceViewController alloc]init];
            BalanceVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:BalanceVC animated:YES];
//        }
    }
    else
    {
        if ([[self.personDic valueForKey:@"flag"]integerValue] == 0) {
            [self promptMessageWithString:@"暂无可显示记录"];
        }
        else
        {
            ReceivingAwardViewController *ReceivingAwardVC = [[ReceivingAwardViewController alloc]init];
            ReceivingAwardVC.hidesBottomBarWhenPushed = YES;
            ReceivingAwardVC.jiadanMoney = self.jiangliLabel.text;
            [self.navigationController pushViewController:ReceivingAwardVC animated:YES];
        }
    }
}

-(UIImagePickerController *)imagePicker
{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
        _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    }
    return _imagePicker;
}
#pragma mark 上传图像
-(void)imageTapClick:(UITapGestureRecognizer *)tap
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"选择图片路径" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancalAction = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *cleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancalAction];
    [alert addAction:otherAction];
    [alert addAction:cleAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        self.iconImageView.image = image;
        [HTTPTool postWithUrl:@"fileuploadyg.action" params:nil image:image success:^(id json) {
            if ([[json valueForKey:@"message"]integerValue] == 0) {
                MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                mHud.labelText = @"头像更改成功";
                mHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
                mHud.mode = MBProgressHUDModeCustomView;
                [mHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
            }
        } failure:^(NSError *error) {
        }];
    }];
}

#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    PersonalCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PersonalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
      
        
    }
    cell.dic=self.personDic;
    [cell reloadDataWithIndexpath:indexPath];
    
    NSString * banben = [NSString stringWithFormat:@"%@",_personDic[@"banben"]];
    if (indexPath.row==0) {
        NSString * firstTitle;
        
        
        NSString * dodo = [NSString stringWithFormat:@"%@",_personDic[@"dodo"]];
        if ([banben isEqualToString:@"2"]) {
            firstTitle = @"邀请领现金";
        }else{
            firstTitle = @"进入升级版";
        }
        
//        NSStringFromClass([self class]);
        
        [cell setValue:firstTitle forKeyPath:@"nameLabel.text"];
        
        if (!banben_IsAfter) {
            [cell setValue:@"邀请领现金" forKeyPath:@"nameLabel.text"];
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger index = indexPath.row;
    switch (index) {
        case 0://邀请赚现金
        {
            NSString * banben = [NSString stringWithFormat:@"%@",_personDic[@"banben"]];
            if (!banben_IsAfter) {
                InvitationViewController *invitationVC = [[InvitationViewController alloc]init];
                invitationVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:invitationVC animated:YES];
                return;
            }
            
            if ([banben isEqualToString:@"2"]) {//邀请领现金
                InvitationViewController *invitationVC = [[InvitationViewController alloc]init];
                invitationVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:invitationVC animated:YES];
            }else{// 升级完整版
                NSString * dodo = [NSString stringWithFormat:@"%@",_personDic[@"dodo"]];
                if ([dodo isEqualToString:@"1"]) {// 进入升级版
                    ShengJiViewController * shengji = [ShengJiViewController new];
                    shengji.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:shengji animated:YES];
                }else{// 进入续费
                    XuFeiViewController * xufei = [XuFeiViewController new];
                    xufei.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:xufei animated:YES];
                    
                };
   
            }
            
        }
            break;
        case 1://安全设置
        {
            SecurityViewController *securityVC = [[SecurityViewController alloc]init];
            securityVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:securityVC animated:YES];
        }
            break;
        case 2: //商品管理
        {
            
            NSString * banben = [NSString stringWithFormat:@"%@",_personDic[@"banben"]];
            
            if (banben_IsAfter) {//  是否上线
                if ([banben isEqualToString:@"2"]) {//邀请领现金
                }else{// 升级完整版
                    [self promptMessageWithString:@"请升级后使用"];
                    return;
                }
            }
            
            if ([self.personDic[@"shangpinguanli"] integerValue]== 0) {
                [self promptMessageWithString:@"未授权"];
            }
            else
            {
                [UIView animateWithDuration:0.3 animations:^{
                    self.maskView.alpha = 1;
                    [self.view addSubview:self.maskView];
                    self.selectedView.alpha = 0.95;
                    [self.selectedView reloadDataWithViewTag:1];
                    [self.view addSubview:self.selectedView];
                }];
            }
        }
            break;
        case 3://签到
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.maskView.alpha = 1;
                [self.view addSubview:self.maskView];
                self.qianDanView.alpha = 0.95;
                [self.view addSubview:self.qianDanView];
                self.qianDanView.status=[NSString stringWithFormat:@"%@",self.personDic[@"clockstatus"]];
                
            }completion:^(BOOL finished) {
                
                __block MeViewController * weakSelf=self;
                
                self.qianDanView.block=^(NSInteger index){
                    [weakSelf maskViewDisMiss];
                    if (index==1) {
                        [weakSelf getPersonalData];
                    }
                };
            }];
        }
            break;
        case 4:  //我的客服
        {
            helpCenterViewController *helpVC = [[helpCenterViewController alloc]init];
            helpVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:helpVC animated:YES];
        }
            break;
        case 5://分享朋友
            [self shareMessage];
            break;
        default:
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50*MCscale;
}
#pragma mark ReviewSelectedViewDelegate(选择行业)
-(void)selectedIndustryWithString:(NSString *)string AndId:(NSString *)ID
{
    [self maskViewDisMiss];
    ShangpinManageViewController *shangpingVC = [[ShangpinManageViewController alloc]init];
    shangpingVC.hidesBottomBarWhenPushed = YES;
    shangpingVC.dianpuID = ID;
    shangpingVC.dianpuName = string;
    [self.navigationController pushViewController:shangpingVC animated:YES];
}
-(void)maskViewDisMiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        [self.maskView removeFromSuperview];
        [self.view endEditing:YES];
        self.selectedView.alpha = 0;
        [self.selectedView removeFromSuperview];
        
        self.qianDanView.alpha=0;
        [self.qianDanView removeFromSuperview];
    }];
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
//
//    
//    //有的平台要客户端分享需要加此方法，例如微博
//    [shareParams SSDKEnableUseClientShare];
//    //2、分享（可以弹出我们的分享菜单和编辑界面）
////    [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
////        
////    }];
////    
////    [ShareSDK showShareEditor:nil otherPlatformTypes:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
////        
////    }];
//    
//    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
//    
//    [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                             items:nil
//                       shareParams:shareParams
//               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                   switch (state) {
//                       case SSDKResponseStateSuccess:
//                       {
//                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                               message:nil
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"确定"
//                                                                     otherButtonTitles:nil];
//                           [alertView show];
//                           break;
//                       }
//                       case SSDKResponseStateFail:
//                       {
//                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                           message:[NSString stringWithFormat:@"%@",error]
//                                                                          delegate:nil
//                                                                 cancelButtonTitle:@"OK"
//                                                                 otherButtonTitles:nil, nil];
//                           [alert show];
//                           break;
//                       }
//                       default:
//                           break;
//                   }
//               }
//     ];
    
}

@end

