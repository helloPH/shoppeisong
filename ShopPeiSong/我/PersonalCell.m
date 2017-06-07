//
//  PersonalCell.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/3/7.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "PersonalCell.h"
#import "Header.h"
@interface PersonalCell()
@property (nonatomic,strong)UIImageView *headImage,*rightImageView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UIView *lingView;
@property (nonatomic,strong)NSArray *imageArray,*nameArray;
@property (nonatomic,strong)UILabel * rightLabel;

//@property (nonatomic,strong)NSArray *status;
@end
@implementation PersonalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(UIImageView *)headImage
{
    if (!_headImage) {
        _headImage = [BaseCostomer imageViewWithFrame:CGRectZero backGroundColor:[UIColor clearColor] image:@""];
        [self.contentView addSubview:_headImage];
    }
    return _headImage;
}

-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:textColors text:@""];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}
-(UIImageView *)rightImageView
{
    if (!_rightImageView) {
        _rightImageView = [BaseCostomer imageViewWithFrame:CGRectZero backGroundColor:[UIColor clearColor] image:@"xialas"];
        [self.contentView addSubview:_rightImageView];
    }
    return _rightImageView;
}
-(UIView *)lingView
{
    if (!_lingView) {
        _lingView = [BaseCostomer viewWithFrame:CGRectZero backgroundColor:lineColor];
        [self.contentView addSubview:_lingView];
    }
    return _lingView;
}
-(UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [BaseCostomer labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:MLwordFont_4] textColor:[UIColor redColor] text:@""];
        [self.contentView addSubview:_rightLabel];
        
    }
    return _rightLabel;
    
}
-(NSArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = @[@"fenhong",@"updatepwd",@"spglicon",@"yijianfankui",@"helpicon",@"fenxiangtu"];
    }
    return _imageArray;
}
-(NSArray *)nameArray
{
    if (!_nameArray) {

            _nameArray = @[@"升级增强版",@"安全设置",@"商品管理",@"作业签到",@"我的客服",@"分享朋友"];
        
    }
    return _nameArray;
}
-(void)setDic:(NSDictionary *)dic{
    _dic=dic;
    
    self.rightLabel.text=[NSString stringWithFormat:@"%@",[self.dic valueForKey:@"clockstatus"]];
    if ([self.rightLabel.text integerValue]%2==0) {
        set_IsZaiGang(NO);
    }else{
        set_IsZaiGang(YES);
    }
    
    
        switch ([self.rightLabel.text integerValue]) {
            case 0:
                self.rightLabel.text=@"签到";
                break;
            case 1:
                self.rightLabel.text=@"第一时段 签到";
                break;
            case 2:
                self.rightLabel.text=@"第一时段 离岗";
                break;
            case 3:
                self.rightLabel.text=@"第二时段 签到";
                break;
            case 4:
                self.rightLabel.text=@"第二时段 离岗";
                break;
            case 5:
                self.rightLabel.text=@"第三时段 签到";
                break;
            case 6:
                self.rightLabel.text=@"第三时段 离岗";
                break;
            case 7:
                self.rightLabel.text=@"第四时段 签到";
                break;
            case 8:
                self.rightLabel.text=@"第四时段 离岗";
                break;
                
            default:
                break;
        }
    
    
}
-(void)reloadDataWithIndexpath:(NSIndexPath *)indexpath
{
    self.nameLabel.text = self.nameArray[indexpath.row];
    self.headImage.image = [UIImage imageNamed:self.imageArray[indexpath.row]];
    if (indexpath.row==3) {
        self.rightLabel.hidden=NO;
    }else{
        self.rightLabel.hidden=YES;
    }
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.headImage.frame = CGRectMake(0, 0,20*MCscale,20*MCscale);
    self.headImage.center = CGPointMake(20*MCscale, self.height/2.0);
    self.nameLabel.frame = CGRectMake(self.headImage.right +5*MCscale, self.height/2.0-10*MCscale,150*MCscale, 20*MCscale);
    self.rightImageView.frame = CGRectMake(self.width - 25*MCscale, self.height/2.0-10*MCscale, 15*MCscale, 20*MCscale);
    self.lingView.frame = CGRectMake(0, self.height - 1,kDeviceWidth, 1);

  
    
    
    
    [self.rightLabel sizeToFit];
    self.rightLabel.center=self.contentView.center;
    self.rightLabel.right=self.rightImageView.left-5;

    
}
@end
