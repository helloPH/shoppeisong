//
//  SuperTableViewCell.m
//  ShopPeiSong
//
//  Created by MIAO on 2017/6/19.
//  Copyright © 2017年 妙灵科技. All rights reserved.
//

#import "SuperTableViewCell.h"
#import "Header.h"

@implementation SuperTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self newView];
    }
    return self;
}
-(void)newView{
    
    
    _leftImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_leftImg];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_titleLabel];
    _titleLabel.font=[UIFont systemFontOfSize:MLwordFont_4];
    _titleLabel.textColor=textBlackColor;
    
    _contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _contentLabel.textAlignment=NSTextAlignmentRight;
    [self.contentView addSubview:_contentLabel];
    _contentLabel.font=[UIFont systemFontOfSize:MLwordFont_4];
    _contentLabel.textColor=textBlackColor;
    
    _rightImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_rightImg];
    
    _bottomLine = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_bottomLine];
    _bottomLine.backgroundColor=lineColor;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _leftImg.frame=CGRectMake(15, 0, 20, 20);
    _leftImg.centerY=self.contentView.height/2;
    
    _rightImg.frame=CGRectMake(0, 0, 20, 20);
    _rightImg.right=self.contentView.width-15;
    _rightImg.centerY=self.contentView.height/2;
    
    _titleLabel.frame=CGRectMake(_leftImg.right+5, 0, self.contentView.width*0.3, 20);
    _titleLabel.centerY=self.contentView.height/2;
    

    _contentLabel.frame=CGRectMake(0, 0, self.contentView.width*0.5, 20);
    _contentLabel.right=_rightImg.left-5;
    _contentLabel.centerY=self.contentView.height/2;
    
    _bottomLine.frame=CGRectMake(10, 0, self.contentView.width-20, 0.5);
    _bottomLine.bottom=self.contentView.height;
}
@end
