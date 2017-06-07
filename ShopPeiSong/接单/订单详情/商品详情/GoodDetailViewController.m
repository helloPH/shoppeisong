//
//  GoodDetailViewController.m
//  LifeForMM
//
//  Created by MIAO on 16/11/9.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "GoodDetailViewController.h"
#import "Header.h"

#import "goodDeailModel.h"
#import "TGCenterLineLabel.h"

@interface GoodDetailViewController ()<MBProgressHUDDelegate,CAAnimationDelegate,UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong)NSMutableDictionary * dataDic;
@property (nonatomic,assign)BOOL loadCurrentGoods;

@property (nonatomic,strong)NSMutableArray * dadangIds;
@property (nonatomic,assign)NSInteger       keXuangIndex;
@end

@implementation GoodDetailViewController{
    UIScrollView *mainScrollView;

    NSMutableArray *chooseArray;//型号
    NSInteger lastChooseSize;//上次选择型号标记
    NSInteger goodCount;//数量
    CALayer  *anmiatorlayer; //贝塞尔曲线 加入购物车动画
    UIImageView *addCarImageView;//加入购物车原点
    NSMutableArray *colorsArray;//存放颜色image
    NSInteger lastColor;//上次选中的颜色
    UILabel *totlMoney;
    NSMutableArray *goodDataAry;//数据
    NSInteger cellCount;//单元格行数
    NSMutableArray *numLabelAry;//数量加减label
    NSMutableArray *cellHeighAry;//关联商品image
    NSMutableArray *aryForHeadViews;//存放头视图中子视图
    NSString *yanse;//选择的颜色
    NSString *seleimgUrl;
    NSString *seleMoney;
    NSString *xinghao;//型号
    NSMutableArray *dadangAry;//亲密搭档



    UILabel *youhuiLabel;//优惠价格
    UIImageView *whiteCar;//点击进入购物车
    UIImageView *chooseBtnView;//选好了按钮
    UILabel *carEmptyLab; //购物车-空
    UIImageView *carEmptyImg;//
    BOOL goodTehui; //1 是特惠商品
    NSUserDefaults *userDefault;
    UILabel *tishiLabel;
    UIButton *subtractBtn;//数量减
    UIButton *addBtn;//数量加
    UILabel *goodNumLabel;//数量显示
    UIButton *addCarBtn;//加入购物车按钮
    UIView *selectedColorView;//选择颜色
    UIImageView *detailImage;//商品图片
    UILabel *    newMoneyLabel;
    CGFloat mainHeight;//高度
    UIImageView *caozuotishiImage;
}
-(void)initData{
    _dataDic = [NSMutableDictionary dictionary];
    _dadangIds= [NSMutableArray array];
    _keXuangIndex = 100;
    
    
    
    lastChooseSize = -1;
    goodCount = 1;
    lastColor = -1;
    cellCount = 0;
//    tolMoney = 0.0;
    goodTehui = 1;
    goodDataAry = [[NSMutableArray alloc]init];
    numLabelAry = [[NSMutableArray alloc]init];
    cellHeighAry = [[NSMutableArray alloc]init];
    aryForHeadViews = [[NSMutableArray alloc]init];
    dadangAry = [[NSMutableArray alloc]init];
    yanse = @"0";
    seleimgUrl= @"0";
    xinghao = @"0";
    seleMoney = @"0";
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setHidden:NO];

}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_block) {
        _block(_hasGoodArray);
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];

    self.view.backgroundColor = [UIColor whiteColor];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initNavigation];
    [self goodPropertydeal];
//    [self maskViewView];
}
-(void)judgeTheFirst
{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isFirstShangpinxiangqing"] integerValue] == 1) {
        NSString *url = @"images/caozuotishi/shangpinxiangqing.png";
        NSString * urlPath = [NSString stringWithFormat:@"%@%@",HTTPWeb,url];
        caozuotishiImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -10, kDeviceWidth, kDeviceHeight)];
        caozuotishiImage.userInteractionEnabled = YES;
        [caozuotishiImage sd_setImageWithURL:[NSURL URLWithString:urlPath]];
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageHidden)];
        [caozuotishiImage addGestureRecognizer:imageTap];
        [self.view addSubview:caozuotishiImage];
        [caozuotishiImage bringSubviewToFront:self.view];
    }
}
-(void)imageHidden
{
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"isFirstShangpinxiangqing"];
    [caozuotishiImage removeFromSuperview];
}
#pragma mark 导航栏
-(void)initNavigation
{
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:MLwordFont_2],NSFontAttributeName,nil]];

    self.navigationItem.title = @"商品详情";

}



//特惠商品处理
-(void)goodPropertydeal
{
    if ([_goodtag isEqualToString:@"1"] || [_goodtag isEqualToString:@""]) {
        goodTehui = 0;
    }
    else{
        NSString *cutLabelStr = [_goodtag substringFromIndex:45];
        if ([cutLabelStr isEqualToString:@"tehui.png"]) {
            goodTehui = 1;
        }
        else{
            goodTehui = 0;
        }
    }
    [self loadListData];
}
#pragma mark -- 商品详情数据
-(void)loadListData
{
    NSLog(@"dddd%@",_goodId);

    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithDictionary:@{@"shopid":_goodId}];
    
    [Request getShangPinInfoWithDic:pram success:^(id json) {
        NSLog(@"-- 商品详情%@",json);
        
        NSDictionary *dic = [json valueForKey:@"shpxiangping"];
        [_dataDic removeAllObjects];
        [_dataDic addEntriesFromDictionary:dic];
        
        
        
        seleimgUrl = [NSString stringWithFormat:@"%@",[dic valueForKey:@"canpinpic"]];
        if (dic.count !=0) {
            goodDeailModel *model = [[goodDeailModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [goodDataAry addObject:model];
            [self totlTabelCellCount];
            seleMoney = model.xianjia;
        }
        NSArray *ary = [dic valueForKey:@"guanlianpic"];
        
        if (ary.count>0) {
            for (int i =0; i<ary.count; i++) {
                [dadangAry addObject:@"-1"];
            }
        }
    } failure:^(NSError *error) {
        
    }];

}
#pragma mark -- 计算高度
-(void)totlTabelCellCount
{
    mainHeight = 320*MCscale;
    goodDeailModel *model = goodDataAry[0];
    if (![model.kexuanyanse[0] isEqualToString:@"0"]) {
        mainHeight = mainHeight+40*MCscale;
    }
    if (![model.xinghao[0] isEqualToString:@"0"]) {
        mainHeight = mainHeight+40*MCscale;
    }
    if(![model.guanxishangpin[0] isEqualToString:@"0"])
    {
        mainHeight = mainHeight+118*MCscale;
    }
    if (![model.shangpinjianjie[0] isEqualToString:@"0"]) {
        mainHeight = mainHeight + model.shangpinjianjie.count*200*MCscale;
    }
    [self initSubviews];
    [self createHeaderView];
}

-(void)initSubviews
{
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64*MCscale, kDeviceWidth, kDeviceHeight - 69*MCscale)];
    //滑屏
    mainScrollView.delegate = self;
    //滑动一页
    mainScrollView.backgroundColor = [UIColor clearColor];
    mainScrollView.contentSize = CGSizeMake(kDeviceWidth,mainHeight);
    //偏移量
    mainScrollView.contentOffset = CGPointMake(0, 0);
    //竖直方向不能滑动
    mainScrollView.alwaysBounceVertical = YES;
    //水平方向滑动
    mainScrollView.alwaysBounceHorizontal = NO;
    //滑动指示器
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    //无法超过边界
    mainScrollView.bounces = NO;
    //设置滑动时减速到0所用的时间
    mainScrollView.decelerationRate  = 1;
    [self.view addSubview:mainScrollView];
    
    [self judgeTheFirst];
}

#pragma mark 头视图
-(void)createHeaderView
{
    goodDeailModel *model = goodDataAry[0];
#pragma mark 头视图
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 240*MCscale)];
    //商品图片
    detailImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,kDeviceWidth*2/5.0, kDeviceWidth*2/5.0)];
    detailImage.contentMode = UIViewContentModeScaleAspectFit;
    detailImage.tag = 101;
    detailImage.backgroundColor = [UIColor clearColor];
    [detailImage sd_setImageWithURL:[NSURL URLWithString:model.canpinpic] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"]];
    detailImage.center = CGPointMake(kDeviceWidth/2.0, kDeviceWidth/5.0 +10);
    [headView addSubview:detailImage];
    
    //提示label
    tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,detailImage.center.y +20*MCscale, detailImage.width , 20*MCscale)];
    tishiLabel.alpha = 0.5;
    tishiLabel.font = [UIFont boldSystemFontOfSize:MLwordFont_5];
    tishiLabel.textColor = [UIColor whiteColor];
    tishiLabel.textAlignment = NSTextAlignmentCenter;
    [detailImage addSubview:tishiLabel];
    
    NSString *str = model.shangpinname;
    CGSize size = [str boundingRectWithSize:CGSizeMake(260*MCscale, 20*MCscale) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_6],NSFontAttributeName, nil] context:nil].size;
    //商品名
    UILabel *goodName = [[UILabel alloc]initWithFrame:CGRectMake(30*MCscale, detailImage.bottom+15*MCscale, size.width, 20*MCscale)];
    goodName.text = str;
    goodName.font = [UIFont systemFontOfSize:MLwordFont_6];
    goodName.textColor = [UIColor blackColor];
    goodName.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:goodName];
    
    
    

    //价格
    UILabel *newMoney = [[UILabel alloc]initWithFrame:CGRectZero];
    NSString *wpric = [NSString stringWithFormat:@"¥%.2f",[model.xianjia floatValue]];
    CGSize newPricSize = [wpric boundingRectWithSize:CGSizeMake(100, 30*MCscale) options: NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_11],NSFontAttributeName, nil] context:nil].size;
    newMoney.frame = CGRectMake(33*MCscale, goodName.bottom+2, newPricSize.width, 30*MCscale);
    newMoney.text = wpric;
    newMoney.textAlignment = NSTextAlignmentCenter;
    newMoney.textColor = txtColors(237, 58, 76, 1);
    newMoney.font = [UIFont systemFontOfSize:MLwordFont_11];
    newMoney.backgroundColor = [UIColor clearColor];
    [headView addSubview:newMoney];
    newMoneyLabel = newMoney;
    
    //原价
    TGCenterLineLabel *oldMoney = [[TGCenterLineLabel alloc]initWithFrame:CGRectZero];
    NSString *oldPric = [NSString stringWithFormat:@"原价%.2f",[model.yuanjia floatValue]];
    CGSize oldPricSize = [oldPric boundingRectWithSize:CGSizeMake(100, 20*MCscale) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_9],NSFontAttributeName, nil] context:nil].size;
    oldMoney.frame = CGRectMake(newMoney.right+8*MCscale, newMoney.top+5*MCscale, oldPricSize.width, 20*MCscale);
    oldMoney.text = oldPric;
    oldMoney.textAlignment = NSTextAlignmentCenter;
    oldMoney.textColor = textColors;
    oldMoney.font = [UIFont systemFontOfSize:MLwordFont_9];
    oldMoney.backgroundColor = [UIColor clearColor];
    if([model.yuanjia floatValue] > 0){
        [headView addSubview:oldMoney];
    }
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, headView.bottom-1, kDeviceWidth, 1)];
    line1.backgroundColor = lineColor;
    [headView addSubview:line1];
    
    
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //收藏
    if (!goodTehui) {
        collectBtn.frame = CGRectMake(kDeviceWidth-65*MCscale, detailImage.bottom+10*MCscale, 35*MCscale, 35*MCscale);
        collectBtn.backgroundColor = [UIColor clearColor];
        [collectBtn setBackgroundImage:[UIImage imageNamed:@"商品收藏"] forState:UIControlStateNormal];
//        [collectBtn addTarget:self action:@selector(addCollection:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:collectBtn];
    }
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([def integerForKey:@"isLogin"] != 1) {
        collectBtn.hidden = YES;
    }
    
    NSString *zhuangtai = [NSString stringWithFormat:@"%@",_zhuangtai];
    if (zhuangtai.length > 11) {
        tishiLabel.text = zhuangtai;
        tishiLabel.backgroundColor = [UIColor grayColor];
        collectBtn.hidden = YES;
    }
    else {
        if ([zhuangtai isEqualToString:@"0"]) {
            tishiLabel.text = @"已售完";
            tishiLabel.backgroundColor = [UIColor grayColor];
            collectBtn.hidden = YES;
        }
    }
    [mainScrollView addSubview:headView];
    
#pragma mark 可选
    selectedColorView = [[UIView alloc]initWithFrame:CGRectMake(20*MCscale, line1.bottom, kDeviceWidth - 40*MCscale, 40*MCscale)];
    selectedColorView.backgroundColor = [UIColor clearColor];
    
    UILabel *selectedLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    selectedLabel.frame = CGRectMake(5*MCscale, 10*MCscale, 70, 20*MCscale);
    selectedLabel.text = @"可选:";
    selectedLabel.textAlignment = NSTextAlignmentLeft;
    selectedLabel.textColor = [UIColor blackColor];
    selectedLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    selectedLabel.backgroundColor = [UIColor clearColor];
    [selectedColorView addSubview:selectedLabel];
    colorsArray = [[NSMutableArray alloc]init];
    for (int i=0; i<model.kexuanyansepic.count; i++) {
        UIImageView *selectedColorImage = [[UIImageView alloc]initWithFrame:CGRectZero];;
        selectedColorImage.frame = CGRectMake(selectedLabel.right+4+40*i*MCscale, 1, 38*MCscale, 38*MCscale);
//        [selectedColorImage sd_setImageWithURL:[NSURL URLWithString:model.kexuanyansepic[i]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"]];
        selectedColorImage.backgroundColor = [UIColor clearColor];
        selectedColorImage.layer.borderColor =txtColors(25, 182, 133, 1).CGColor;
        selectedColorImage.layer.masksToBounds = YES;
        selectedColorImage.layer.borderWidth = 0;
        selectedColorImage.userInteractionEnabled = YES;
        selectedColorImage.tag = 1000 +i;
        [selectedColorView addSubview:selectedColorImage];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseColor:)];
        [selectedColorImage addGestureRecognizer:tap];
        [colorsArray addObject:selectedColorImage];
        
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(1, 1, selectedColorImage.width-2, selectedColorImage.height-2)];
        [selectedColorImage addSubview:label];
        label.numberOfLines=0;
        label.font=[UIFont systemFontOfSize:MLwordFont_7];
        label.textColor=textBlackColor;
        label.text=model.kexuanyanse[i];
    }
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0,selectedColorView.height - 1, selectedColorView.width, 1)];
    line2.backgroundColor = lineColor;
    [selectedColorView addSubview:line2];
    
#pragma mark 型号
    UIView *xinghaoView = [[UIView alloc]initWithFrame:CGRectZero];
    xinghaoView.backgroundColor = [UIColor clearColor];
    
    UILabel *selectedXinghao = [[UILabel alloc]initWithFrame:CGRectMake(5*MCscale, 10*MCscale, 40*MCscale, 20*MCscale)];
    selectedXinghao.text = @"型号:";
    selectedXinghao.textAlignment = NSTextAlignmentLeft;
    selectedXinghao.textColor = [UIColor blackColor];
    selectedXinghao.font = [UIFont systemFontOfSize:MLwordFont_5];
    selectedXinghao.backgroundColor = [UIColor clearColor];\
    [xinghaoView addSubview:selectedXinghao];
    
    chooseArray = [[NSMutableArray alloc]init];
    CGFloat lengthX = 0;
    for (int j= 0; j<model.xinghao.count; j++) {
        UIImageView *xinghaoImage = [[UIImageView alloc]initWithFrame:CGRectMake(selectedXinghao.right+10*MCscale+lengthX+22*j*MCscale, 10*MCscale, 22*MCscale, 22*MCscale)];
        xinghaoImage.image= [UIImage imageNamed:@"选择"];
        xinghaoImage.backgroundColor = [UIColor clearColor];
        xinghaoImage.userInteractionEnabled = YES;
        [xinghaoView addSubview:xinghaoImage];
        xinghaoImage.tag = 1010+j;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseSize:)];
        [xinghaoImage addGestureRecognizer:tap];
        [chooseArray addObject:xinghaoImage];
        
        CGSize size = [model.xinghao[j] boundingRectWithSize:CGSizeMake(60*MCscale, 20*MCscale) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_5],NSFontAttributeName, nil] context:nil].size;
        
        UILabel *chooseSize = [[UILabel alloc]initWithFrame:CGRectMake(xinghaoImage.right, 11*MCscale, size.width+5, 20*MCscale)];
        lengthX = lengthX +size.width+5;
        chooseSize.textAlignment = NSTextAlignmentCenter;
        chooseSize.text = model.xinghao[j];
        chooseSize.textColor = textBlackColor;
        chooseSize.font = [UIFont systemFontOfSize:MLwordFont_5];
        chooseSize.backgroundColor = [UIColor clearColor];
        chooseSize.userInteractionEnabled = YES;
        chooseSize.tag = 1020+j;
        [xinghaoView addSubview:chooseSize];
        UITapGestureRecognizer *lbTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseLbSize:)];
        [chooseSize addGestureRecognizer:lbTap];
    }
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectZero];
    line3.backgroundColor = lineColor;
    [xinghaoView addSubview:line3];
    
#pragma mark 购买数量
    UIView *numView = [[UIView alloc]initWithFrame:CGRectZero];
    numView.backgroundColor = [UIColor clearColor];
    
    UILabel *numLabelbuy = [[UILabel alloc]initWithFrame:CGRectMake(5*MCscale, 10*MCscale, 70, 20*MCscale)];
    numLabelbuy.text = @"购买数量:";
    numLabelbuy.backgroundColor = [UIColor clearColor];
    numLabelbuy.textAlignment = NSTextAlignmentLeft;
    numLabelbuy.textColor = [UIColor blackColor];
    numLabelbuy.font = [UIFont systemFontOfSize:MLwordFont_5];
    [numView addSubview:numLabelbuy];
    
    UIImageView *changeNumImage = [[UIImageView alloc]initWithFrame:CGRectMake(50*MCscale, numLabelbuy.bottom+8*MCscale, 110*MCscale, 30*MCscale)];
    changeNumImage.userInteractionEnabled = YES;
    [numView addSubview:changeNumImage];
    
    goodNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(changeNumImage.left+39*MCscale, changeNumImage.top, 37*MCscale, 30*MCscale)];
    goodNumLabel.backgroundColor = [UIColor clearColor];
    goodNumLabel.tintColor = [UIColor blackColor];
    goodNumLabel.textAlignment = NSTextAlignmentCenter;
    goodNumLabel.font = [UIFont systemFontOfSize:MLwordFont_4];
    [numView addSubview:goodNumLabel];
    
    if (numLabelAry.count <1) {
        [numLabelAry addObject:goodNumLabel];
    }
    NSString *str2 = [NSString stringWithFormat:@"%ld",(long)goodCount];
    goodNumLabel.text = str2;
    if(goodTehui){
        changeNumImage.image= [UIImage imageNamed:@"框"];
    }
    else{
        changeNumImage.image= [UIImage imageNamed:@"加减框"];
        
        subtractBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        subtractBtn.frame = CGRectMake(changeNumImage.left, changeNumImage.top, 37*MCscale, 30*MCscale);
        [subtractBtn addTarget:self action:@selector(addOrSbutractAction:) forControlEvents:UIControlEventTouchUpInside];
        subtractBtn.backgroundColor = [UIColor clearColor];
        [numView addSubview:subtractBtn];
        
        
        addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame =  CGRectMake(goodNumLabel.right+2, changeNumImage.top, 37*MCscale, 30*MCscale) ;
        [addBtn addTarget:self action:@selector(addOrSbutractAction:) forControlEvents:UIControlEventTouchUpInside];
        addBtn.backgroundColor = [UIColor clearColor];
        [numView addSubview:addBtn];
        
    }
    addCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addCarBtn.frame = CGRectMake(kDeviceWidth-162*MCscale, changeNumImage.top, 112*MCscale, 30*MCscale);
    addCarBtn.backgroundColor = [UIColor clearColor];
    [numView addSubview:addCarBtn];
    [addCarBtn setBackgroundImage:[UIImage imageNamed:@"加入购物车按钮"] forState:UIControlStateNormal];
    [addCarBtn addTarget:self action:@selector(addCarAction:) forControlEvents:UIControlEventTouchUpInside];

    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectZero];
    line4.backgroundColor = lineColor;
    
    if (zhuangtai.length > 11) {
        numLabelbuy.hidden = YES;
        changeNumImage.hidden = YES;
        goodNumLabel.hidden = YES;
        addCarBtn.hidden = YES;
        line4.hidden = YES;
    }
    else {
        if ([zhuangtai isEqualToString:@"0"]) {
            numLabelbuy.hidden = YES;
            changeNumImage.hidden = YES;
            goodNumLabel.hidden = YES;
            addCarBtn.hidden = YES;
            line4.hidden = YES;
        }
    }
    
#pragma mark 亲密搭档
    UIView *partnerView = [[UIView alloc]initWithFrame:CGRectZero];
    partnerView.backgroundColor = [UIColor clearColor];
    //
    
    UILabel *partnerLabel = [[UILabel alloc]initWithFrame:CGRectMake(5*MCscale, 10*MCscale, 70*MCscale, 20*MCscale)];
    partnerLabel.backgroundColor = [UIColor clearColor];
    partnerLabel.text = @"亲密搭档";
    partnerLabel.textAlignment = NSTextAlignmentLeft;
    partnerLabel.textColor = [UIColor blackColor];
    partnerLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    [partnerView addSubview:partnerLabel];
    
    UILabel *subTitle = [[UILabel alloc]initWithFrame:CGRectMake(partnerLabel.right+5*MCscale, 12*MCscale, 180*MCscale, 15*MCscale)];
    subTitle.text = @"(选中你喜欢的一起放进购物车吧)";
    subTitle.textAlignment = NSTextAlignmentLeft;
    subTitle.textColor = textColors;
    subTitle.backgroundColor = [UIColor clearColor];
    subTitle.font = [UIFont systemFontOfSize:MLwordFont_10];
    [partnerView addSubview:subTitle];
    
    for (int k = 0; k<model.guanlianpic.count; k++) {
        UIImageView *goodImage = [[UIImageView alloc]initWithFrame:CGRectMake(30*MCscale+75*k*MCscale, partnerLabel.bottom+10*MCscale, 70*MCscale, 70*MCscale)];
        goodImage.backgroundColor = [UIColor clearColor];
        goodImage.contentMode = UIViewContentModeScaleAspectFit;
        [goodImage sd_setImageWithURL:[NSURL URLWithString:model.guanlianpic[k]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"]];
        //

        
        goodImage.tag = 1050+k;
        goodImage.userInteractionEnabled = YES;
        [partnerView addSubview:goodImage];
        
        UIImageView *chooseImage = [[UIImageView alloc]initWithFrame:CGRectMake(50*MCscale, 10*MCscale, 17*MCscale, 17*MCscale)];
        chooseImage.backgroundColor = [UIColor clearColor];
        chooseImage.image = [UIImage imageNamed:@"选中"];
        chooseImage.tag = 1060;
        chooseImage.alpha = 0;
        [goodImage addSubview:chooseImage];
        UITapGestureRecognizer *imagTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseLikeGood:)];
        [goodImage addGestureRecognizer:imagTap];
    }
    UIView *line5 =[[UIView alloc]initWithFrame:CGRectZero];
    line5.backgroundColor = lineColor;
    //
#pragma mark frame
    if (![model.kexuanyansepic[0] isEqualToString:@"0"]){//有颜色
        [mainScrollView addSubview:selectedColorView];
        if (![model.xinghao[0] isEqualToString:@"0"]) {//有型号
            [mainScrollView addSubview:xinghaoView];
            xinghaoView.frame = CGRectMake(20*MCscale, selectedColorView.bottom, kDeviceWidth - 40*MCscale, 40*MCscale);
            line3.frame = CGRectMake(0, xinghaoView.height - 1, xinghaoView.width, 1);
            [mainScrollView addSubview:numView];
            numView.frame = CGRectMake(20*MCscale, xinghaoView.bottom, kDeviceWidth - 40*MCscale, 80*MCscale);
            [mainScrollView addSubview:line4];
            if(![model.guanlianpic[0] isEqualToString:@"0"]){//有关联
                line4.frame = CGRectMake(20*MCscale,numView.bottom, kDeviceWidth-40*MCscale, 1);
                [mainScrollView addSubview:partnerView];
                partnerView.frame = CGRectMake(20*MCscale, line4.bottom, kDeviceWidth - 40*MCscale, 118*MCscale);
                [mainScrollView addSubview:line5];
                line5.frame = CGRectMake(0,partnerView.bottom, kDeviceWidth, 1);
                if(![model.shangpinjianjie[0] isEqualToString:@"0"]){
                    for (int k = 0; k<model.shangpinjianjie.count; k++) {
              
                        
                        UIImageView *xiangqingImage = [[UIImageView alloc]initWithFrame: CGRectMake(0,0,kDeviceWidth, 200*MCscale)];
                        xiangqingImage.center = CGPointMake(kDeviceWidth/2.0,200*k*MCscale+line5.bottom+100*MCscale);
                        [xiangqingImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.shangpinjianjie[k]]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"]];
                        xiangqingImage.backgroundColor = [UIColor clearColor];
                        [mainScrollView addSubview:xiangqingImage];
                    }
                }
            }
            else
            {//没有关联
                line4.frame = CGRectMake(0, numView.bottom, kDeviceWidth, 1);
                if(![model.shangpinjianjie[0] isEqualToString:@"0"]){
                    for (int k = 0; k<model.shangpinjianjie.count; k++) {
             
                        
                        UIImageView *xiangqingImage = [[UIImageView alloc]initWithFrame: CGRectMake(0,0,kDeviceWidth, 200*MCscale)];
                        xiangqingImage.center = CGPointMake(kDeviceWidth/2.0,200*k*MCscale+line4.bottom+100*MCscale);
                        [xiangqingImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.shangpinjianjie[k]]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"]];
                        xiangqingImage.backgroundColor = [UIColor clearColor];
                        [mainScrollView addSubview:xiangqingImage];
                    }
                }            }
        }
        else//没有型号
        {
            [mainScrollView addSubview:numView];
            numView.frame = CGRectMake(20*MCscale, selectedColorView.bottom, kDeviceWidth - 40*MCscale, 80*MCscale);
            [mainScrollView addSubview:line4];
            if(![model.guanlianpic[0] isEqualToString:@"0"]){//有关联
                line4.frame = CGRectMake(20*MCscale,numView.bottom, kDeviceWidth-40*MCscale, 1);
                [mainScrollView addSubview:partnerView];
                partnerView.frame = CGRectMake(20*MCscale, line4.bottom, kDeviceWidth - 40*MCscale, 118*MCscale);
                [mainScrollView addSubview:line5];
                line5.frame = CGRectMake(0,partnerView.bottom, kDeviceWidth, 1);
                if(![model.shangpinjianjie[0] isEqualToString:@"0"]){
                    for (int k = 0; k<model.shangpinjianjie.count; k++) {
        
                        
                        UIImageView *xiangqingImage = [[UIImageView alloc]initWithFrame: CGRectMake(0,0,kDeviceWidth, 200*MCscale)];
                        xiangqingImage.center = CGPointMake(kDeviceWidth/2.0,200*k*MCscale+line5.bottom+100*MCscale);
                        [xiangqingImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.shangpinjianjie[k]]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"]];
                        xiangqingImage.backgroundColor = [UIColor clearColor];
                        [mainScrollView addSubview:xiangqingImage];
                    }
                }
            }
            else
            {//没有关联
                line4.frame = CGRectMake(0, numView.bottom, kDeviceWidth, 1);
                if(![model.shangpinjianjie[0] isEqualToString:@"0"]){
                    for (int k = 0; k<model.shangpinjianjie.count; k++) {
                     
                        UIImageView *xiangqingImage = [[UIImageView alloc]initWithFrame: CGRectMake(0,0,kDeviceWidth, 200*MCscale)];
                        xiangqingImage.center = CGPointMake(kDeviceWidth/2.0,200*k*MCscale+line4.bottom+100*MCscale);
                        [xiangqingImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.shangpinjianjie[k]]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"]];
                        xiangqingImage.backgroundColor = [UIColor clearColor];
                        [mainScrollView addSubview:xiangqingImage];
                    }
                }
            }
        }
    }
    else//没有颜色
    {
        if (![model.xinghao[0] isEqualToString:@"0"]) {//有型号
            [mainScrollView addSubview:xinghaoView];
            xinghaoView.frame = CGRectMake(20*MCscale, headView.bottom, kDeviceWidth - 40*MCscale, 40*MCscale);
            line3.frame = CGRectMake(0, xinghaoView.height - 1, xinghaoView.width, 1);
            
            [mainScrollView addSubview:numView];
            numView.frame = CGRectMake(20*MCscale, xinghaoView.bottom, kDeviceWidth - 40*MCscale, 80*MCscale);
            [mainScrollView addSubview:line4];
            if(![model.guanlianpic[0] isEqualToString:@"0"]){//有关联
                line4.frame = CGRectMake(20*MCscale,numView.bottom, kDeviceWidth-40*MCscale, 1);
                [mainScrollView addSubview:partnerView];
                partnerView.frame = CGRectMake(20*MCscale, line4.bottom, kDeviceWidth - 40*MCscale, 118*MCscale);
                [mainScrollView addSubview:line5];
                line5.frame = CGRectMake(0,partnerView.bottom, kDeviceWidth, 1);
                if(![model.shangpinjianjie[0] isEqualToString:@"0"]){
                    for (int k = 0; k<model.shangpinjianjie.count; k++) {

                        
                        UIImageView *xiangqingImage = [[UIImageView alloc]initWithFrame: CGRectMake(0,0,kDeviceWidth, 200*MCscale)];
                        xiangqingImage.center = CGPointMake(kDeviceWidth/2.0,200*k*MCscale+line5.bottom+100*MCscale);
                        [xiangqingImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.shangpinjianjie[k]]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"]];
                        xiangqingImage.backgroundColor = [UIColor clearColor];
                        [mainScrollView addSubview:xiangqingImage];
                    }
                }
            }
            else
            {//没有关联
                line4.frame = CGRectMake(0, numView.bottom, kDeviceWidth, 1);
                if(![model.shangpinjianjie[0] isEqualToString:@"0"]){
                    for (int k = 0; k<model.shangpinjianjie.count; k++) {
     
                        UIImageView *xiangqingImage = [[UIImageView alloc]initWithFrame: CGRectMake(0,0, kDeviceWidth, 200*MCscale)];
                        xiangqingImage.center = CGPointMake(kDeviceWidth/2.0,200*k*MCscale+line4.bottom+100*MCscale);
                        [xiangqingImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.shangpinjianjie[k]]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"]];
                        xiangqingImage.backgroundColor = [UIColor clearColor];
                        [mainScrollView addSubview:xiangqingImage];
                    }
                }
            }
        }
        else//没有型号
        {
            [mainScrollView addSubview:numView];
            numView.frame = CGRectMake(20*MCscale, headView.bottom, kDeviceWidth - 40*MCscale, 80*MCscale);
            
            [mainScrollView addSubview:line4];
            if(![model.guanlianpic[0] isEqualToString:@"0"]){//有关联
                line4.frame = CGRectMake(20*MCscale,numView.bottom, kDeviceWidth-40*MCscale, 1);
                [mainScrollView addSubview:partnerView];
                partnerView.frame = CGRectMake(20*MCscale, line4.bottom, kDeviceWidth - 40*MCscale, 118*MCscale);
                [mainScrollView addSubview:line5];
                line5.frame = CGRectMake(0,partnerView.bottom, kDeviceWidth, 1);
                if(![model.shangpinjianjie[0] isEqualToString:@"0"]){
                    for (int k = 0; k<model.shangpinjianjie.count; k++) {
                  
                        //
                        UIImageView *xiangqingImage = [[UIImageView alloc]initWithFrame: CGRectMake(0,0, kDeviceWidth, 200*MCscale)];
                        xiangqingImage.center = CGPointMake(kDeviceWidth/2.0,200*k*MCscale+line5.bottom+100*MCscale);
                        [xiangqingImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.shangpinjianjie[k]]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"]];
                        xiangqingImage.backgroundColor = [UIColor clearColor];
                        [mainScrollView addSubview:xiangqingImage];
                    }
                }
            }
            else
            {//没有关联
                line4.frame = CGRectMake(0, numView.bottom, kDeviceWidth, 1);
                if(![model.shangpinjianjie[0] isEqualToString:@"0"]){
                    for (int k = 0; k<model.shangpinjianjie.count; k++) {

                        
                        UIImageView *xiangqingImage = [[UIImageView alloc]initWithFrame: CGRectMake(0,0,kDeviceWidth, 200*MCscale)];
                        xiangqingImage.center = CGPointMake(kDeviceWidth/2.0,200*k*MCscale+line4.bottom+100*MCscale);
                        [xiangqingImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.shangpinjianjie[k]]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"]];
                        xiangqingImage.backgroundColor = [UIColor clearColor];
                        [mainScrollView addSubview:xiangqingImage];
                    }
                }
            }
        }
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag == 10001) {
        if (textView.text.length >50) {
            textView.text = [textView.text substringToIndex:50];
        }
    }
}
//选择型号 - 点图片
-(void)chooseSize:(UITapGestureRecognizer *)tap
{
    NSInteger btTag = tap.view.tag;
    goodDeailModel *model = goodDataAry[0];
    if (btTag -1010 != lastChooseSize) {
        UIImageView *newImage= chooseArray[btTag-1010];
        newImage.image = [UIImage imageNamed:@"选中"];
        if(lastChooseSize != -1){
            UIImageView *oldImage = chooseArray[lastChooseSize];
            oldImage.image = [UIImage imageNamed:@"选择"];
        }
    }
    lastChooseSize = btTag-1010;
    xinghao = model.xinghao[btTag - 1010];
}
//选择型号 - 点型号
-(void)chooseLbSize:(UITapGestureRecognizer *)tap
{
    NSInteger btTag = tap.view.tag;
    goodDeailModel *model = goodDataAry[0];
    if (btTag -1020 != lastChooseSize) {
        UIImageView *newImage= chooseArray[btTag-1020];
        if(lastChooseSize != -1){
            UIImageView *oldImage = chooseArray[lastChooseSize];
            oldImage.image = [UIImage imageNamed:@"选择"];
        }
        newImage.image = [UIImage imageNamed:@"选中"];
    }
    lastChooseSize = btTag-1020;
    xinghao = model.xinghao[btTag - 1020];
}
#pragma mark -- 可选按钮
//选中颜色
-(void)chooseColor:(UITapGestureRecognizer *)tap
{
    NSInteger tapTag = tap.view.tag;
    goodDeailModel *model = goodDataAry[0];
    if (tapTag -1000!= lastColor) {
        
        
        UIImageView *newImage = colorsArray[tapTag-1000];
        [detailImage sd_setImageWithURL:[NSURL URLWithString:model.kexuanyansepic[tapTag-1000]] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"]];
        if (lastColor != -1) {
            UIImageView *oldImage = colorsArray[lastColor];
            oldImage.layer.borderWidth = 0;
        }
        newImage.layer.borderWidth = 2.0;
        
        
    }
    lastColor = tapTag-1000;
    yanse =[NSString stringWithFormat:@"%@",model.kexuanyanse[tapTag -1000]];
    seleimgUrl = [NSString stringWithFormat:@"%@",model.kexuanyansepic[tapTag -1000]];
    seleMoney = [NSString stringWithFormat:@"%@",model.kexuanmoney[tapTag -1000]];
    newMoneyLabel.text=[NSString stringWithFormat:@"¥%.2f",[seleMoney floatValue]];
    [newMoneyLabel sizeToFit];
    
    
}

//选择伴侣
-(void)chooseLikeGood:(UITapGestureRecognizer *)tap
{
    UIImageView *image =(UIImageView *)tap.view;
    UIImageView *chooseIm = (UIImageView *)[image viewWithTag:1060];
    goodDeailModel *model = goodDataAry[0];
    if (chooseIm.alpha == 0) {
        chooseIm.alpha =1;
        [dadangAry setObject:model.guanxishangpin[tap.view.tag-1050] atIndexedSubscript:tap.view.tag-1050];
    }
    else{
        chooseIm.alpha = 0;
        [dadangAry setObject:@"-1" atIndexedSubscript:tap.view.tag-1050];
    }
}
//商品数量
-(void)addOrSbutractAction:(UIButton *)btn
{
    if(btn == addBtn){
        goodCount ++;
    }
    else{
        if (goodCount>1) {
            goodCount--;
        }
    }
    NSString *gNum = [NSString stringWithFormat:@"%ld",(long)goodCount];
    goodNumLabel.text = gNum;

}
//加入购物车
-(void)addCarAction:(UIButton *)btn
{
    [self addCarAnimation:btn];
    
    
}
-(void)addCarAnimation:(UIButton *)btn
{
    btn.userInteractionEnabled = NO;
    CGRect rc = [btn.superview convertRect:btn.frame toView:self.view];
    CGPoint stPoint = rc.origin;
    [self addToCardData];
    CGPoint startPoint = CGPointMake(stPoint.x+12, stPoint.y+12);
    CGPoint endpoint = CGPointMake(80, kDeviceHeight-40);
    addCarImageView=[[UIImageView alloc]init];
    addCarImageView.image = [UIImage imageNamed:@"购物车圆点"];
    addCarImageView.contentMode=UIViewContentModeScaleToFill;
    addCarImageView.frame=CGRectMake(0, 0, 10*MCscale, 10*MCscale);
    addCarImageView.hidden=YES;
    anmiatorlayer =[[CALayer alloc]init];
    anmiatorlayer.contents=addCarImageView.layer.contents;
    anmiatorlayer.frame=addCarImageView.frame;
    anmiatorlayer.opacity=1;
    [self.view.layer addSublayer:anmiatorlayer];
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    //贝塞尔曲线中间点
    float sx=startPoint.x;
    float sy=startPoint.y;
    float ex=endpoint.x;
    float ey=endpoint.y;
    float x=sx+(ex-sx)/3;
    float y=sy+(ey-sy)*0.5-400;
    CGPoint centerPoint=CGPointMake(x,y);
    [path addQuadCurveToPoint:endpoint controlPoint:centerPoint];
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration=1;
    animation.delegate=self;
    animation.autoreverses= NO;
    [animation setValue:@"yingmeiji_buy" forKey:@"MyAnimationType_yingmeiji"];
    [anmiatorlayer addAnimation:animation forKey:@"yingmiejibuy"];
    //    [addCarImageView removeFromSuperview];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSString* value = [anim valueForKey:@"MyAnimationType_yingmeiji"];
    if ([value isEqualToString:@"yingmeiji_buy"]){
        [anmiatorlayer removeAnimationForKey:@"yingmiejibuy"];
        [anmiatorlayer removeFromSuperlayer ];
        anmiatorlayer.hidden=YES;
        addCarBtn.userInteractionEnabled = YES;
    }
}
#pragma mark -- 加入购物车
-(void)addToCardData
{
    _loadCurrentGoods=YES;
    
    [Request getGoodsInfoWithDic:@{@"shop.id":_goodId} success:^(id json) {
        if ([[NSString stringWithFormat:@"%@",[json valueForKey:@"message"]] isEqualToString:@"2"]) {
            [self addGoodWithDic:[json objectForKey:@"shop"]];
            _loadCurrentGoods=NO;
            [MBProgressHUD promptWithString:[NSString stringWithFormat:@"添加商品%@成功",_goodId]];
            
            
            
            for (NSString * gooId in dadangAry) {
                if ([gooId isKindOfClass:[NSString class]]) {
                    if (![gooId isEqualToString:@"-1"]) {
                     [self addGooWithId:gooId];
                    }
                    
                    
                   
                }
            }
 
        }else{
            [MBProgressHUD promptWithString:@"获取商品信息失败"];
        }
    } failure:^(NSError *error) {
    }];

}
-(void)addGooWithId:(NSString *)goodsId{
    [Request getGoodsInfoWithDic:@{@"shop.id":goodsId} success:^(id json) {
        if ([[NSString stringWithFormat:@"%@",[json valueForKey:@"message"]] isEqualToString:@"2"]) {
            [self addGoodWithDic:[json objectForKey:@"shop"]];
            [MBProgressHUD promptWithString:[NSString stringWithFormat:@"添加商品%@成功",goodsId]];
        }else{
            [MBProgressHUD promptWithString:@"获取商品信息失败"];
        }
    } failure:^(NSError *error) {
    }];
}
-(void)addGoodWithDic:(NSDictionary *)dic{
    
    
    BOOL hasContain=NO;
    NSInteger  addCount;
    addCount = 1;
    
    if (_loadCurrentGoods) {
        addCount = goodCount;
    }
    
    NSMutableArray * goodsArr = _hasGoodArray;
    
    for (int i = 0; i < goodsArr.count; i ++) {
        NSMutableDictionary * indexDic = [NSMutableDictionary  dictionaryWithDictionary:(_hasGoodArray[i])];
        if ([[NSString stringWithFormat:@"%@",indexDic[@"shopid"]] isEqualToString:[NSString stringWithFormat:@"%@",dic[@"id"]]]) {//如果商品存在
            hasContain=YES;
            
            // 修改 数量
            NSString * count = [indexDic valueForKey:@"shuliang"];
            count = [NSString stringWithFormat:@"%.2f",[count floatValue]+addCount];
            
            
//            [indexDic setValue:count forKey:@"shuliang"];// 商品数量加一
            
            [indexDic setObject:count forKey:@"shuliang"];// 数量加
            
            
            // 修改总价
            NSString * jiage = [indexDic valueForKey:@"xianjia"];
            float  totalMoney = [jiage floatValue]*[count floatValue];
            [indexDic setValue:[NSString stringWithFormat:@"%.2f",totalMoney] forKey:@"total_money"];
            
            [_hasGoodArray replaceObjectAtIndex:i withObject:indexDic];
        };
    }
    if (!hasContain) {
        NSDictionary * currentDic = @{
                                      @"fujiafei_money":[NSString stringWithFormat:@"%@",dic[@"fujiafeiyong_money"]],
                                      @"fujiafeishop":[NSString stringWithFormat:@"%@",dic[@"fujiafeiyong_name"]],
                                      @"jiage":[NSString stringWithFormat:@"%@",dic[@"yuanjia"]],
                                      @"shopid":[NSString stringWithFormat:@"%@",dic[@"id"]],
                                      @"shopimg":[NSString stringWithFormat:@"%@",dic[@"canpinpic"]],
                                      @"shopname":[NSString stringWithFormat:@"%@",dic[@"shangpinname"]],
                                      @"shuliang":[NSString stringWithFormat:@"%ld",(long)addCount],
                                      @"total_money":[NSString stringWithFormat:@"%@",dic[@"xianjia"]],
                                      @"xianjia":[NSString stringWithFormat:@"%@",dic[@"xianjia"]],
                                      @"xinghao":[NSString stringWithFormat:@"%@",dic[@"0"]],
                                      @"yanse":@"0",
                                      };
        [_hasGoodArray addObject:[NSMutableDictionary dictionaryWithDictionary:currentDic]];
    }
    [MBProgressHUD promptWithString:@"商品添加成功"];
    
}

#pragma mark -- UITextFiledDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 1 || textField.tag == 2) {
        if (textField.text.length == 0) {
            return YES;
        }
        NSInteger exitLength = textField.text.length;
        NSInteger selectLength = range.length;
        NSInteger replaceLength = string.length;
        if (exitLength - selectLength +replaceLength>6) {
            return NO;
        }
    }
    return YES;
}
-(void)showTask
{
    sleep(2.5);
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
    sleep(1.5);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
