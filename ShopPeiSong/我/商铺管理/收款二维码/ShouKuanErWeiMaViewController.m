//
//  ShouKuanErWeiMaViewController.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/20.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "ShouKuanErWeiMaViewController.h"
#import "AFHTTPRequestOperationManager.h"


@interface ShouKuanErWeiMaViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong)NSMutableDictionary * dataDic;

@property (nonatomic,strong)UIImageView * currentImgView;
@property (nonatomic,strong)UIImage     * selecedImg;
@end

@implementation ShouKuanErWeiMaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newView];
    [self reshData];
    // Do any additional setup after loading the view.
}
-(void)initData{
    _dataDic =[NSMutableDictionary dictionary];
}
-(void)reshData{
    NSDictionary * pram = @{@"id":user_dianpuID,
                            };
    [_dataDic removeAllObjects];
    [Request getDianPuSKerWeiMaWithDic:pram Success:^(id json) {
        [_dataDic addEntriesFromDictionary:(NSDictionary*)json];
        [self reshView];
    } failure:^(NSError *error) {
        [self reshView];
    }];


}
-(void)reshView{
    UIImageView * zfbImg = [self.view viewWithTag:100];
    UIImageView * wxImg = [self.view viewWithTag:101];
    
    NSString * zfbSt = [NSString stringWithFormat:@"%@",_dataDic[@"zhifubao"]];
    NSString * wxSt = [NSString stringWithFormat:@"%@",_dataDic[@"weixin"]];
    
//    [zfbImg sd_setImageWithURL:[NSURL URLWithString:zfbSt] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"]];
    zfbImg.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:zfbSt]]];
    
    
    
//    [wxImg sd_setImageWithURL:[NSURL URLWithString:wxSt] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"]];
    wxImg.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:wxSt]]];
}
-(void)newView{
    self.navigationItem.title=@"收款二维码";
    
    
    CGFloat setY = 64;
    for (int i =0; i < 2; i ++) {
        
        
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, setY+10, kDeviceWidth, 100)];
        [self.view addSubview:backView];
        backView.backgroundColor=[UIColor whiteColor];
        
        
        
        
        
        CGFloat BsetY = 0;
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, BsetY+10, backView.width, 25)];
        [backView addSubview:titleLabel];
        titleLabel.font=[UIFont systemFontOfSize:MLwordFont_3];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.textColor=textBlackColor;
        titleLabel.text=i==0?@"微信收款二维码":@"支付宝收款二维码";
        BsetY =titleLabel.bottom;
        
        
        UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(0, BsetY, backView.width*0.4, backView.width*0.4)];
        img.centerX=backView.width/2;
        img.image=[UIImage imageNamed:@"yonghutouxiang"];
        [backView addSubview:img];
        BsetY=img.bottom;
        img.tag=100+i;
        img.userInteractionEnabled=YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgPicker:)];
        [img addGestureRecognizer:tap];
        
        
        backView.height= BsetY +10;
        setY = backView.bottom;
    }
    
    
    
    
    UILabel * bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, setY+20, kDeviceWidth, 25)];
    [self.view addSubview:bottomLabel];
    bottomLabel.font=[UIFont systemFontOfSize:MLwordFont_4];
    bottomLabel.textColor=textBlackColor;
    bottomLabel.textAlignment=NSTextAlignmentCenter;
    bottomLabel.text=@"点击二维码上传第三方收款二维码";
    setY= bottomLabel.bottom;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)imgPicker:(UIGestureRecognizer *)tap{
    
    UIImagePickerController * imagePicker = [UIImagePickerController new];
    imagePicker.delegate=self;
    imagePicker.allowsEditing=YES;
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"选择图片路径" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancalAction = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _currentImgView = (UIImageView *)(tap.view);
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _currentImgView = (UIImageView *)(tap.view);
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *cleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancalAction];
    [alert addAction:otherAction];
    [alert addAction:cleAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    _selecedImg=image;

    [self uploadErWeiMaImage];
    
};

-(void)uploadErWeiMaImage{
    
    NSString * name = _currentImgView.tag==100?@"weixin":@"zhifubao";

    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"dianpuid":user_dianpuID,@"name":name}];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    //网络延时设置15秒
    manger.requestSerializer.timeoutInterval = 15;
    
    NSString * urlPath = [NSString stringWithFormat:@"%@%@",HTTPImage,@"zhifuimg2.action"];
    [manger POST:urlPath parameters:pram constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        
        NSData *imageData = UIImageJPEGRepresentation(_selecedImg, 0.8);
        NSString *fileName = [NSString stringWithFormat:@"%@.png",name];
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
    }success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _currentImgView.image = _selecedImg;
        
        // [MBProgressHUD ]
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [MBProgressHUD promptWithString:@"上传图片网络失败"];
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

@end
