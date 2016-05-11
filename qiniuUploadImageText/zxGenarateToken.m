//
//  zxGenarateToken.m
//  qiniuUploadImageText
//
//  Created by 张新 on 16/3/12.
//  Copyright © 2016年 zhangxin. All rights reserved.
//

#import "zxGenarateToken.h"
#import "JSONKit.h"
#import "GTMBase64.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
@implementation zxGenarateToken
- (NSString *)returnQiniuTokenWithAk:(NSString *)AccessKey sk:(NSString *)SecretKey scopeName:(NSString *)sopeName{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    //1. 讲上传策略和token的有效时间转成json
    [dic setObject:sopeName forKey:@"scope"];
    [dic setObject:@1457794380 forKey:@"deadline"];
    NSString *jsonStr=[dic JSONString];
    
    //2.对jsonstr进行Base64编码
    NSString* encoded = nil;
    NSData* originData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* encodeData = [GTMBase64 encodeData:originData];
    encoded = [[NSString alloc] initWithData:encodeData encoding:NSUTF8StringEncoding];
    //
    //3.用SecretKey对编码后的上传策略进行HMAC-SHA1加密，并且做URL安全的Base64编码得到encoded_signed
    NSString *hmas_str=[self hmacSha1:SecretKey text:encoded];
    NSString *encoded_signed=nil;
    NSData *originHmasData=[hmas_str dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encodeHmasData=[GTMBase64 encodeData:originHmasData];
    encoded_signed=[[NSString alloc]initWithData:encodeHmasData encoding:NSUTF8StringEncoding];
    //4. 将 AccessKey、encode_signed 和 encoded 用 “:” 连接起来,得到如下的UploadToken:
    NSString *uploadToken=[NSString stringWithFormat:@"%@:%@:%@",AccessKey,encoded_signed,encoded];
    return uploadToken;
}

//HMAC-SHA1加密
-(NSString *) hmacSha1:(NSString*)key text:(NSString*)text
{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSString *hash;

    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)

        [output appendFormat:@"%02x", cHMAC[i]];

    hash = output;

    return hash;
}
@end
