//
//  BaseCostomer.m
//  哈哈哈
//
//  Created by MIAO on 2017/3/3.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import "BaseCostomer.h"

@implementation BaseCostomer

/**
 *  UILabel
 *
 *  @param frame         坐标
 *  @param textFont      字体大小
 *  @param textColor     文字颜色
 *  @param backColor     背景色
 *  @param textAlignment 文字位置
 *  @param numOfLines    行数
 *  @param text          文字
 *
 */
+(UILabel *)labelWithFrame:(CGRect)frame font:(UIFont *)textFont textColor:(UIColor *)textColor backgroundColor:(UIColor *)backColor textAlignment:(NSTextAlignment)textAlignment numOfLines:(NSInteger)numOfLines text:(NSString *)text {
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textColor = textColor;
    label.backgroundColor = backColor;
    label.text = text;
    label.font = textFont;
    label.numberOfLines = numOfLines;
    label.textAlignment = textAlignment;
    
    return label;
}

/**
 *  UILabel
 *
 *  @param frame     坐标
 *  @param textFont  字体大小
 *  @param textColor 字体颜色
 *  @param text      文字
 */
+(UILabel *)labelWithFrame:(CGRect)frame font:(UIFont *)textFont  textColor:(UIColor *)textColor  text:(NSString *)text
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textColor = textColor;
    label.text = text;
    label.font = textFont;
    return label;
}

/**
 *  UIButton
 *
 *  @param frame        坐标
 *  @param textFont     字体大小
 *  @param textColor    字体颜色
 *  @param backColor    背景色
 *  @param cornerRadius 弧度
 *  @param text         文字
 *  @param imageName    图片名
 */
+(UIButton *)buttonWithFrame:(CGRect)frame font:(UIFont *)textFont textColor:(UIColor *)textColor backGroundColor:(UIColor *)backColor cornerRadius:(CGFloat)cornerRadius text:(NSString *)text image:(NSString *)imageName
{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setTitle:text forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.titleLabel.font = textFont;
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button setBackgroundColor:backColor];
    button.layer.cornerRadius = cornerRadius;
    button.layer.masksToBounds = YES;
    
    
    return button;
}

/**
 *  UIButton
 *
 *  @param frame     坐标
 *  @param backColor 背景色
 *  @param text      文字
 *  @param imageName 图片
 */

+(UIButton *)buttonWithFrame:(CGRect)frame backGroundColor:(UIColor *)backColor  text:(NSString *)text image:(NSString *)imageName
{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setTitle:text forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundColor:backColor];
    return button;
}

/**
 *  UIImageView
 *
 *  @param frame        坐标
 *  @param backColor    背景色
 *  @param counerRadius 弧度
 *  @param imageName    图片名
 */
+(UIImageView *)imageViewWithFrame:(CGRect)frame backGroundColor:(UIColor *)backColor cornerRadius:(CGFloat)counerRadius userInteractionEnabled:(BOOL)isEnable image:(NSString *)imageName
{
    UIImageView *image = [[UIImageView alloc]initWithFrame:frame];
    image.backgroundColor = backColor;
    image.layer.cornerRadius = counerRadius;
    image.layer.masksToBounds = YES;
    image.image = [UIImage imageNamed:imageName];
    image.userInteractionEnabled = isEnable;
    return image;
}

+(UIImageView *)imageViewWithFrame:(CGRect)frame backGroundColor:(UIColor *)backColor image:(NSString *)imageName
{
    UIImageView *image = [[UIImageView alloc]initWithFrame:frame];
    image.backgroundColor = backColor;
    image.image = [UIImage imageNamed:imageName];
    return image;
}

/**
 *  UITextfield
 *
 *  @param frame         坐标
 *  @param textFont      字体大小
 *  @param textColor     字体颜色
 *  @param textAlignment 位置
 *  @param keyboardType  键盘类型
 *  @param borderStyle  边框类型
 *  @param placeholder   默认字
 */
+(UITextField *)textfieldWithFrame:(CGRect)frame font:(UIFont *)textFont textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment keyboardType:(UIKeyboardType)keyboardType borderStyle:(UITextBorderStyle)borderStyle placeholder:(NSString *)placeholder
{
    UITextField *textfield = [[UITextField alloc]initWithFrame:frame];
    textfield.textColor = textColor;
    textfield.placeholder = placeholder;
    textfield.font = textFont;
    textfield.textAlignment = textAlignment;
    textfield.keyboardType = keyboardType;
    textfield.borderStyle = borderStyle;
    return textfield;
}

/**
 *  UIView
 *
 *  @param frame     坐标
 *  @param backColor 背景色
 *
 */
+(UIView *)viewWithFrame:(CGRect)frame backgroundColor:(UIColor *)backColor
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = backColor;
    return view;
}

/**
 *  判断手机号是否正确
 *
 */
+(BOOL)panduanPhoneNumberWithString:(NSString *)phone
{
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(14[7,5])|(17[0,3,6,7,8]))\\d{8}$";    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

/**
 *  手机号加密
 */

+(NSString *)phoneNumberJiamiWithString:(NSString *)phoneNum
{
    return  [phoneNum stringByReplacingCharactersInRange:NSMakeRange(3,6) withString:@"*****"];
}

/**
 *  邮箱加密
 */
+(NSString *)emailNumberjiamiWithString:(NSString *)emailNum
{
    NSRange range = [emailNum rangeOfString:@"@"];
    NSInteger lenth = range.location;
    return [emailNum stringByReplacingCharactersInRange:NSMakeRange(3, lenth-3) withString:@"*****"];
}
@end
