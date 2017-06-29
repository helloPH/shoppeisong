//
//  DianPuErWeiMaViewController.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/20.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "DianPuErWeiMaViewController.h"

@interface DianPuErWeiMaViewController ()

@property (nonatomic,strong)NSMutableDictionary * dataDic;
@end

@implementation DianPuErWeiMaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newView];
    [self reshData];
    // Do any additional setup after loading the view.
}
-(void)initData{
    _dataDic = [NSMutableDictionary dictionary];
}
-(void)reshData{
    [_dataDic removeAllObjects];
    NSDictionary * pram = @{@"dianpuid":user_dianpuID};
    [Request getQRcodeWithDic:pram Success:^(id json) {
        [_dataDic addEntriesFromDictionary:[NSDictionary dictionaryWithDictionary:json]];
        [self reshView];
    } failure:^(NSError *error) {
        [self reshView];
    }];
    
}
-(void)reshView{
    
    
    UIImageView * imgView = [self.view viewWithTag:100];
//    UILabel     * tipLabel = [self.view viewWithTag:101];
    UILabel     * titleLabel = [self.view viewWithTag:102];
    UIButton    * saveBtn    = [self.view viewWithTag:103];
    
    
    NSString * erweimaSt = [NSString stringWithFormat:@"%@",[_dataDic valueForKey:@"erweima"]];
    
    NSString * dpname = [NSString stringWithFormat:@"%@",[_dataDic valueForKey:@"dianpuname"]];
    dpname=[dpname isEmptyString]?@"":dpname;
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:erweimaSt] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"] options:SDWebImageRefreshCached];
    titleLabel.text = dpname;
    
    
    if ([erweimaSt isEmptyString] || [erweimaSt isEqualToString:@"0"]) {
        saveBtn.userInteractionEnabled=NO;
        saveBtn.selected=YES;
        
    }else{
        saveBtn.userInteractionEnabled=YES;
        saveBtn.selected=NO;
    }

    
}
-(void)newView{
    self.navigationItem.title=@"店铺二维码";
    CGFloat setY = 100;
    
    UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(0, setY, self.view.width*0.4, self.view.width*0.4)];
    setY=img.bottom;
    img.centerX=self.view.width/2;
    [self.view addSubview:img];
    img.tag=100;
    
    UILabel * tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(img.left, setY, img.width, 25)];
    tipLabel.font=[UIFont systemFontOfSize:MLwordFont_4];
    tipLabel.textColor=lineColor;
    tipLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:tipLabel];
    setY =tipLabel.bottom;
    tipLabel.text=@"店铺独享二维码";
    tipLabel.tag=101;
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(img.left, setY+10, img.width, 25)];
    titleLabel.font=[UIFont systemFontOfSize:MLwordFont_2];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=redTextColor;
    [self.view addSubview:titleLabel];
    titleLabel.text=@"东北麻辣烫";
    setY =titleLabel.bottom;
    titleLabel.tag=102;
    
    UIButton * saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(20*MCscale, setY+40*MCscale, kDeviceWidth-40*MCscale, 50*MCscale);

    [saveBtn setBackgroundImage:[UIImage ImageForColor:redTextColor] forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage ImageForColor:lineColor] forState:UIControlStateSelected];
    saveBtn.layer.masksToBounds = YES;
    saveBtn.layer.cornerRadius = 5.0;
    [saveBtn setTitle:@"存到本地" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    setY = saveBtn.bottom;
    saveBtn.tag=103;
    
    
    UILabel * uploadLabel = [[UILabel alloc]initWithFrame:CGRectMake(saveBtn.left, setY+10, saveBtn.width, 25)];
    uploadLabel.font=[UIFont systemFontOfSize:MLwordFont_2];
    uploadLabel.numberOfLines=2;
    [self.view addSubview:uploadLabel];
    
//    uploadLabel.text=@"上传店铺logo后店铺独享二维码可以生成带有店铺logo二维码";
 
    NSMutableAttributedString * upTitle = [[NSMutableAttributedString alloc]initWithString:@"上传店铺logo"];
    [upTitle addAttribute:NSForegroundColorAttributeName value:naviBarTintColor range:NSMakeRange(0, upTitle.length)];
    
    
    NSMutableAttributedString * upTitle1 = [[NSMutableAttributedString alloc]initWithString:@"后店铺独享二维码可以生成带有店铺logo二维码"];
    [upTitle1 addAttribute:NSForegroundColorAttributeName value:textBlackColor range:NSMakeRange(0, upTitle1.length)];
    [upTitle1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:MLwordFont_5] range:NSMakeRange(0, upTitle1.length)];
    
    [upTitle appendAttributedString:upTitle1];
    
    uploadLabel.attributedText= upTitle;
    [uploadLabel sizeToFit];
    
    
//    UIButton * uploadBtn = [[UIButton alloc]initWithFrame:CGRectMake(saveBtn.left, setY+10, 10, 25)];
//    [self.view addSubview:uploadBtn];
//    [uploadBtn setTitleColor:naviBarTintColor forState:UIControlStateNormal];
//    uploadBtn.titleLabel.font=[UIFont systemFontOfSize:MLwordFont_2];
//    [uploadBtn setTitle:@"上传店铺logo" forState:UIControlStateNormal];
//    [uploadBtn sizeToFit];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- btnClick
-(void)saveBtnClick:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    
    UIImageView * imgView = [self.view viewWithTag:100];
    UIImageWriteToSavedPhotosAlbum(imgView.image, self, nil, nil);
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"二维码已保存至本地!" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    [alert show];
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
