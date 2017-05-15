//
//  NSString+Helper.m
//  02.用户登录&注册
//
//  Created by 刘凡 on 13-11-28.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "NSString+Helper.h"
#import <UIKit/UIKit.h>

@implementation NSString (Helper)
-(NSString *)EmptyStringByWhitespace{
    
    return self&&self.length>0?self:@"";
}
#pragma mark - Get请求转换
-(NSString *)getRequestString{
    if ([self isEmptyString])
    {
        return [@"" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
#pragma mark 清空字符串中的空白字符
- (NSString *)trimString
{
    NSString *S=[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [S stringByReplacingOccurrencesOfString:@" " withString:@""];
}
#pragma mark 段前空两格
-(NSString *)emptyBeforeParagraph
{
    NSString *content=[NSString stringWithFormat:@"\t%@",self];
    content=[content stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    return [content stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\t"];
}
#pragma mark 是否空字符串
- (BOOL)isEmptyString
{
    return (!self || self.length <1  || [self isEqualToString:@"(null)"] || [self isEqualToString:@"<null>"]);
}

#pragma mark 返回沙盒中的文件路径
- (NSString *)documentsPath
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [path stringByAppendingString:self];
}

#pragma mark 写入系统偏好
- (void)saveToNSDefaultsWithKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:self forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark 读出系统偏好
+ (NSString *)readToNSDefaultsWithKey:(NSString *)key
{
   return  [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
#pragma mark 邮箱验证 MODIFIED BY HELENSONG
-(BOOL)isValidateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}
#pragma mark  银行账号判断
-(BOOL)isValidateBank
{
    //    NSString *bankNo=@"^\\d{16}|\\d{19}+$";
    //    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",bankNo];
    //    //    NSLog(@"phoneTest is %@",phoneTest);
    //    return [phoneTest evaluateWithObject:self];
    
    int oddsum = 0;     //奇数求和
    
    int evensum = 0;    //偶数求和
    
    int allsum = 0;
    
    int cardNoLength = (int)[self length];
    
    int lastNum = [[self substringFromIndex:cardNoLength-1] intValue];
    
    
    
    NSString * cardn = [self substringToIndex:cardNoLength - 1];
    
    for (int i = cardNoLength -1 ; i>=1;i--) {
        
        NSString *tmpString = [cardn substringWithRange:NSMakeRange(i-1, 1)];
        
        int tmpVal = [tmpString intValue];
        
        if (cardNoLength % 2 ==1 ) {
            
            if((i % 2) == 0){
                
                tmpVal *= 2;
                
                if(tmpVal>=10)
                    
                    tmpVal -= 9;
                
                evensum += tmpVal;
                
            }else{
                
                oddsum += tmpVal;
                
            }
            
        }else{
            
            if((i % 2) == 1){
                
                tmpVal *= 2;
                
                if(tmpVal>=10)
                    
                    tmpVal -= 9;
                
                evensum += tmpVal;
                
            }else{
                
                oddsum += tmpVal;
                
            }
            
        }
        
    }
    
    allsum = oddsum + evensum;
    
    allsum += lastNum;
    
    if((allsum % 10) == 0){
        
        return YES;
    }
    else{
        
        return NO;
    }
    
}
#pragma mark 手机号码验证 MODIFIED BY HELENSONG
-(BOOL) isValidateMobile
{
    if ([self isEmptyString]) {
        return NO;
    }
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((1[3578][0-9])|(14[57])|(17[0678]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    return [phoneTest evaluateWithObject:self];
}
#pragma mark 身份证号
-(BOOL) isValidateIdentityCard
{
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])+$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:self];
}


#pragma mark 车牌号验证 MODIFIED BY HELENSONG
-(BOOL) isValidateCarNo
{
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}+$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:self];
}
#pragma mark 车型号
- (BOOL) isValidateCarType
{
    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];
    return [carTest evaluateWithObject:self];
}
#pragma mark 用户名
- (BOOL) isValidateUserName
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{3,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    return [userNamePredicate evaluateWithObject:self];
}
#pragma mark 密码
-(BOOL) isValidatePassword
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,12}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:self];
}
#pragma mark 昵称
- (BOOL) isValidateNickname
{
    NSString *nicknameRegex = @"^[a-zA-Z0-9\u4e00-\u9fa5]{1,6}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:self];
}
#pragma mark - 判断汉子
-(BOOL)isChinese{
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}
#pragma mark - 字符串转日期
- (NSDate *)dateFromString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *destDate= [dateFormatter dateFromString:self];
    return destDate;
}
#pragma mark - 日期转字符串
- (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

#pragma  mark --  生成富文本
//获得 含有彩色文字的 富文本
- (NSMutableAttributedString *)getColorTextWithStringAndColor:(NSDictionary *)dict{
    
    NSMutableAttributedString * attributeString=[[NSMutableAttributedString alloc]initWithString:self];
    
    int endPoint;
    endPoint=0;
    
    for (NSString * key in dict.allKeys) {
        if (key) {
            if ([[dict valueForKey:key] isKindOfClass:[UIColor class]]) {
                NSRange  range=[self rangeOfString:key];

//                [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:5] range:range];
//                [attributeString addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithInt:10] range:range];
                [attributeString addAttribute:NSForegroundColorAttributeName value:(UIColor *)[dict valueForKey:key] range:range];
  
            }
        }
    }
    return attributeString;
}
/*
 *转化为屏幕上可显示的 有效的 字符串
 */
- (NSString *)getValidWith:(NSString *)place{
    return  [self isEmptyString]?place:self;
}

//添加删除线
-(NSMutableAttributedString *)getDeleteLineTextWithStringS:(NSArray *)stringS{
    NSMutableAttributedString * attributeString=[[NSMutableAttributedString alloc]initWithString:self];
    for (NSString * string in stringS) {
        
        NSRange  range=[self rangeOfString:string];
        
        NSNumber *nuber = [[NSNumber alloc]initWithLong:(NSUnderlinePatternSolid |NSUnderlineStyleSingle)];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName value:nuber range:range];
    }
    return attributeString;
}
//调整 段落距离
-(NSMutableAttributedString *)getLabelParagraphSpaceWithSpace:(CGFloat )space{
    NSMutableAttributedString * attributeString=[[NSMutableAttributedString alloc]initWithString:self];
    NSMutableParagraphStyle * style=[[NSMutableParagraphStyle alloc]init];
    style.paragraphSpacing=space;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, self.length)];
    return attributeString;
}
#pragma mark - 判断是否为金额输入格式
-(BOOL)isValidateMoneying{
    //正在输入的金额必须以数字开头
    
    //没有小数点
    NSString * money1=@"^[0-9]{1}";
    NSPredicate *regextestmoney1=[NSPredicate predicateWithFormat:@"SELF MATCHES %@", money1];
    
    NSString * money11=@"^[1-9][0-9]+$";
    NSPredicate *regextestmoney11=[NSPredicate predicateWithFormat:@"SELF MATCHES %@", money11];
    
    //有小数点
    NSString * money2=@"^[0-9]{1}\\.{0,1}";
    NSPredicate *regextestmoney2=[NSPredicate predicateWithFormat:@"SELF MATCHES %@", money2];
    
    NSString * money21=@"^[0-9]{1}\\.{1}[0-9]{1,2}";
    NSPredicate *regextestmoney21=[NSPredicate predicateWithFormat:@"SELF MATCHES %@", money21];
    
    
    NSString * money3=@"^[1-9]{1}[0-9]+\\.{1}[0-9]{1,2}";
    NSPredicate *regextestmoney3=[NSPredicate predicateWithFormat:@"SELF MATCHES %@", money3];
    
    NSString * money31=@"^[1-9]{1}[0-9]+\\.{0,1}";
    NSPredicate *regextestmoney31=[NSPredicate predicateWithFormat:@"SELF MATCHES %@", money31];
    
    
    if ([self isEmptyString]||[regextestmoney1 evaluateWithObject:self]||[regextestmoney2 evaluateWithObject:self] ||[regextestmoney21 evaluateWithObject:self]||[regextestmoney3 evaluateWithObject:self]||[regextestmoney11 evaluateWithObject:self]||[regextestmoney31 evaluateWithObject:self])
    {
        return YES;
    }else{
        return NO;
    }
    
}
#pragma mark - 判断是否为金额格式
-(BOOL)isValidateMoneyed{
    //正在输入的金额必须以数字开头
    NSString * money=@"^(([0-9]|([1-9][0-9]{0,9}))((\\.[0-9]{1,2})?))$";
    NSPredicate *regextestmoney=[NSPredicate predicateWithFormat:@"SELF MATCHES %@", money];
    return  [regextestmoney evaluateWithObject:self];
    
}

@end
