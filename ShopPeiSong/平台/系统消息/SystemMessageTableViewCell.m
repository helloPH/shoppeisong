//
//  SystemMessageTableViewCell.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/7/18.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "SystemMessageTableViewCell.h"
#import "Masonry.h"
#import "Header.h"
#import "PHButton.h"

@interface SystemMessageTableViewCell()
@property (nonatomic,strong)UIImageView * imgHead;
@property (nonatomic,strong)UILabel     * labelTitle;

@property (nonatomic,strong)UIView      * btnTypeBackView;
@property (nonatomic,strong)PHButton    * btnType;

@property (nonatomic,strong)UILabel     * labelContent;
@property (nonatomic,strong)UIImageView * imgContent;
@property (nonatomic,strong)PHButton    * btnDetail;
@property (nonatomic,strong)UILabel     * labelTime;

@property (nonatomic,strong)PHButton    * btnDelete;
@end
@implementation SystemMessageTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self newView];
    }
    return self;
}
-(void)newView{

    _imgHead = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_imgHead];
    
    _btnTypeBackView = [[UIView alloc]initWithFrame:CGRectZero];
    _btnTypeBackView.layer.cornerRadius=5;
    _btnTypeBackView.layer.borderColor=lineColor.CGColor;
    _btnTypeBackView.layer.borderWidth=1;
    [self.contentView addSubview:_btnTypeBackView];
    
    
    _btnType = [[PHButton alloc]initWithFrame:CGRectZero];
    _btnType.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [_btnType setTitleColor:lineColor forState:UIControlStateNormal];
    [self.contentView addSubview:_btnType];

    _labelTitle = [[UILabel alloc]initWithFrame:CGRectZero];
    _labelTitle.textColor=textBlackColor;
    _labelTitle.numberOfLines =1;
    [self.contentView addSubview:_labelTitle];
 

    _labelContent = [[UILabel alloc]initWithFrame:CGRectZero];
    _labelContent.numberOfLines = 0;
    [self.contentView addSubview:_labelContent];
    _labelContent.textColor=textBlackColor;
    
    
    _imgContent = [[UIImageView alloc]initWithFrame:CGRectZero];
    _imgContent.userInteractionEnabled=YES;
    [self.contentView addSubview:_imgContent];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [_imgContent addGestureRecognizer:tap];
    
    
    _btnDetail = [[PHButton alloc]initWithFrame:CGRectZero];
    [_btnDetail setTitle:@"查看详情" forState:UIControlStateNormal];
    [_btnDetail setImage:[UIImage imageNamed:@"系统消息_链接"] forState:UIControlStateNormal];
    _btnDetail.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [_btnDetail setTitleColor:lineColor forState:UIControlStateNormal];
    [self.contentView addSubview:_btnDetail];
    
    __weak typeof(self) weakSelf = self;
    [_btnDetail addAction:^{
        if (weakSelf.block) {
            weakSelf.block(btnTypeDetail,weakSelf.model);
        }
    }];

    _labelTime = [[UILabel alloc]initWithFrame:CGRectZero];
    _labelTime.textColor = textBlackColor;
    [self.contentView addSubview:_labelTime];


    _btnDelete = [[PHButton alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_btnDelete];
    [_btnDelete addAction:^{
        if (weakSelf.block) {
            weakSelf.block(btnTypeDelete,weakSelf.model);
        }
    }];
    
}
-(void)tap:(UITapGestureRecognizer *)tap{
    if (_block) {
        _block(btnTypeDetail,self.model);
    }
}
-(void)setModel:(SystemMessageModel *)model{
    _model = model;
    NSInteger num =  [model.fenzu integerValue];
    
    NSArray<NSString *> * imgHeadNames = @[@"系统消息_广播",@"系统消息_客服",@"系统消息_运营",@"系统消息_通知"];
    NSString * imgHeadUrl = imgHeadNames[num];

    _imgHead.image=[UIImage imageNamed:imgHeadNames[num]];
    
    _labelTitle.text = model.title;
    
    [_btnType setImage:[UIImage imageNamed:@"系统消息_定位"] forState:UIControlStateNormal];
    [_btnType setTitle:[imgHeadUrl substringFromIndex:[imgHeadUrl rangeOfString:@"系统消息_"].length] forState:UIControlStateNormal];
    
    _labelContent.text = model.content;
    _labelTime.text    = model.date;
    [_btnDelete setImage:[UIImage imageNamed:@"系统消息_删除"] forState:UIControlStateNormal];
    
    _btnDetail.imgDirection = imgRight;

    
    [_imgHead mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    [_btnType mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    
    [_btnTypeBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.btnType.mas_top).offset(-3);
        make.right.mas_equalTo(self.btnType.mas_right).offset(3);
        make.width.mas_equalTo(self.btnType.mas_width).offset(5);
        make.height.mas_equalTo(self.btnType.mas_height).offset(6);
    }];
    
    
    [_labelTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.left.mas_equalTo(_imgHead.mas_right).offset(5);
        make.right.mas_equalTo(_btnType.mas_left).offset(-5);
        make.height.mas_equalTo(20);
        
    }];
    
    [_labelContent mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_labelTitle.mas_bottom).offset(10);
        make.left.mas_equalTo(_labelTitle.mas_left);
        make.right.mas_equalTo(_btnType.mas_right).offset(-10);
    }];
    
    
    [_imgContent mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_labelContent.mas_bottom).offset(5);
        make.left.mas_equalTo(_labelTitle.mas_left);
        make.width.mas_equalTo(_labelTitle.mas_width).offset(-20);
        
        NSString * imgUrl = [NSString stringWithFormat:@"%@",_model.image];
        
        
        _imgContent.hidden=NO;
        if ([imgUrl isEmptyString] || [imgUrl isEqualToString:@"0"]) {
            make.height.mas_equalTo(0.01);
            _imgContent.hidden=YES;
        }else{
            make.height.mas_equalTo(_labelTitle.mas_width).offset(-20);
            [_imgContent sd_setImageWithURL:[NSURL URLWithString:_model.image] placeholderImage:[UIImage imageNamed:@"yonghutouxiang"] options:SDWebImageRefreshCached];
        }
        
    }];

    [_btnDetail mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imgContent.mas_bottom).offset(5);
        make.left.mas_equalTo(_imgContent.mas_left);
        make.width.mas_equalTo(110);
        _btnDetail.hidden=NO;
        if ([_model.url isEmptyString] || [_model.url isEqualToString:@"0"]) {
            make.height.mas_equalTo(0.01);
             _btnDetail.hidden=YES;
        }else{
            make.height.mas_equalTo(20);
        }
    }];
    
    [_labelTime mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_btnDetail.mas_bottom).offset(5);
        make.left.mas_equalTo(_btnDetail.mas_left);
        make.width.mas_equalTo(_labelTitle.mas_width);
        make.height.mas_equalTo(25);
    }];
    
    
    [_btnDelete mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_btnDetail.mas_bottom).offset(5);
        make.right.mas_equalTo(_btnType.mas_right);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(-10);
    }];
}
@end
