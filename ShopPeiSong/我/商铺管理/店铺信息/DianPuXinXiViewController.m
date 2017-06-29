//
//  DianPuXinXiViewController.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/20.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "DianPuXinXiViewController.h"
#import "AFHTTPRequestOperationManager.h"


@interface DianPuXinXiViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)UIScrollView * mainScrollView;
@property (nonatomic,strong)UIImageView  * currentImgView;


@property (nonatomic,strong)NSMutableDictionary * dataDic;

@property (nonatomic,assign)BOOL logoHasLoad;
@end

@implementation DianPuXinXiViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
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
-(void)newView{
    self.navigationItem.title=@"商铺信息";
    
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, self.view.height-64)];
    [self.view addSubview:_mainScrollView];
    
    CGFloat setY = 0;
    
    UIImageView * headImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, setY+ 30, 120, 120)];
    [_mainScrollView addSubview:headImg];
    headImg.centerX=_mainScrollView.width/2;
    setY = headImg.bottom;
    headImg.image=[UIImage imageNamed:@"yonghutouxiang"];
    headImg.userInteractionEnabled=YES;
    headImg.tag=100;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerImg:)];
    [headImg addGestureRecognizer:tap];

    
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, setY+10, _mainScrollView.width, 25)];
    [_mainScrollView addSubview:titleLabel];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:MLwordFont_4];
    titleLabel.textColor=naviBarTintColor;
    titleLabel.text=@"东方真功夫";
    setY = titleLabel.bottom+30;
    titleLabel.tag=101;
    
    
    NSArray * cellArray = @[@"服务电话",@"店铺地址",@"请填写店铺公告",@"请填写经营范围内容"];
    for (int i = 0; i  < cellArray.count; i++) {
        CellView * cellView = [[CellView alloc]initWithFrame:CGRectMake(10, setY, _mainScrollView.width-20, 40)];
        [_mainScrollView addSubview:cellView];
        cellView.titleTF.left=10;
        cellView.titleTF.width=cellView.width-20;
        cellView.titleTF.placeholder=[NSString stringWithFormat:@"%@",cellArray[i]];
         setY =cellView.bottom;
        cellView.tag=102+i;
    }
    
    
    
    UIButton * saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(20*MCscale, setY+40*MCscale, kDeviceWidth-40*MCscale, 50*MCscale);
    saveBtn.backgroundColor = txtColors(249, 54, 73, 1);
    saveBtn.layer.masksToBounds = YES;
    saveBtn.layer.cornerRadius = 5.0;
    [saveBtn setTitle:@"提交" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:MLwordFont_2];
    [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:saveBtn];
    setY = saveBtn.bottom;
    
    _mainScrollView.contentSize=CGSizeMake(_mainScrollView.width, setY);
}
-(void)reshData{
    NSDictionary * pram = @{@"id":user_dianpuID,
                           };
    [Request getDianPuInfoWithDic:pram Success:^(id json) {
        NSString * message = [NSString stringWithFormat:@"%@",[json valueForKey:@"messages"]];
        if ([message isEqualToString:@"1"]) {
            [_dataDic removeAllObjects];
            [_dataDic addEntriesFromDictionary:[NSDictionary dictionaryWithDictionary:json]];
            [self reshView];
        }else{
            [MBProgressHUD promptWithString:@"获取失败"];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)reshView{
    UIImageView * headImg   = [self.view viewWithTag:100];
    UILabel     * nameLabel = [self.view viewWithTag:101];
    CellView    * phoneCell = [self.view viewWithTag:102];
    CellView    * addressCell = [self.view viewWithTag:103];
    CellView    * gonggaoCell = [self.view viewWithTag:104];
    CellView    * neirongCell = [self.view viewWithTag:105];
    
    NSString * headLink = [NSString stringWithFormat:@"%@",_dataDic[@"logo"]];
    NSString * nameSt = [NSString stringWithFormat:@"%@",_dataDic[@"dinapuname"]];
    NSString * phoneSt = [NSString stringWithFormat:@"%@",_dataDic[@"phone"]];
    NSString * addressSt = [NSString stringWithFormat:@"%@",_dataDic[@"dizhi"]];
    NSString * gonggaoSt = [NSString stringWithFormat:@"%@",_dataDic[@"gonggao"]];
    NSString * neirongSt = [NSString stringWithFormat:@"%@",_dataDic[@"tese"]];
    
//    headImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:headLink]]];
//    if (!headImg.image) {
//        headImg.image=[UIImage imageNamed:@"yonghutouxiang"];
//    }
    [headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",headLink]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"] options:SDWebImageRefreshCached];
    
    nameLabel.text=[nameSt isEmptyString]?@"":nameSt;
    phoneCell.titleTF.text=[phoneSt isEmptyString]?@"":phoneSt;
    addressCell.titleTF.text=[addressSt isEmptyString]?@"":addressSt;
    gonggaoCell.titleTF.text=[gonggaoSt isEmptyString]?@"":gonggaoSt;
    neirongCell.titleTF.text=[neirongSt isEmptyString]?@"":neirongSt;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- btnCLick
-(void)saveBtnClick:(UIButton *)sender{
//    UIImageView * headImg = [self.view viewWithTag:100];
//    UILabel     * nameLabel = [self.view viewWithTag:101];
    CellView    * phoneCell = [self.view viewWithTag:102];
    CellView    * addressCell = [self.view viewWithTag:103];
    CellView    * gonggaoCell = [self.view viewWithTag:104];
    CellView    * neirongCell = [self.view viewWithTag:105];
    
    
    NSString * phoneSt = [NSString stringWithFormat:@"%@",_dataDic[@"phone"]];
    NSString * addressSt = [NSString stringWithFormat:@"%@",_dataDic[@"dizhi"]];
    NSString * gonggaoSt = [NSString stringWithFormat:@"%@",_dataDic[@"gonggao"]];
    NSString * neirongSt = [NSString stringWithFormat:@"%@",_dataDic[@"tese"]];
    if ([phoneCell.titleTF.text isEqualToString:phoneSt]&&
        [addressCell.titleTF.text isEqualToString:addressSt]&&
        [gonggaoCell.titleTF.text isEqualToString:gonggaoSt]&&
        [neirongCell.titleTF.text isEqualToString:neirongSt]&&
        !_currentImgView) {
        [MBProgressHUD promptWithString:@"你还未做任何修改"];
        return;
    }
    
    
    
    if ([phoneCell.titleTF.text isEmptyString]||
        [addressCell.titleTF.text isEmptyString]||
        [gonggaoCell.titleTF.text isEmptyString]||
        [neirongCell.titleTF.text isEmptyString]) {
        [MBProgressHUD promptWithString:@"内容有空"];
        return;
    }
    
    NSDictionary * pram = @{@"id":user_dianpuID,
                            @"dianpu.dianpuleixing":gonggaoCell.titleTF.text,
                            @"dianpu.lianxidizi":neirongCell.titleTF.text,
                            @"dianpu.dianpulogo":[NSString stringWithFormat:@"%@.png",user_dianpuID],
                            @"dianpu.kefurexian":phoneCell.titleTF.text,
                            @"dianpu.dingweidizhi":addressCell.titleTF.text};
    [Request alterDianPuInfoWithDic:pram Success:^(id json) {
        NSString * message = [NSString stringWithFormat:@"%@",[json valueForKey:@"messages"]];
        if ([message isEqualToString:@"1"]) {
            [MBProgressHUD promptWithString:@"修改成功"];
            UIImageView * headImg = [self.view viewWithTag:100];
            
            [self upLoadImage:headImg.image name:user_dianpuID];
            
        }else{
            [MBProgressHUD promptWithString:@"修改失败"];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- headerImg
-(void)headerImg:(UITapGestureRecognizer *)tap{
   
    UIImagePickerController * imagePicker = [UIImagePickerController new];
    imagePicker.delegate=self;
    imagePicker.allowsEditing=YES;

    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"选择图片路径" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancalAction = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

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
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    image = [image imageByScalingToSize:CGSizeMake(120, 120)];

    UIImageView * headImg = [self.view viewWithTag:100];
    _currentImgView=headImg;
    headImg.image=image;

    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}



-(void)upLoadImage:(UIImage *)image name:(NSString *)name{
    
    NSDictionary * pram = @{@"name":name,
                            @"file":image};
    [Request upLoadImageWithUrl:@"fileuploadDianpuInfo.action" Dic:pram     Success:^(id json) {
        [self reshData];
//        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
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
