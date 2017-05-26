
#import "ZengQiangOpenView.h"
#import "Header.h"
#import "AutographView.h"
#import "ReviewSelectedView.h"
#import "GetLocationView.h"

#import "PHMap.h"
#import "AFHTTPRequestOperationManager.h"
#import "UseDirectionViewController.h"

#import "OnLinePayView.h"
#import "GestureViewController.h"
#import "SelectFuWuFeiBanBen.h"
#import "TopUpView.h"


@interface ZengQiangOpenView()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (nonatomic,strong)UIScrollView * mainScrollView;
@property (nonatomic,strong) PHMapHelper * mapHelper;

@property (nonatomic,strong)UIView * imgBackView;
@property (nonatomic,assign)NSInteger imageViewTag;
@property (nonatomic,strong)UIImagePickerController * imagePicker;


// 选择的行业  存储的值
@property (nonatomic,strong)NSDictionary * hangYeDic;
@property (nonatomic,strong)UIView *maskView;


@property (nonatomic,strong)UIView * feiYongView;
@property (nonatomic,strong)UIView * banView;
@property (nonatomic,strong)UIView * signView;
@property (nonatomic,strong)UILabel * signLabel;
@property (nonatomic,strong)UIImageView * signImageView;


@property (nonatomic,strong)UILabel * feiLable;
@property (nonatomic,strong)UIButton * submitBtn;

@property (nonatomic,strong)UIView * faPiaoView;
@property (nonatomic,assign)NSInteger  faPiaoIndex;


@property (nonatomic,strong)UIView * protocolView;
@property (nonatomic,assign)BOOL isAgree;

@property (nonatomic,assign)NSInteger month;

@property (nonatomic,assign)double latitude;
@property (nonatomic,assign)double longitude;
@property (nonatomic,strong)NSString * city;


@property (nonatomic,assign)BOOL isDing,isSign,img1,img2,img3,isShangChengBan,isFaPiao,isShouJu,isYouJi,isNoSelecedShouJu,isNoSelecedYouJi;
@property (nonatomic,strong)NSString * money;


//开户后返回的数据
@property (nonatomic,strong)NSString * dianpuid;

//注册之后返回的信息
@property (nonatomic,strong)NSDictionary * dataDic;
@end
@implementation ZengQiangOpenView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
    
        [self initData];
        [self newView];
        [self reshData];
        
        
    }
    return self;
}
-(void)initData{
    _dataDic = [NSDictionary dictionary];
    _isNoSelecedShouJu=YES;
    _isNoSelecedYouJi=YES;
    _isAgree =YES;
    _faPiaoIndex =100;
    _isSign=NO;
    _img1=NO;
    _img2=NO;
    _img3=NO;
    _isShangChengBan=YES;
    _isFaPiao=NO;
    _isShouJu=NO;
    _isYouJi=NO;
    _isDing= YES;
    _month=12;
}
-(void)reshData{
    [self reshView];
}
-(void)reshView{
    [self reshBan];
    [self reshFaPiao];
    [self reshDing];
}
-(void)newView{
    self.backgroundColor=[UIColor whiteColor];
    _mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, self.height)];
    [self addSubview:_mainScrollView];
    
    NSArray *titleArray = @[@"店铺名",@"行业",@"法人/联系人",@"联系/注册手机号",@"服务电话",@"定位签到点",@"店铺地址"];
    NSArray *placeHoldArray = @[@"请输入店铺名",@"请选择行业",@"请输入法人/联系人",@"请输入联系/注册手机号",@"请输入服务电话",@"",@"请输入店铺地址"];
    CGFloat temY = 0;
    for (int i = 0; i<titleArray.count; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20*MCscale,40*MCscale*i+0, 140*MCscale, 30*MCscale)];
        label.text=titleArray[i];
        label.tag = 10000+i;
        label.userInteractionEnabled = YES;
        [_mainScrollView addSubview:label];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10*MCscale, label.bottom +5*MCscale, kDeviceWidth - 20*MCscale, 1)];
        lineView.backgroundColor = lineColor;
        [_mainScrollView addSubview:lineView];
        
        if (i == 0  || i==1 ||i == 2 ||i == 3 ||i == 4||i == 6) {
            UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(label.right,label.top, kDeviceWidth - 40*MCscale - 140*MCscale, 30*MCscale)];
            textField.placeholder=placeHoldArray[i];
            [_mainScrollView addSubview:textField];
        
            if (i == 1)
            {
                textField.text=placeHoldArray[i];
                textField.textAlignment=NSTextAlignmentRight;
                textField.rightView= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_jian_icon"]];
                textField.rightViewMode=UITextFieldViewModeAlways;
                
                textField.rightView.size=CGSizeMake(30, 30);
                textField.userInteractionEnabled=YES;
                
                UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, textField.width, textField.height)];
                [textField addSubview:btn];
                [btn addTarget:self action:@selector(selectHangYeClick:) forControlEvents:UIControlEventTouchUpInside];
                
                
            }
            if (i == 3 || i== 4) {
                if (i == 3) {
//                    [textField setValue:@11 forKey:@"limit"];
                }
                
                textField.keyboardType = UIKeyboardTypePhonePad;
            }
       
            
            textField.tag = 11000+i;
        }
        else
        {
            for (int j =0  ; j < 2; j ++) {
                UIButton * locBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, label.top, 100, 20)];
                [locBtn setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
                [locBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
                locBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
                [locBtn setTitle:j==0?@"定位":@"地图选点" forState:UIControlStateNormal];
                [locBtn setTitleColor:textColors forState:UIControlStateNormal];
                [_mainScrollView addSubview:locBtn];
                [locBtn addTarget:self action:@selector(locationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                locBtn.centerY=label.centerY;
                locBtn.tag=320+j;
//                [locBtn sizeToFit];
                
                if (j==0) {
                    locBtn.width=80;
                    locBtn.left=label.right;
                }else{
                    locBtn.width=120;
                    locBtn.right=_mainScrollView.width-20*MCscale;
                }
            }
            
            
//            [self getLocationData];
        }
        temY=lineView.bottom;
    }

    
    
    _imgBackView=[self newImgBackViewWithSetY:temY];
    [_mainScrollView addSubview:_imgBackView];
    temY=_imgBackView.bottom;

    _feiYongView = [self newFeiYongViewWithSetY:temY+10*MCscale];//费用界面
    [_mainScrollView addSubview:_feiYongView];
    temY=_feiYongView.bottom;
    
    
    _faPiaoView = [self newFaVWithSetY:temY+10*MCscale];// 发票界面
    [_mainScrollView addSubview:_faPiaoView];
    temY = _faPiaoView.bottom;
    
    
    
    _protocolView = [self setProtocolDataWithSetY:temY+10*MCscale];// 协议界面
    [_mainScrollView addSubview:_protocolView];
    temY = _protocolView.bottom;
    
    
    _mainScrollView.contentSize=CGSizeMake(kDeviceWidth, temY+20*MCscale);
    
}

#pragma mark 选择照片
-(UIView *)newImgBackViewWithSetY:(CGFloat)setY
{
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, setY, kDeviceWidth, 100)];
    [_mainScrollView addSubview:backView];
    
    
    
   
    CGFloat imageWidth = (kDeviceWidth - 60*MCscale)/3;
    NSArray *imageArray = @[@"yingyezhizhao",@"shenfenzheng",@"yinghangka"];
    for (int i = 0; i<3; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((imageWidth +10*MCscale)*i+20*MCscale , 20*MCscale, imageWidth, imageWidth)];
        imageView .backgroundColor = [UIColor clearColor];
        imageView.image = [UIImage imageNamed:imageArray[i]];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 1000+i;
        [backView addSubview:imageView];
        
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapClick:)];
        [imageView addGestureRecognizer:imageTap];
        backView.height=imageView.bottom;
    }
    
    
    return backView;
}
#pragma mark 上传照片
-(void)imageTapClick:(UITapGestureRecognizer *)tap
{
    
    _imageViewTag = tap.view.tag;
    _imagePicker =[[UIImagePickerController alloc]init];
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
    _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    UIAlertController  *alert = [UIAlertController alertControllerWithTitle:nil message:@"选择图片路径" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancalAction = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self.controller presentViewController:_imagePicker animated:YES completion:nil];
//        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.controller presentViewController:_imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *cleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancalAction];
    [alert addAction:otherAction];
    [alert addAction:cleAction];
    [self.controller presentViewController:alert animated:YES completion:nil];
}
#pragma mark -- uiimagePicker delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    UIImageView * imgView;
    switch (_imageViewTag) {
        case 1000:
        {
            _img1=YES;
            imgView = [_mainScrollView viewWithTag:1000];
        }
            break;
        case 1001:
        {
            _img2=YES;
            imgView = [_mainScrollView viewWithTag:1001];
        }
            break;
        case 1002:
        {
            _img3=YES;
            imgView = [_mainScrollView viewWithTag:1002];
        }
            break;
        default:
            break;
    }
    imgView.image=image;
    
}

-(UIView *)newFeiYongViewWithSetY:(CGFloat)setY{
    UIView * feiYongV = [[UIView alloc]initWithFrame:CGRectMake(0, setY+20*MCscale, kDeviceWidth, 100)];
    
    _banView = [[UIView alloc]initWithFrame:CGRectMake(20*MCscale, 0, kDeviceWidth - 40*MCscale, 20*MCscale)];
    [feiYongV addSubview:_banView];
    
    
    UILabel * banTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80*MCscale, 18*MCscale)];
    banTitle.font=[UIFont systemFontOfSize:MLwordFont_3];
    banTitle.textColor=textBlackColor;
    banTitle.text=@"版本:";
    [_banView addSubview:banTitle];
    [banTitle sizeToFit];
    
    
    UIButton * banBtn = [[UIButton alloc]initWithFrame:CGRectMake(banTitle.right+10, 3, 120, _banView.height)];
    banBtn.tag=3000;
    [banBtn setTitle:@"完整版" forState:UIControlStateNormal];
    [banBtn setTitleColor:textBlackColor forState:UIControlStateNormal];
    [banBtn setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
    [banBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    [banBtn addTarget:self action:@selector(banBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_banView addSubview:banBtn];
    banBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    banBtn.left=banTitle.right+10*MCscale;
    
    
    UIButton * noBanBtn = [[UIButton alloc]initWithFrame:CGRectMake(banBtn.right+10*MCscale, 3, 110, _banView.height)];
    noBanBtn.tag=3001;
    [noBanBtn setTitle:@"收益版" forState:UIControlStateNormal];
    [noBanBtn setTitleColor:textBlackColor forState:UIControlStateNormal];
    [noBanBtn setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
    [noBanBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    [noBanBtn addTarget:self action:@selector(banBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_banView addSubview:noBanBtn];
    noBanBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    //    noBanBtn.right=banBtn.right+10*MCscale;
    
    
    
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(20, _banView.bottom+20, kDeviceWidth-40, 100)];
    //    backView.layer.borderWidth=1;
    //    backView.layer.borderColor=redTextColor.CGColor;
    [feiYongV addSubview:backView];
    
    
    
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(backView.left+10, 0, backView.width-20, 20)];
    [feiYongV addSubview:label];
    label.centerX=feiYongV.width/2;
    label.centerY=backView.top;
    label.backgroundColor=[UIColor whiteColor];
    label.textColor=redTextColor;
    label.text=@"免费赠送店铺宣传物料一套";
    label.font=[UIFont systemFontOfSize:MLwordFont_2];
    label.textAlignment=NSTextAlignmentCenter;
    
    
    _signView = [self newSignViewWithSetY:20*MCscale];
    [backView addSubview:_signView];

    
    
    _feiLable= [[UILabel alloc]initWithFrame:CGRectMake(0, _signView.bottom+10, backView.width, 80)];
    [backView addSubview:_feiLable];
    _feiLable.textColor=redTextColor;
    _feiLable.numberOfLines=3;
    _feiLable.textAlignment=NSTextAlignmentCenter;
    _feiLable.font=[UIFont systemFontOfSize:MLwordFont_3];
    _feiLable.top = _signView.bottom+5;
    _feiLable.centerX=backView.width/2;
    
    
    
    _submitBtn = [self newSubButtonWithSetY:_feiLable.bottom+10*MCscale];
    [backView addSubview:_submitBtn];
    _submitBtn.width = backView.width-40*MCscale;
    
    backView.height=_submitBtn.bottom+10;
    
    
    
    feiYongV.height=backView.bottom+10;
    
    return feiYongV;
}
-(UIView *)newSignViewWithSetY:(CGFloat)setY{
    UIView * signV ;
    signV = [[UIView alloc]initWithFrame:CGRectMake(20*MCscale, setY, kDeviceWidth - 40*MCscale, 40*MCscale)];
    signV.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *signViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(signTap:)];
    [signV addGestureRecognizer:signViewTap];
    
    
    UILabel * signLabel = [[UILabel alloc]initWithFrame:CGRectMake(5*MCscale, 5*MCscale, 100*MCscale, 30*MCscale)];
    signLabel.textColor = redTextColor;
    signLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    signLabel.text = @"签名:";
    [signV addSubview:signLabel];
    
    _signImageView = [[UIImageView alloc]initWithFrame:CGRectMake(signLabel.right +5*MCscale,0,80*MCscale,40*MCscale)];
    _signImageView.backgroundColor = [UIColor clearColor];
    [signV addSubview:_signImageView];
    
    return signV;
}
#pragma mark 提交按钮
-(UIButton *)newSubButtonWithSetY:(CGFloat)setY{
    UIButton * submit ;

    submit = [[UIButton alloc]initWithFrame:CGRectMake(20*MCscale,setY, kDeviceWidth-40, 40*MCscale)];
    [submit setTitle:@"创建开户" forState:UIControlStateNormal];
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submit.titleLabel.font = [UIFont boldSystemFontOfSize:MLwordFont_2];
    submit.titleLabel.textAlignment = NSTextAlignmentCenter;
    submit.layer.cornerRadius = 5;
    submit.layer.masksToBounds = YES;
    submit.backgroundColor = txtColors(250, 54, 71, 1);
//    submit.enabled = NO;
    [submit addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return submit;
}





#pragma mark -- 发票
-(UIView *)newFaVWithSetY:(CGFloat)setY{
    UIView * faV = [[UIView alloc]initWithFrame:CGRectMake(0, setY, kDeviceWidth, 100)];
    
    
    
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 100, 20)];
    [faV addSubview:btn];
    [btn setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    [btn setTitle:@"发票" forState:UIControlStateNormal];
    [btn setTitleColor:textBlackColor forState:UIControlStateNormal];
    btn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [btn addTarget:self action:@selector(faPiaoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag=2500;
    
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, btn.bottom+10*MCscale, kDeviceWidth, 100)];
    //    backView.layer.borderColor=redTextColor.CGColor;
    //    backView.layer.borderWidth=1;
    [faV addSubview:backView];
    
    NSArray * faTitleArr = @[@"收据",@"发票",@"邮寄",@"电子"];
    for (int i = 0; i < faTitleArr.count; i ++) {
        CGFloat btnW = backView.width/ 2-10*MCscale;
        CGFloat btnH = 20*MCscale;
        CGFloat btnX = 10*MCscale+i % 2 * btnW;
        CGFloat btnY =   i / 2 * (btnH+10*MCscale) + 10*MCscale;
        
        
        
        UIButton * btn1 = [[UIButton alloc]initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        btn1.tag=2510+i;
        [backView addSubview:btn1];
        [btn1 addTarget:self action:@selector(faPiaoOption:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
        [btn1 setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
        [btn1 setTitleColor:textBlackColor forState:UIControlStateNormal];
        btn1.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [btn1 setTitle:faTitleArr[i] forState:UIControlStateNormal];
        
        backView.height=btn1.bottom+10*MCscale;
    }
    faV.height=backView.bottom;
    
    
    
    
    return faV;
}
#pragma mark 开户协议
-(UIView *)setProtocolDataWithSetY:(CGFloat)setY
{
    
    
    //    UIImageView *imageView = [self.view viewWithTag:1000];
    UIView * proView = [[UIView alloc]initWithFrame:CGRectMake(20*MCscale,setY, kDeviceWidth - 40*MCscale, 30*MCscale)];
    proView.backgroundColor = [UIColor clearColor];
 
    
    
    
    UIButton * protocolBtn = [[UIButton alloc]initWithFrame:CGRectMake(5*MCscale, 5*MCscale, 135*MCscale, 20*MCscale)];
    protocolBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [protocolBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    [protocolBtn setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
    [protocolBtn setTitle:@"我已阅读并同意" forState:UIControlStateNormal];
    [protocolBtn setTitleColor:textBlackColor forState:UIControlStateNormal];
    protocolBtn.titleLabel.font=[UIFont systemFontOfSize:MLwordFont_7];
    [proView addSubview:protocolBtn];
    protocolBtn.selected=_isAgree;
    [protocolBtn addTarget:self action:@selector(changeIsAgree:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UILabel * xieyiLabel = [[UILabel alloc]initWithFrame:CGRectMake(protocolBtn.right,5*MCscale,188*MCscale, 20*MCscale)];
    xieyiLabel.text=@"《妙店佳系统使用协议》";
    xieyiLabel.textColor = txtColors(78, 194, 151, 1);
    xieyiLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
    xieyiLabel.userInteractionEnabled = YES;
    [proView addSubview:xieyiLabel];
    UITapGestureRecognizer *xieyiTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(xieyiBtnClick:)];
    [xieyiLabel addGestureRecognizer:xieyiTap];
    [xieyiLabel sizeToFit];
    
    UIView *xieyiView = [[UIView alloc]initWithFrame:CGRectMake(xieyiLabel.left, xieyiLabel.bottom, xieyiLabel.width, 1)];
    xieyiView.backgroundColor = txtColors(78, 194, 151, 1);
    [proView addSubview:xieyiView];
    xieyiView.width=xieyiLabel.width;
    return proView;
}
#pragma mark -- 按钮事件
/**
 *   签名的点击事件
 *
 *  @param tap 签名的点击事件
 */
-(void)signTap:(UITapGestureRecognizer *)tap{

        if (_isAgree) {
            //签名
            AutographView * autogra = [[AutographView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
            [autogra appear];
            autogra.Block=^(NSInteger index,NSDictionary * dict){
                if (index == 0) {
                    NSData *imageData = UIImageJPEGRepresentation(dict[@"image"], 0.9);
                    if (![dict isEqual:@{}]) {
                        _submitBtn.enabled = YES;
                        _submitBtn.backgroundColor = txtColors(250, 54, 71, 1);
                        _signImageView.image = [UIImage imageWithData:imageData];
                        _isSign=YES;
                    }
                    else
                    {
                        _signImageView.image=[UIImage new];
                        _submitBtn.enabled = NO;
                        _submitBtn.backgroundColor = txtColors(213, 213, 213, 1);
                        _isSign=NO;
                    }
             
                }
                else if (index == 2)
                {
        
                }

            };
            
            
        }
        else
        {
            [MBProgressHUD promptWithString:@"请阅读并同意开户协议"];

        }
}
/**
 *  选择行业
 */
-(void)selectHangYeClick:(UIButton *)sender
{
    ReviewSelectedView * sele = [ReviewSelectedView new];
    [sele appear];
    [sele reloadDataWithViewTag:7];
    sele.block=^(id data){
        _hangYeDic = (NSDictionary *)data;
        ((UITextField *)(sender.superview)).text=[NSString stringWithFormat:@"%@",_hangYeDic[@"name"]];
        ((UITextField *)(sender.superview)).rightView=nil;
        NSLog(@"%@",data);
    };
    
}
/**
 *  商城版 商铺版的点击事件
 *
 *  @param sender 商城版 商铺版的点击事件
 */
-(void)banBtnClick:(UIButton *)sender{
    if (sender.tag==3001) {
        _isShangChengBan=YES;
    }else{
        _isShangChengBan=NO;
    }
    [self reshBan];

}
-(void)reshBan{
    UIButton * btn1 = [_mainScrollView viewWithTag:3000];
    UIButton * btn2 = [_mainScrollView viewWithTag:3001];
    btn1.selected=NO;
    btn2.selected=NO;
    if (_isShangChengBan) {
        btn2.selected=YES;
    }else{
        btn1.selected=YES;
        
        
        
        [Request getFuWuDateListWithDic:@{} success:^(id json) {
            NSString * message = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
            if ([message isEqualToString:@"1"]) {
                SelectFuWuFeiBanBen * sele = [SelectFuWuFeiBanBen new];
                sele.datas=[NSMutableArray arrayWithArray:[json valueForKey:@"priceInfo"]];
                [sele appear];
                sele.block=^(NSDictionary * dic){
                    NSInteger month = [[NSString stringWithFormat:@"%@",dic[@"month"]] integerValue];
                    NSString * price = [NSString stringWithFormat:@"%@",dic[@"price"]];
                    _month=month;
                    _money = price;
                    NSDate * date = [NSDate date];
                    
                    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                    NSDateComponents *comps = nil;
                    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
                    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
                    [adcomps setYear:0];
                    [adcomps setMonth:month];
                    [adcomps setDay:0];
                    NSDate * newDate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
                    
                    
                    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
                    formatter.dateFormat=@"yyyy-MM-dd";
                    NSString * dateString = [formatter stringFromDate:newDate];
                    
                    
                    _feiLable.text = [NSString stringWithFormat:@"服务费:%@元\n服务有效期:%@",_money,dateString];
  
                };
            }else{
                [MBProgressHUD promptWithString:@"获取服务费列表失败"];
            }
        } failure:^(NSError *error) {
            
        }];
        
 
        
    }

    
    NSString * banBen = _isShangChengBan?@"2":@"1";
    NSDictionary * dic = @{@"dianpu.banben":banBen};
    [Request chooseKaiShengBanbenWithDic:dic success:^(id json) {
        NSString * message = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
        if ([message isEqualToString:@"1"]) {
            NSString * nianfei =[NSString stringWithFormat:@"%@",[json valueForKey:@"nianfei"]];
            _feiLable.text=[NSString stringWithFormat:@"年费:%@元",nianfei];;
            _money=nianfei;
        }
        if ([message isEqualToString:@"2"]) {
            NSString * shifukuan = [NSString stringWithFormat:@"%@",[json valueForKey:@"shifukuan"]];
            _feiLable.text=[NSString stringWithFormat:@"实付款:%@元",shifukuan];
  
            _money=shifukuan;
        }
        if ([message isEqualToString:@"3"]) { // 
            
            NSString * shifukuan = [NSString stringWithFormat:@"%@",[json valueForKey:@"shifukuan"]];
            NSString * zhifu = [NSString stringWithFormat:@"%@",[json valueForKey:@"zhifu"]];
            NSString * youhui   = [NSString stringWithFormat:@"%@",[json valueForKey:@"youhui"]];
            _feiLable.text=[NSString stringWithFormat:@"使用费用:%@元\n优惠:%@元\n实付款:%@元",zhifu,youhui,shifukuan];
            _money=shifukuan;
            
            if ([youhui isEqualToString:@"0"] && [zhifu isEqualToString:@"0"]) {
                _feiLable.text = [NSString stringWithFormat:@"实付款:%@元",shifukuan];
            }
            
        }
    } failure:^(NSError *error) {
        
    }];
}

/**
 *  是否同意协议
 *
 *  @param sender 是否同意协议的点击事件
 */
-(void)changeIsAgree:(UIButton *)sender{
    _isAgree=!_isAgree;
    sender.selected=_isAgree;
}
/**
 *  定位选点
 *
 *  @param sender 定位选点的点击事件
 */
-(void)locationBtnClick:(UIButton *)sender{

    
    
    if (sender.tag==320) {
        _isDing=YES;
    }else{
        _isDing=NO;
    }
    
    [self reshDing];
}
-(void)reshDing{
    UIButton * sen1 = [_mainScrollView viewWithTag:320];
    UIButton * sen2 = [_mainScrollView viewWithTag:321];
    sen1.selected=_isDing;
    sen2.selected=!_isDing;
    if (_isDing) {
        if (!_mapHelper) {
            _mapHelper = [PHMapHelper new];
        }
        [_mapHelper locationStartLocation:^{
        } locationing:^(BMKUserLocation *location, NSError *error) {
            _latitude=location.location.coordinate.latitude;
            _longitude=location.location.coordinate.longitude;
            [_mapHelper regeoWithLocation:CLLocationCoordinate2DMake(_latitude, _longitude) block:^(BMKReverseGeoCodeResult *result, BMKSearchErrorCode error) {
                if (error) {
                    _city=@"北京市";
                    return ;
                }
                _city=result.addressDetail.city;
            }];
            if (!error) {
                [_mapHelper endLocation];
            }
        } stopLocation:^{
            
           
        }];
        
        
        
    }else{
        if (!_mapHelper) {
        _mapHelper = [PHMapHelper new];
        }
        GetLocationView * get = [[GetLocationView alloc]init];
        [get appear];
        get.block=^(double latitude,double longitude){
            _latitude=latitude;
            _longitude=longitude;
            [_mapHelper regeoWithLocation:CLLocationCoordinate2DMake(_latitude, _longitude) block:^(BMKReverseGeoCodeResult *result, BMKSearchErrorCode error) {
                if (error) {
                    _city=@"北京市";
                    return ;
                }
                _city=result.addressDetail.city;
            }];

        };
    
    }
    
}


/**
 *  开户的按钮
 */
-(void)submitBtnClick:(UIButton *)sender{
    
    UITextField * phone = [_mainScrollView viewWithTag:11003];
    if (![phone.text isValidateMobile]) {
        [MBProgressHUD promptWithString:@"请输入有效的手机号"];
        return;
    }
    NSDictionary * dic = @{@"dianpu.yidongtel":phone.text};
    [Request judgePhoneWithDic:dic success:^(id json) {
        NSString * message =[NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
        if ([message isEqualToString:@"0"]) {
             [self kaihu];
        }else{
            [MBProgressHUD promptWithString:@"该手机号已经开过户"];
        }
        
        
    } failure:^(NSError *error) {
        
    }];

}

-(void)kaihu{
    //获取所有的值
    UITextField * dianpu = [_mainScrollView viewWithTag:11000];
    UITextField * hangye = [_mainScrollView viewWithTag:11001];
    UITextField * person = [_mainScrollView viewWithTag:11002];
    UITextField * phone = [_mainScrollView viewWithTag:11003];
    UITextField * fuwutel = [_mainScrollView viewWithTag:11004];


    NSString * dingWeiType = _isDing?@"0":@"1";
    // 坐标
    NSString * latitude = [NSString stringWithFormat:@"%f",_latitude];
    NSString * longitude = [NSString stringWithFormat:@"%f",_longitude];
    NSString * city = [NSString stringWithFormat:@"%@",_city];
    NSString * userId = user_Id?user_Id:@"0";
    
    
    UITextField * address = [_mainScrollView viewWithTag:11006];
    NSString * banBen = _isShangChengBan?@"2":@"1";
    
    

    
    NSString *  imgSgFileNmae = @"qianming.png";
    NSString *  img1FileName;
    img1FileName = _img1?@"yingyezhizhao.png":@"";
    NSString *  img2FileName;
    img2FileName = _img2?@"shenfenzheng.png":@"";
    NSString *  img3FileName;
    img3FileName= _img3?@"yinhangka.png":@"";

    // 未赋值
    NSString * money = _money;
    NSString * faPiaoType  = _isFaPiao ?@"1":@"0";
    NSString *  fapiaoinfo = _isShouJu?@"1":@"2";
    NSString * fapiaoWay = _isYouJi?@"1":@"2";
    
    if (!_isAgree) {
        [MBProgressHUD promptWithString:@"请阅读协议并同意"];
        return;
    }
    if ([dianpu.text isEmptyString]||
        [person.text isEmptyString]||
        [phone.text isEmptyString]||
        [fuwutel.text isEmptyString]||
        [address.text isEmptyString]) {
        [MBProgressHUD promptWithString:@"请完善信息"];
        return;
    }
    

    if ([hangye.text isEqualToString:@"请选择行业"] || !_hangYeDic) {
        [MBProgressHUD promptWithString:@"请选择行业"];
        return;
    }
    NSString * hangYeId = [NSString stringWithFormat:@"%@",_hangYeDic[@"id"]];
    
    
    
    if (!_isSign) {
        [MBProgressHUD promptWithString:@"请签名"];
        return;
    }
    
    if (_isFaPiao && _isNoSelecedShouJu && _isNoSelecedYouJi) {
        if (_isNoSelecedShouJu) {
            [MBProgressHUD promptWithString:@"请选择收据或发票"];
             return;
        }
        if (_isNoSelecedYouJi) {
            [MBProgressHUD promptWithString:@"请选择邮寄或电子"];
             return;
        }
       
    }
    
    
    NSMutableDictionary * pram =[NSMutableDictionary dictionaryWithDictionary:@{@"dianpu.dianpuname":dianpu.text,                //店铺名称
                                @"dianpu.suozaihangyi":hangYeId,              //所属行业（传行业id）
                                @"dianpu.dianpuleixing":dingWeiType,              //定位类型 （0当前位置 1地图定位）
                                @"dianpu.x":latitude,                           //x坐标
                                @"dianpu.y":longitude,                          //y坐标
                                @"dianpu.lianxiren":person.text,                //联系人姓名
                                @"dianpu.yidongtel":phone.text,               //联系手机号
                                @"dianpu.kefurexian":fuwutel.text,              //服务电话
                                @"dianpu.dingweidizhi":address.text,           //店铺地址
                                @"dianpu.qianming":imgSgFileNmae,
                                @"dianpu.yingyezhizhao":img1FileName,          //营业执照(命名：yingyezhizhao.后缀名,没上传 传空 )
                                @"dianpu.suiwudengjizhen":img2FileName,       //身份证(命名：shenfenzheng.后缀名,没上传 传空 )
                                @"dianpu.jigoudaima":img3FileName,            //银行卡(命名：yinhangka.后缀名,没上传 传空 )
                                @"dianpu.shenhe":@"0",                  //店铺审核状态（2草稿  0默认未审核）
                                @"zhiyuanid":userId,                       //职员id(未登录传0)
                                @"money":money,                            //开户金额
                                @"dianpu.shifoukaitonghoutai":city,   //所属城市
                                @"dianpu.banben":banBen,                  //开户版本（1=商户版2=商城版）
                                @"fapiao":faPiaoType,                         //是否选择发票（1=选择  0=未选择）
                                @"fapiaoinfo":fapiaoinfo,               //1=收据 2=发票（选择发票=1时传值，否则不传）
                                @"fapiaoway":fapiaoWay               //1=邮寄  2=电子（选择发票=1时传值，否则不传）}
                                }];
    
    
    if ([faPiaoType isEqualToString:@"0"]) {
        [pram removeObjectForKey:@"fapiaoinfo"];
        [pram removeObjectForKey:@"fapiaoway"];
    }
    if ([banBen isEqualToString:@"1"]) {
        [pram addEntriesFromDictionary:@{@"month":[NSString stringWithFormat:@"%ld",(long)_month]}];
    }

    TopUpView * top = [TopUpView new];
    __block TopUpView * weakTop =  top;
    [top setMoney:[self.money floatValue] limitMoney:0 title:[NSString stringWithFormat:@"妙店佳商铺+%@备用金充值",user_tel] body:user_Id canChange:NO];
    [top appear];
    top.payBlock=^(BOOL isSuccess){
        if (isSuccess) {
            [Request kaiHuShengBanWithDic:pram success:^(id json) {
                
                NSString * message = [NSString stringWithFormat:@"%@",[json valueForKey:@"message"]];
                if ([message isEqualToString:@"1"]) {
                    
                    _dianpuid = [NSString stringWithFormat:@"%@",[json valueForKey:@"dianpuid"]];
                    [self uploadTuPian];
                    _dataDic = (NSDictionary *)json;
                    [weakTop disAppear];
                    [self login];
                    [self clearData];
                    
                    return ;
                }
                if ([message isEqualToString:@"0"]) {
                    [MBProgressHUD promptWithString:@"参数有空"];
                    return ;
                }
                [MBProgressHUD promptWithString:[NSString stringWithFormat:@"%@",message]];
            } failure:^(NSError *error) {
                
            }];

        }else{
            [MBProgressHUD promptWithString:@"支付失败"];
        }
        

    };
    
    
//    OnLinePayView * pay = [OnLinePayView new];
//    __block OnLinePayView *  weakPay = pay;
//    
//    NSString * mony =[NSString stringWithFormat:@"%.2f",[self.money floatValue]];
//    [pay setMoney:mony];
//    [pay appear];
//    pay.payBlock=^(BOOL isSuccess){
//        if (isSuccess) {
//            [weakPay disAppear];
//    
//                   }else{
//            [MBProgressHUD promptWithString:@"支付失败"];
//        }
//    };
    
  
    
    
    
}
-(void)faPiaoBtnClick:(UIButton *)sender{
    _isFaPiao = !_isFaPiao;
    [self reshFaPiao];
    
    
}
-(void)reshFaPiao{
    UIButton * selBtn = [_mainScrollView viewWithTag:2500];
    UIButton * wayBtn = [_mainScrollView viewWithTag:2513];
    
    if (!_isFaPiao) {
        _isNoSelecedYouJi=YES;
        _isNoSelecedShouJu=YES;
    }
    selBtn.selected=_isFaPiao;
    if (_isFaPiao) {
        _faPiaoView.height=wayBtn.bottom+20*MCscale;
    }else{
        _faPiaoView.height=selBtn.bottom;
    }
    for (int i = 2510; i < 2514; i++) {
        UIButton * wayBtn = [_mainScrollView viewWithTag:i];
        if (_isFaPiao) {
            wayBtn.hidden=NO;
        }else{
            wayBtn.hidden=YES;
        }
    }
    
    

    _protocolView.top=_faPiaoView.bottom+10*MCscale;
    _mainScrollView.contentSize=CGSizeMake(_mainScrollView.width, _protocolView.bottom+10*MCscale);
    [self reshPiaoOption];
}
-(void)faPiaoOption:(UIButton *)sender{
    switch (sender.tag) {
        case 2510:
            _isShouJu=YES;
            _isNoSelecedShouJu=NO;
            break;
        case 2511:
            _isShouJu=NO;
            _isNoSelecedShouJu=NO;
            break;
        case 2512:
            _isYouJi=YES;
            _isNoSelecedYouJi=NO;
            break;
        case 2513:
            _isYouJi=NO;
            _isNoSelecedYouJi=NO;
            break;
        default:
            break;
    }

    [self reshPiaoOption];
    
}
-(void)reshPiaoOption{

    // 收据 和 发票
    UIButton * btn11 = [_mainScrollView viewWithTag:2510];
    UIButton * btn12 = [_mainScrollView viewWithTag:2511];
    if (!_isNoSelecedShouJu) {// 已选择 收据 发票
        btn11.selected=_isShouJu;
        btn12.selected=!_isShouJu;
    }else{
        btn11.selected=NO;
        btn12.selected=NO;
    }

    UIButton * btn21 = [_mainScrollView viewWithTag:2512];
    UIButton * btn22 = [_mainScrollView viewWithTag:2513];
    if (!_isNoSelecedYouJi) {// 已选择 邮寄 电子
        // 邮寄 和 电子
        btn21.selected=_isYouJi;
        btn22.selected=!_isYouJi;
    }else{
        btn21.selected=NO;
        btn22.selected=NO;
    }

    
}


-(void)uploadTuPian{
    NSString * dianpuid = _dianpuid;
    
    
    UIImageView * imgSg = _signImageView;
    UIImageView * imgV1 = [_mainScrollView viewWithTag:1000];
    UIImageView * imgV2 = [_mainScrollView viewWithTag:1001];
    UIImageView * imgV3 = [_mainScrollView viewWithTag:1002];
    
    
    NSString * imgSgFileName = @"qianming.png";
    NSString *  img1FileName;
    img1FileName = _img1?@"yingyezhizhao.png":@"";
    NSString *  img2FileName;
    img2FileName = _img2?@"shenfenzheng.png":@"";
    NSString *  img3FileName;
    img3FileName= _img3?@"yinhangka.png":@"";
    
    
    
    
    NSMutableArray * selectedImageArray = [NSMutableArray array];
    
    
    if (_isSign) {
        [selectedImageArray addObject:@{@"imageName":imgSgFileName,@"image":imgSg.image}];
    }
    
    if (_img1) {
        [selectedImageArray addObject:@{@"imageName":img1FileName,@"image":imgV1.image}];
    }
    if (_img2) {
        [selectedImageArray addObject:@{@"imageName":img2FileName,@"image":imgV2.image}];
    }
    if (_img3) {
        [selectedImageArray addObject:@{@"imageName":img3FileName,@"image":imgV3.image}];
    }
 
    NSLog(@"selectedImageArrayselectedImageArray%@",selectedImageArray);
    
    
     __block NSInteger  count = 0;
    
    if (selectedImageArray.count==0 || selectedImageArray == nil) {

        [self login];
        [MBProgressHUD promptWithString:@"注册成功"];
    }
    
    for (NSDictionary *dict in selectedImageArray) {
        NSLog(@"dictdict%@",dict);
        UIImage *image = dict[@"image"];
        NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"dianpuid":[NSString stringWithFormat:@"%@",dianpuid]}];
        
        AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
        //网络延时设置15秒
        manger.requestSerializer.timeoutInterval = 15;
        NSString *url = @"fileuploadDianpuInfo.action";
        NSString * urlPath = [NSString stringWithFormat:@"%@%@",HTTPImage,url];
        [manger POST:urlPath parameters:pram constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
            if (![dict isEqual:@{}]) {
                NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
                NSString *fileName = [NSString stringWithFormat:@"%@",dict[@"imageName"]];
                [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
            }
        }success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            [self clernDataForKaihu];
//            [MBProgressHUD promptWithString:@"开户成功"];
                count ++;
            if (count>=selectedImageArray.count) {
         
                [self login];
                [MBProgressHUD promptWithString:@"注册成功"];
            }
        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }
    

}
/**
 *  协议的点击事件
 *
 *  @param sender 协议的点击事件
 */
-(void)xieyiBtnClick:(UIButton *)sender{
    UseDirectionViewController *agr = [[UseDirectionViewController alloc]init];
    //    if (isModify) {
    //        agr.pageUrl = [NSString stringWithFormat:@"%@/useXieyi.action?dianpuid=%@",HTTPImage,dianpuID];
    //    }
    //    else
    //    {
    agr.pageUrl = [NSString stringWithFormat:@"%@useXieyi.action",HTTPImage];
    //    }
    agr.titStr = @"妙店佳系统使用协议";
    agr.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *bar=[[UIBarButtonItem alloc]init];
    bar.image = [UIImage imageNamed:@"返回"];
    agr.navigationItem.backBarButtonItem=bar;
    [self.controller.navigationController pushViewController:agr animated:YES];
}

-(void)login{
    //测试
    UITextField * phone =[_mainScrollView viewWithTag:11003];
    NSString * loginPass = [NSString stringWithFormat:@"%@",_dataDic[@"password"]];
    NSString * dianpuid = [NSString stringWithFormat:@"%@",_dataDic[@"dianpuid"]];
    
    
    set_User_Tel(phone.text);
    set_User_dianpuID(dianpuid);
    set_LoginPass(loginPass);
    if (self.controller.successBlock) {
        self.controller.successBlock(YES);
    }
    
    [self.controller.navigationController popViewControllerAnimated:YES];
    [self.controller dismissViewControllerAnimated:YES completion:^{
    }];
    return;

}
/**
 *  清空数据
 */
-(void)clearData{
    UITextField * dianPu=[_mainScrollView viewWithTag:11000];
    UITextField * person=[_mainScrollView viewWithTag:11002];
    UITextField * phone =[_mainScrollView viewWithTag:11003];
    UITextField * code  =[_mainScrollView viewWithTag:11004];
    dianPu.text=@"";
    person.text=@"";
    phone.text=@"";
    code.text=@"";
}


@end
