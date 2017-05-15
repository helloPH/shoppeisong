//
//  BaseCostomer.h
//  哈哈哈
//
//  Created by MIAO on 2017/3/3.
//  Copyright © 2017年 时元尚品. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface BaseCostomer : NSObject

/**
 *  创建标签
 */
+(UILabel *)labelWithFrame:(CGRect)frame font:(UIFont *)textFont textColor:(UIColor *)textColor     backgroundColor:(UIColor *)backColor textAlignment:(NSTextAlignment)textAlignment numOfLines:(NSInteger)numOfLines text:(NSString *)text;

+(UILabel *)labelWithFrame:(CGRect)frame font:(UIFont *)textFont  textColor:(UIColor *)textColor text:(NSString *)text;

/**
 *  创建按钮
 */

+(UIButton *)buttonWithFrame:(CGRect)frame font:(UIFont *)textFont textColor:(UIColor *)textColor backGroundColor:(UIColor *)backColor cornerRadius:(CGFloat)cornerRadius text:(NSString *)text image:(NSString *)imageName;

/**
 *  
 */
+(UIButton *)buttonWithFrame:(CGRect)frame backGroundColor:(UIColor *)backColor  text:(NSString *)text image:(NSString *)imageName;

/**
 *  创建图片
 */
+(UIImageView *)imageViewWithFrame:(CGRect)frame backGroundColor:(UIColor *)backColor cornerRadius:(CGFloat)counerRadius userInteractionEnabled:(BOOL)isEnable image:(NSString *)imageName;

+(UIImageView *)imageViewWithFrame:(CGRect)frame backGroundColor:(UIColor *)backColor image:(NSString *)imageName;

/**
 *  UITextfiled
 */
+(UITextField *)textfieldWithFrame:(CGRect)frame font:(UIFont *)textFont textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment keyboardType:(UIKeyboardType)keyboardType borderStyle:(UITextBorderStyle)borderStyle placeholder:(NSString *)placeholder;

/**
 *  UIView
 */

+(UIView *)viewWithFrame:(CGRect)frame backgroundColor:(UIColor *)backColor;

/**
 *  判断手机号是否正确
 */
+(BOOL)panduanPhoneNumberWithString:(NSString *)phone;

/**
 *  手机号加密
 */

+(NSString *)phoneNumberJiamiWithString:(NSString *)phoneNum;

/**
 *  邮箱加密
 */

+(NSString *)emailNumberjiamiWithString:(NSString *)emailNum;
@end
