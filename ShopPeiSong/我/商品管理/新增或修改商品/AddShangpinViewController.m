//
//  AddShangpinViewController.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/21.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "AddShangpinViewController.h"
#import "CheckShangpinView.h"
#import "Header.h"
#import "AddShangpingView.h"
#import "AFNetworking.h"
@interface AddShangpinViewController ()<UIGestureRecognizerDelegate,MBProgressHUDDelegate,UITextFieldDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,MBProgressHUDDelegate>
@property(nonatomic,strong)UIButton *leftButton,*saveBtn;
@property(nonatomic,strong)UIImagePickerController *imagePicker;
@property(nonatomic,strong)UIView *bottomView;//添加视图,修改视图
@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong)AddShangpingView *addView;
@property(nonatomic,strong)CheckShangpinView *checkView;
@property(nonatomic,strong)UIImageView *ShangpinImage;
@property(nonatomic,strong)UILabel *ShangpinNamaLabel;
@property(nonatomic,strong)NSString *imageNameStr;
@property(nonatomic,strong)NSDictionary *imageDict;

@end

@implementation AddShangpinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainScrollView];
    [self.view addSubview:self.bottomView];
    if (self.viewTag == 2) {
        [self getShangpinMessagesData];
    }
    [self setNavigationItem];
}
#pragma mark 获得商品数据
-(void)getShangpinMessagesData
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mHud.mode = MBProgressHUDModeIndeterminate;
    mHud.delegate = self;
    mHud.labelText = @"请稍等...";
    [mHud show:YES];
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"shop.id":self.shangpinID}];
    
    [HTTPTool postWithUrl:@"enterShangpin.action" params:pram success:^(id json){
        [mHud hide:YES];
        NSLog(@"商品信息 %@",json);
        if ([[json valueForKey:@"message"] integerValue] == 0) {
            [self promptMessageWithString:@"参数不能为空"];
        }
        else if ([[json valueForKey:@"message"] integerValue] == 1)
        {
            [self promptMessageWithString:@"无此商品信息"];
        }
        else
        {
            NSDictionary *shangpinDict = [json valueForKey:@"shop"];
            
            UITextField *textfield1 = [self.checkView viewWithTag:11000];
            UITextField *textfield2 = [self.checkView  viewWithTag:11001];
            UITextField *textfield3 = [self.checkView  viewWithTag:11002];
            UITextField *textfield4 = [self.checkView  viewWithTag:11003];
            textfield1.text = [NSString stringWithFormat:@"%@",shangpinDict[@"yuanjia"]];
            textfield2.text =  [NSString stringWithFormat:@"%@",shangpinDict[@"xianjia"]];
            textfield3.text =  [NSString stringWithFormat:@"%@",shangpinDict[@"caigoujia"]];
            textfield4.text =  [NSString stringWithFormat:@"%@",shangpinDict[@"dianleipaixu"]];
            
            UIView *backView1 = [self.checkView viewWithTag:21005];
            UILabel *fujiafeiNameLabel = [backView1 viewWithTag:31005];
            UILabel *fujiafeiMoneyLabel = [backView1 viewWithTag:41005];
            fujiafeiNameLabel.text =  [NSString stringWithFormat:@"%@",shangpinDict[@"fujiafeiyong_name"]];;
            fujiafeiMoneyLabel.text =  [NSString stringWithFormat:@"%@",shangpinDict[@"fujiafeiyong_money"]];;
            
            NSArray *biaoqianArray = @[@"推荐",@"新品",@"热销",@"特惠购"];
            UIView *backView2 = [self.checkView viewWithTag:21004];
            UILabel *biaoqianLabel = [backView2 viewWithTag:31004];
            biaoqianLabel.text = biaoqianArray[[shangpinDict[@"biaoqian"] integerValue]-1];
            
            NSArray *stateArray = @[@"下架",@"上架"];
            UIView *backView3 = [self.checkView viewWithTag:21006];
            UILabel *statesLabel = [backView3 viewWithTag:31006];
            statesLabel.text = stateArray[[shangpinDict[@"zhuangtai"] integerValue]];
            NSString *imageUrl = [NSString stringWithFormat:@"%@",shangpinDict[@"canpinpic"]];
            [self.ShangpinImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"] options:SDWebImageRefreshCached];
            self.ShangpinNamaLabel.text = shangpinDict[@"shangpinname"];
        }
    } failure:^(NSError *error) {
        [mHud hide:YES];
        [self promptMessageWithString:@"网络连接错误"];
    }];
}
-(UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [BaseCostomer buttonWithFrame:CGRectMake(0, 0, NVbtnWight, NVbtnWight) backGroundColor:[UIColor clearColor] text:@"" image:@"返回按钮"];
        [_leftButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
#pragma mark 设置 导航栏
-(void)setNavigationItem
{
    [self.navigationItem setTitle:self.dianpuName];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName, nil]];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}
-(NSString *)imageNameStr
{
    if (!_imageNameStr) {
        _imageNameStr = @"";
    }
    return _imageNameStr;
}
-(AddShangpingView *)addView
{
    if (!_addView) {
        _addView = [[AddShangpingView alloc]initWithFrame:CGRectMake(0,120*MCscale, kDeviceWidth, self.mainScrollView.height)];
        _addView.backgroundColor = [UIColor clearColor];
        _addView.dianpuID = self.dianpuID;
    }
    return _addView;
}
-(CheckShangpinView *)checkView
{
    if (!_checkView) {
        _checkView = [[CheckShangpinView alloc]initWithFrame:CGRectMake(0,150*MCscale, kDeviceWidth, self.mainScrollView.height)];
        _checkView.backgroundColor = [UIColor clearColor];
        _checkView.dianpuID = self.dianpuID;
    }
    return _checkView;
}

-(UIImageView *)ShangpinImage
{
    if (!_ShangpinImage) {
        _ShangpinImage = [BaseCostomer imageViewWithFrame:CGRectMake(kDeviceWidth/2.0-50,10*MCscale, 100*MCscale, 100*MCscale) backGroundColor:[UIColor clearColor] cornerRadius:0 userInteractionEnabled:YES image:@"yonghutouxiang"];
        
        UITapGestureRecognizer *shangpinImageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ShangpinImageTapClick)];
        [_ShangpinImage addGestureRecognizer:shangpinImageTap];
    }
    return _ShangpinImage;
}
-(UILabel *)ShangpinNamaLabel
{
    if (!_ShangpinNamaLabel) {
        _ShangpinNamaLabel = [BaseCostomer labelWithFrame:CGRectMake(20*MCscale, self.ShangpinImage.bottom, kDeviceWidth - 40*MCscale, 30*MCscale) font:[UIFont systemFontOfSize:MLwordFont_4] textColor:txtColors(231, 231, 231, 1) backgroundColor:[UIColor clearColor] textAlignment:1 numOfLines:1 text:@"呵呵哈哈哈"];
    }
    return _ShangpinNamaLabel;
}
-(UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight - 64 - 50*MCscale)];
        //滑屏
        _mainScrollView.delegate = self;
        //滑动一页
        _mainScrollView.backgroundColor = [UIColor clearColor];
        _mainScrollView.contentSize = CGSizeMake(kDeviceWidth,kDeviceHeight+100*MCscale);
        //偏移量
        _mainScrollView.contentOffset = CGPointMake(0, 0);
        //竖直方向不能滑动
        _mainScrollView.alwaysBounceVertical = YES;
        //水平方向滑动
        _mainScrollView.alwaysBounceHorizontal = NO;
        //滑动指示器
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        //无法超过边界
        _mainScrollView.bounces = NO;
        //设置滑动时减速到0所用的时间
        _mainScrollView.decelerationRate  = 1;
        [_mainScrollView addSubview:self.ShangpinImage];
        if (self.viewTag == 1) {
            [_mainScrollView addSubview:self.addView];
        }
        else {
            [_mainScrollView addSubview:self.ShangpinNamaLabel];
            [_mainScrollView addSubview:self.checkView];
            //            [self.checkView getShangpinMessagesDataWithshangpinId:self.shangpinID];
        }
    }
    return _mainScrollView;
}
-(UIButton *)saveBtn
{
    if (!_saveBtn) {
        _saveBtn = [BaseCostomer buttonWithFrame:CGRectMake(kDeviceWidth/2.0-50*MCscale, 10*MCscale, 100*MCscale, 30*MCscale) font:[UIFont boldSystemFontOfSize:MLwordFont_2] textColor:[UIColor whiteColor] backGroundColor:redTextColor cornerRadius:5.0 text:@"保存" image:@""];
        [_saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}
-(UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [BaseCostomer viewWithFrame:CGRectMake(0, kDeviceHeight-50*MCscale, kDeviceWidth, 50*MCscale) backgroundColor:txtColors(48, 195, 155, 1)];
        [_bottomView addSubview:self.saveBtn];
    }
    return _bottomView;
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
#pragma mark 上传商品照片
-(void)ShangpinImageTapClick
{
    if (self.viewTag == 1) {
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
}

#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        self.ShangpinImage.image = image;
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyyMMddhhmmss"];
        NSString *dateTime = [formatter stringFromDate:date];
        self.imageNameStr = [NSString stringWithFormat:@"SHOP%@.png",dateTime];
        self.imageDict = @{@"image":image};
        
    }];
}

-(void)saveBtnClick
{
    if (self.viewTag == 1) {
        NSString *biaoqianStr,*kucunshuStr,*yuanjiaStr,*fujiafeiName,*fujiafeiMoney;
        UITextField *textfield1 = [self.addView viewWithTag:10000];//商品名
        UITextField *textfield2 = [self.addView  viewWithTag:10002];//库存量
        UITextField *textfield3 = [self.addView  viewWithTag:10003];//原价
        UITextField *textfield4 = [self.addView  viewWithTag:10004];//现价
        UITextField *textfield5 = [self.addView  viewWithTag:10005];//采购价
        UITextField *textfield6 = [self.addView  viewWithTag:10008];//排序
        
        UIView *backView3 = [self.addView viewWithTag:20001];//类别
        UILabel *leibieLabel = [backView3 viewWithTag:30001];
        
        UIView *backView1 = [self.addView viewWithTag:20006];//附加费
        UILabel *fujiafeiNameLabel = [backView1 viewWithTag:30006];
        UILabel *fujiafeiMoneyLabel = [backView1 viewWithTag:40006];
        
        UIView *backView2 = [self.addView viewWithTag:20007];//标签
        UILabel *biaoqianLabel = [backView2 viewWithTag:30007];
        
        if ([self.imageNameStr isEqualToString:@""]) {
            [self promptMessageWithString:@"请上传图片"];
        }
        else if ([textfield1.text isEqualToString:@""]||[textfield4.text isEqualToString:@""]||[textfield5.text isEqualToString:@""]||[textfield6.text isEqualToString:@""]||[leibieLabel.text isEqualToString:@""])
        {
            [self promptMessageWithString:@"请完善商品信息"];
        }
        else
        {
            if ([textfield2.text isEqualToString:@""])  kucunshuStr = @"0";
            else kucunshuStr = textfield2.text;
            
            if ([textfield3.text isEqualToString:@""])  yuanjiaStr = @"0";
            else yuanjiaStr = textfield3.text;
            
            if ([fujiafeiNameLabel.text isEqualToString:@""])  fujiafeiName = @"0";
            else fujiafeiName = fujiafeiNameLabel.text;
            
            if ([fujiafeiMoneyLabel.text isEqualToString:@""])  fujiafeiMoney = @"0";
            else fujiafeiMoney = textfield2.text;
            
            if ([biaoqianLabel.text isEqualToString:@"推荐"]||[biaoqianLabel.text isEqualToString:@""]) biaoqianStr = @"1";
            else if ([biaoqianLabel.text isEqualToString:@"新品"]) biaoqianStr = @"2";
            else if ([biaoqianLabel.text isEqualToString:@"热销"]) biaoqianStr = @"3";
            else if ([biaoqianLabel.text isEqualToString:@"特惠购"]) biaoqianStr = @"4";
            
            NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"shop.dianpuid":self.dianpuID,@"shop.canpinpic":self.imageNameStr,@"shop.shangpinname":textfield1.text,@"shop.leibie":leibieLabel.text,@"shop.kucunshu":kucunshuStr,@"shop.yuanjia":yuanjiaStr,@"shop.xianjia":textfield4.text,@"shop.caigoujia":textfield5.text,@"shop.fujiafeiyong_money":fujiafeiMoney,@"shop.fujiafeiyong_name":fujiafeiName,@"shop.dianleipaixu":textfield6.text,@"biaoqian":biaoqianStr}];
            
            [self saveMessagesForShangpinWithUrl:@"addShangpin.action" AndPram:pram];
        }
    }
    else
    {
        UITextField *textfield1 = [self.checkView viewWithTag:11000];
        UITextField *textfield2 = [self.checkView  viewWithTag:11001];
        UITextField *textfield3 = [self.checkView  viewWithTag:11002];
        UITextField *textfield4 = [self.checkView  viewWithTag:11003];
        
        UIView *backView1 = [self.checkView viewWithTag:21005];
        UILabel *fujiafeiNameLabel = [backView1 viewWithTag:31005];
        UILabel *fujiafeiMoneyLabel = [backView1 viewWithTag:41005];
        
        UIView *backView2 = [self.checkView viewWithTag:21004];
        UILabel *biaoqianLabel = [backView2 viewWithTag:31004];
        
        UIView *backView3 = [self.checkView viewWithTag:21006];
        UILabel *statesLabel = [backView3 viewWithTag:31006];
        
        NSString *statesStr,*biaoqianStr;
        
        if ([statesLabel.text isEqualToString:@"上架"]) statesStr = @"1";
        else statesStr = @"0";
        
        if ([biaoqianLabel.text isEqualToString:@"推荐"]) biaoqianStr = @"1";
        else if ([biaoqianLabel.text isEqualToString:@"新品"]) biaoqianStr = @"2";
        else if ([biaoqianLabel.text isEqualToString:@"热销"]) biaoqianStr = @"3";
        else if ([biaoqianLabel.text isEqualToString:@"特惠购"]) biaoqianStr = @"4";
        
        NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"shop.id":self.shangpinID,@"shop.yuanjia":textfield1.text,@"shop.xianjia":textfield2.text,@"shop.caigoujia":textfield3.text,@"shop.fujiafeiyong_money":fujiafeiMoneyLabel.text,@"shop.fujiafeiyong_name":fujiafeiNameLabel.text,@"shop.zhuangtai":statesStr,@"shop.dianleipaixu":textfield4.text,@"biaoqian":biaoqianStr}];
        [self saveMessagesForShangpinWithUrl:@"updateShangpin.action" AndPram:pram];
    }
}

#pragma mark 保存信息
-(void)saveMessagesForShangpinWithUrl:(NSString *)url AndPram:(NSMutableDictionary *)pram
{
    MBProgressHUD *mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mHud.mode = MBProgressHUDModeIndeterminate;
    mHud.delegate = self;
    mHud.labelText = @"请稍等...";
    [mHud show:YES];
    
    [HTTPTool postWithUrl:url params:pram success:^(id json){
        [mHud hide:YES];
        NSLog(@"保存信息 %@",json);
        if ([[json valueForKey:@"message"] integerValue] == 3) [self promptMessageWithString:@"参数不能为空"];
        else if ([[json valueForKey:@"message"] integerValue] == 2) [self promptMessageWithString:@"保存信息失败,请稍后重试!"];
        else
        {
            if (self.viewTag == 1) {
                [self uploadImage];
            }
            else
            {
                MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                mbHud.mode = MBProgressHUDModeCustomView;
                mbHud.labelText = @"保存信息成功";
                mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
                [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
    } failure:^(NSError *error) {
        [mHud hide:YES];
        [self promptMessageWithString:@"网络连接错误"];
    }];
}

#pragma mark 上传图片接口
-(void)uploadImage
{
    // 1.获取AFN的请求管理者
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    //网络延时设置15秒
    manger.requestSerializer.timeoutInterval = 15;
    NSString * urlPath = [NSString stringWithFormat:@"%@fileuploadgj.action",HTTPImage];
    
    [manger POST:urlPath parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        NSData *imageData = UIImageJPEGRepresentation([((UIImage *)(self.imageDict[@"image"])) imageByScalingToSize:CGSizeMake(360, 360)], 0.9);
        NSString *fileName = [NSString stringWithFormat:@"%@",self.imageNameStr];
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
    }
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             mbHud.mode = MBProgressHUDModeCustomView;
             mbHud.labelText = @"保存信息成功";
             mbHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
             [mbHud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
             [self.navigationController popViewControllerAnimated:YES];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [self promptMessageWithString:@"网络连接错误"];
         }];
}
-(void)buttonAction:(UIButton *)button
{
    if (button == self.leftButton) {
        [self.navigationController popViewControllerAnimated:YES];
    }
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

