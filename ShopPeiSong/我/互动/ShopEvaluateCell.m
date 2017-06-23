//
//  ShopEvaluateCell.m
//  GoodShop
//
//  Created by MIAO on 2016/12/2.
//  Copyright © 2016年 时元尚品. All rights reserved.
//

#import "ShopEvaluateCell.h"
#import "ShopEvaluateModel.h"
#import "RatingView.h"
#import "Header.h"
@implementation ShopEvaluateCell
{
    UIImageView *iconImageView;
    UILabel *telLabel;
    UILabel *timeLabel;
    RatingView *rating;
    UILabel *leimuLabel;
    UILabel *contentLabel;
    UILabel *guanjiaLabel;
    UIImageView *zanImageView;
    UILabel *shangpinLabel;
    UIView *lineView;
    UIView *hearderView;
    
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    iconImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    iconImageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:iconImageView];
    
    telLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    telLabel.textAlignment = NSTextAlignmentLeft;
    telLabel.textColor = textColors;
    telLabel.backgroundColor = [UIColor clearColor];
    telLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
    [self.contentView addSubview:telLabel];
    
    timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.textColor = textColors;
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.font = [UIFont systemFontOfSize:MLwordFont_7];
    [self.contentView addSubview:timeLabel];
    
    //星星
    rating = [[RatingView alloc]initWithFrame:CGRectZero];
    rating.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:rating];
    
    
    leimuLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    leimuLabel.textAlignment = NSTextAlignmentCenter;
    leimuLabel.textColor = textColors;
    leimuLabel.backgroundColor = [UIColor clearColor];
    leimuLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    [self.contentView addSubview:leimuLabel];
    
    contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.textColor = textColors;
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    
    guanjiaLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    guanjiaLabel.textAlignment = NSTextAlignmentLeft;
    guanjiaLabel.textColor = redTextColor;
    guanjiaLabel.backgroundColor = [UIColor clearColor];
    guanjiaLabel.numberOfLines = 0;
    guanjiaLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    
    zanImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    zanImageView.backgroundColor = [UIColor clearColor];
    zanImageView.image = [UIImage imageNamed:@"dabuzhi"];
    [self.contentView addSubview:zanImageView];
    
    shangpinLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    shangpinLabel.textAlignment = NSTextAlignmentLeft;
    shangpinLabel.textColor = textColors;
    shangpinLabel.backgroundColor = [UIColor clearColor];
    shangpinLabel.numberOfLines = 1;
    shangpinLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    [self.contentView addSubview:shangpinLabel];
    
    lineView = [[UIView alloc]initWithFrame:CGRectZero];
    lineView.backgroundColor = lineColor;
    [self.contentView addSubview:lineView];
    
    hearderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40*MCscale)];
    hearderView.backgroundColor = txtColors(233, 234, 235, 1);
    //    hearderView.tag = section + 100;
    
    _selectImage = [[UIImageView alloc]initWithFrame:CGRectMake(20*MCscale, 10*MCscale, 20*MCscale, 20*MCscale)];
    _selectImage.image = [UIImage imageNamed:@"选中"];
    _selectImage.backgroundColor = [UIColor clearColor];
    _selectImage.tag = 11;
    _selectImage.userInteractionEnabled = YES;
    [hearderView addSubview:_selectImage];
    
    UILabel *subLabel = [[UILabel alloc]initWithFrame:CGRectMake(_selectImage.right+5*MCscale, 10*MCscale, 150*MCscale, 20*MCscale)];
    subLabel.textColor = textBlackColor;
    subLabel.textAlignment = NSTextAlignmentLeft;
    subLabel.font = [UIFont systemFontOfSize:MLwordFont_5];
    subLabel.text = @"只显示有内容的评价";
    [hearderView addSubview:subLabel];
}

-(void)reloadDataWithIndexPath:(NSIndexPath *)indexpath AndArray:(NSArray *)array
{
    if (indexpath.row == 0) {
        [self.contentView addSubview:hearderView];
    }
    else
    {
        iconImageView.frame  = CGRectMake(10*MCscale, 10*MCscale,60*MCscale, 60*MCscale);
        iconImageView.layer.cornerRadius = 30*MCscale;
        iconImageView.layer.masksToBounds = YES;
        telLabel.frame = CGRectMake(iconImageView.right +10*MCscale, 10*MCscale, 100*MCscale, 15*MCscale);
        rating.frame = CGRectMake(iconImageView.right +10*MCscale, telLabel.bottom +5*MCscale, 100*MCscale, 20*MCscale);
        zanImageView.frame = CGRectMake(iconImageView.right +5*MCscale,rating.bottom +5*MCscale, 20*MCscale,20*MCscale);
        
        
        ShopEvaluateModel *model = array[indexpath.row-1];
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"]];
        telLabel.text = [model.tel stringByReplacingCharactersInRange:NSMakeRange(3, 6) withString:@"*****"];
        timeLabel.text = model.time;
        leimuLabel.text = model.pingjia;
        shangpinLabel.text = model.shangping;
        rating.ratingScore = [model.pingfeng floatValue]*MCscale;
        
        contentLabel.frame = CGRectMake(10*MCscale, 80*MCscale, 0.1 , 0.1);
        if (![model.neirong isEqualToString:@"0"]) {
            NSString *content =[NSString stringWithFormat:@"%@",model.neirong];
            CGSize size = [content boundingRectWithSize:CGSizeMake(360*MCscale,1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_5],NSFontAttributeName, nil] context:nil].size;
            contentLabel.frame = CGRectMake(10*MCscale, 80*MCscale, size.width, size.height);
            contentLabel.text = content;
        }
        [self.contentView addSubview:contentLabel];
        
        if (![model.guanjia isEqualToString:@"0"]) {
            NSString *huifu =[NSString stringWithFormat:@"商家回复: %@",model.guanjia];
            CGSize huifuSize = [huifu boundingRectWithSize:CGSizeMake(360*MCscale,1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:MLwordFont_5],NSFontAttributeName, nil] context:nil].size;
            guanjiaLabel.frame = CGRectMake(10*MCscale,contentLabel.bottom + 5*MCscale, huifuSize.width, huifuSize.height);
            guanjiaLabel.text = huifu;
            [self.contentView addSubview:guanjiaLabel];
        }
        
    }
    
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    lineView.frame = CGRectMake(10*MCscale, self.height - 1, self.width - 20*MCscale, 1);
    timeLabel.frame = CGRectMake(self.width-150*MCscale, 10*MCscale, 140*MCscale, 15*MCscale);
    shangpinLabel.frame = CGRectMake(zanImageView.right +5*MCscale, rating.bottom +8*MCscale, self.width-110*MCscale, 15*MCscale);
    leimuLabel.frame = CGRectMake(self.width - 70*MCscale, timeLabel.bottom +5*MCscale, 60*MCscale, 20*MCscale);
}


-(void)prepareForReuse
{
    [super prepareForReuse];
    iconImageView.image = nil;
    telLabel.text = nil;
    timeLabel.text = nil;
    rating.ratingScore = 0;
    contentLabel.text = nil;
    guanjiaLabel.text = nil;
    shangpinLabel.text = nil;
    leimuLabel.text = nil;
}
@end
