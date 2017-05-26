//
//  OrdersCell.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/7.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "OrdersCell.h"
#import "OrdersModel.h"
#import "Header.h"
@interface OrdersCell()

@property(nonatomic,strong)UILabel *timeLabel,*danhaoLabel,*nameLabel,*addressLabel;
@property(nonatomic,strong)UIView *line1,*line2,*lingView,*stateBackView;
@property(nonatomic,strong)UIImageView *headImageView,*biaozhiImage;
@property(nonatomic,strong)NSArray *dianpuLeixingArray,*imageArray;
@property(nonatomic,strong)NSString *danhaoStr,*caigouchengben;
@property(nonatomic,assign)NSInteger buttonIndex,zhifufangshi;

@end
@implementation OrdersCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
-(UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_7] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft numOfLines:1 text:@""];
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

-(UIButton *)shouhuoBtn
{
    if (!_shouhuoBtn) {
        _shouhuoBtn = [BaseCostomer buttonWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:redTextColor backGroundColor:[UIColor whiteColor] cornerRadius:12*MCscale text:@"" image:@""];
        _shouhuoBtn.layer.borderColor = redTextColor.CGColor;
        _shouhuoBtn.layer.borderWidth = 1.5;
        [_shouhuoBtn addTarget:self action:@selector(shouhuoBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_shouhuoBtn];
    }
    return _shouhuoBtn;
}

-(UIView *)line1
{
    if (!_line1) {
        _line1 = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
        [self.contentView addSubview:_line1];
    }
    return _line1;
}

-(UIImageView *)biaozhiImage
{
    if (!_biaozhiImage) {
        _biaozhiImage = [BaseCostomer imageViewWithFrame:CGRectMake(45*MCscale,10*MCscale,20*MCscale,20*MCscale) backGroundColor:[UIColor clearColor] image:@"ziyin"];
    }
    return  _biaozhiImage;
}

-(UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [BaseCostomer imageViewWithFrame:CGRectZero backGroundColor:[UIColor clearColor] cornerRadius:35*MCscale userInteractionEnabled:NO image:@"yonghutouxiang"];
        [self.contentView addSubview:_headImageView];
        [_headImageView addSubview:self.biaozhiImage];
    }
    return _headImageView;
}

-(UILabel *)danhaoLabel
{
    if (!_danhaoLabel) {
        _danhaoLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_7] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft numOfLines:1 text:@""];
        [self.contentView addSubview:_danhaoLabel];
    }
    return _danhaoLabel;
}

-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_7] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft numOfLines:1 text:@""];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}
-(UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_7] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft numOfLines:1 text:@""];
        [self.contentView addSubview:_addressLabel];
    }
    return _addressLabel;
}


-(UIView *)line2
{
    if (!_line2) {
        _line2 = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
        [self.contentView addSubview:_line2];
    }
    return _line2;
}

-(NSArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = @[@"xindindanicons",@"chulizhonggreenicons",@"peisongzhonggreenicons",@"yisongdagreenicons"];
    }
    return _imageArray;
}
-(NSString *)danhaoStr
{
    if (!_danhaoStr) {
        _danhaoStr = @"";
    }
    return _danhaoStr;
}
-(NSString *)caigouchengben
{
    if (!_caigouchengben) {
        _caigouchengben = @"";
    }
    return _caigouchengben;
}
-(NSInteger)buttonIndex
{
    if (!_buttonIndex) {
        _buttonIndex = 0;
    }
    return _buttonIndex;
}
-(NSInteger)zhifufangshi
{
    if (!_zhifufangshi) {
        _zhifufangshi = 0;
    }
    return _zhifufangshi;
}
-(UIView *)stateBackView
{
    if (!_stateBackView) {
        _stateBackView = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_stateBackView];
        
        NSArray *stateLabel = @[@"接单",@"交货",@"收货",@"送达"];
        for (int i = 0; i<4; i++) {
            UIImageView *imageView = [BaseCostomer imageViewWithFrame:CGRectMake(80*MCscale*i +40*MCscale,5*MCscale,25*MCscale,25*MCscale) backGroundColor:[UIColor clearColor] image:self.imageArray[i]];
            imageView.tag = 100+i;
            [_stateBackView addSubview:imageView];
            
            UILabel *label = [BaseCostomer labelWithFrame:CGRectMake(imageView.left, imageView.bottom +2*MCscale, imageView.width, 15*MCscale) font:[UIFont systemFontOfSize:MLwordFont_9] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter numOfLines:1 text:stateLabel[i]];
            [_stateBackView addSubview:label];
            
            if (i<3) {
                UIView *line = [BaseCostomer viewWithFrame:CGRectMake(imageView.right +5*MCscale,25*MCscale, 45*MCscale, 1*MCscale) backgroundColor:lineColor];
                [_stateBackView addSubview:line];
                
                UILabel *time = [BaseCostomer labelWithFrame:CGRectMake(line.left, 10*MCscale, line.width, 15*MCscale) font:[UIFont systemFontOfSize:MLwordFont_9] textColor:textColors backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter numOfLines:1 text:@""];
                time.tag = 200+i;
                [_stateBackView addSubview:time];
            }
        }
    }
    return _stateBackView;
}

-(UIView *)lingView
{
    if (!_lingView) {
        _lingView = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
        [self.contentView addSubview:_lingView];
    }
    return _lingView;
}
-(NSArray *)dianpuLeixingArray
{
    if (!_dianpuLeixingArray) {
        _dianpuLeixingArray = @[@"ziyin",@"ruzhu",@"weituo"];
    }
    return _dianpuLeixingArray;
}
-(void)reloadDataWithIndexpath:(NSIndexPath *)indexpath AndArray:(NSArray *)array
{
    OrdersModel *model = array[indexpath.row];
    
    //    self.biaozhiImage.image = [UIImage imageNamed:self.dianpuLeixingArray[[model.dianpuleixing integerValue] - 1]];
    NSString *imageUrl;
    if (user_dianpulogo) {
        imageUrl = user_dianpulogo;
    }
    else
    {
        imageUrl = model.dianpulogo;
    }
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"] options:SDWebImageRefreshCached];
    self.timeLabel.text = model.date;
    self.danhaoLabel.text = [NSString stringWithFormat:@"单号:%@",model.danhao];
    self.nameLabel.text = [NSString stringWithFormat:@"商户:%@",model.shanghu];
    self.addressLabel.text = [NSString stringWithFormat:@"地点:%@",model.address];
    
    UILabel *jiedantime = [self.stateBackView viewWithTag:200];
    UILabel *shouhuoTime = [self.stateBackView viewWithTag:201];
    UILabel *jiaohuoTime = [self.stateBackView viewWithTag:202];
    jiedantime.text = [NSString stringWithFormat:@"%@",model.jiedandate];
    
    NSLog(@"sssss%@,%@,%@",model.jiedandate,model.shouhuodate,model.jiaohuodate);
    NSLog(@"sssss%ld,%ld,%ld",[model.jiedandate integerValue],[model.shouhuodate integerValue],[model.jiaohuodate integerValue]);
    
    if ([model.shouhuodate integerValue] == 0&&[model.jiaohuodate integerValue] == 0) {
        _imageArray = @[@"xindindanicons",@"chulizhonggreenicons",@"peisongzhonggreenicons",@"yisongdagreenicons"];
    }
    else
    {
        shouhuoTime.text = [NSString stringWithFormat:@"%@",model.shouhuodate];
        jiaohuoTime.text = [NSString stringWithFormat:@"%@",model.jiaohuodate];
                self.imageArray = @[@"xindindanicons",@"chulizhongredicons",@"peisongzongicons",@"yisongdagreenicons"];
    }
    for (int i=0; i<4; i++) {
        UIImageView *image = [self.stateBackView viewWithTag:100+i];
        image.image = [UIImage imageNamed:self.imageArray[i]];
    }
    
    if ([model.button integerValue] == 4)
    {
        [self.shouhuoBtn setTitle:@"收货" forState:UIControlStateNormal];
    }
    else if ([model.button integerValue] == 6)
    {
        [self.shouhuoBtn setTitle:@"确认送达" forState:UIControlStateNormal];
    }
    self.danhaoStr = model.danhao;
    self.caigouchengben = model.caigouchengben;
    NSLog(@"%@",model.button);
    self.buttonIndex = [model.button integerValue];
    self.zhifufangshi = [model.zhifufangshi integerValue];
}
#pragma mark 收货按钮点击事件
-(void)shouhuoBtnClick
{
    if ([self.orderDelegate respondsToSelector:@selector(shouhuoSuccessWithDanhao:AndCaigouchengbenStr:AndZhidufangshiIndex:Index:)]) {
        [self.orderDelegate shouhuoSuccessWithDanhao:self.danhaoStr AndCaigouchengbenStr:self.caigouchengben AndZhidufangshiIndex:self.zhifufangshi Index:self.buttonIndex];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10*MCscale);
        make.left.equalTo(self).offset(15*MCscale);
        make.width.equalTo(@(150*MCscale));
        make.height.equalTo(@(20*MCscale));
    }];
    [self.shouhuoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8*MCscale);
        make.right.equalTo(self.mas_right).offset(-10*MCscale);
        make.width.equalTo(@(100*MCscale));
        make.height.equalTo(@(25*MCscale));
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(10*MCscale);
        make.left.equalTo(self).offset(15*MCscale);
        make.right.equalTo(self).offset(-15*MCscale);
        make.height.equalTo(@(1*MCscale));
    }];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line1.mas_bottom).offset(5*MCscale);
        make.left.equalTo(self).offset(15*MCscale);
        make.width.height.equalTo(@(70*MCscale));
    }];
    
    [self.danhaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_top);
        make.left.equalTo(self.headImageView.mas_right).offset(5*MCscale);
        make.width.equalTo(@(self.width - 100*MCscale));
        make.height.equalTo(@(20*MCscale));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.danhaoLabel.mas_bottom).offset(5*MCscale);
        make.left.equalTo(self.danhaoLabel.mas_left);
        make.width.equalTo(self.danhaoLabel.mas_width);
        make.height.equalTo(self.danhaoLabel.mas_height);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5*MCscale);
        make.left.equalTo(self.nameLabel.mas_left);
        make.width.equalTo(self.nameLabel.mas_width);
        make.height.equalTo(self.nameLabel.mas_height);
    }];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_bottom).offset(5*MCscale);
        make.left.equalTo(self).offset(15*MCscale);
        make.right.equalTo(self).offset(-15*MCscale);
        make.height.equalTo(@(1*MCscale));
    }];
    
    [self.stateBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line2.mas_bottom).offset(2*MCscale);
        make.left.equalTo(self).offset(15*MCscale);
        make.right.equalTo(self).offset(-15*MCscale);
        make.height.equalTo(@(50*MCscale));
    }];
    [self.lingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(-5*MCscale);
        make.left.equalTo(self).offset(0*MCscale);
        make.right.equalTo(self).offset(0*MCscale);
        make.height.equalTo(@(5*MCscale));
    }];
}
@end
