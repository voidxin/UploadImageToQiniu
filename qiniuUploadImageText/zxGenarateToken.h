//
//  zxGenarateToken.h
//  qiniuUploadImageText
//
//  Created by 张新 on 16/3/12.
//  Copyright © 2016年 zhangxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface zxGenarateToken : NSObject

/*
 AccessKey
 SecretKey
 sopeName  空间名
 */
-(NSString *)returnQiniuTokenWithAk:(NSString *)AccessKey   sk:(NSString *)SecretKey scopeName:(NSString *)sopeName;
@end
