//
//  ViewController.m
//  qiniuUploadImageText
//
//  Created by 张新 on 16/3/12.
//  Copyright © 2016年 zhangxin. All rights reserved.
//

#import "ViewController.h"
#import <QiniuSDK.h>
#import "zxGenarateToken.h"
#define AK @"EJyvPPQiFEBvdmQsmAZhIiRyn7iNp7d_rCm4fh__"
#define SK @"2leWBxSvMsFWdoO0bv4GZxTID6K0aik2M0rzOKtM"
#define KscopeName @"qiniutext"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *confirm_btn=[UIButton buttonWithType:UIButtonTypeSystem];
    [confirm_btn setTitle:@"上传" forState:UIControlStateNormal];
    confirm_btn.layer.borderWidth=1;
    confirm_btn.layer.borderColor=[UIColor redColor].CGColor;
    confirm_btn.layer.cornerRadius=4;
    [confirm_btn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    confirm_btn.frame=CGRectMake(0, 0, 100, 50);
    confirm_btn.center=CGPointMake([UIScreen mainScreen].bounds.size.width*0.5, [UIScreen mainScreen].bounds.size.height*0.5);
    [self.view addSubview:confirm_btn];
}
-(void)confirmAction{
    
    
    zxGenarateToken *genetoken=[[zxGenarateToken alloc]init];
   NSString *token= [genetoken returnQiniuTokenWithAk:AK sk:SK scopeName:KscopeName];
    NSLog(@"token:%@",token);
    
//        NSString *token=@"EJyvPPQiFEBvdmQsmAZhIiRyn7iNp7d_rCm4fh__:NDAgfOENeObsFUNXGeTV1mpuBGM=:eyJzY29wZSI6InFpbml1dGV4dCIsImRlYWRsaW5lIjoxNDU3OTI0MTMxfQ==";
    QNUploadManager  *upManager=[[QNUploadManager alloc]init];
    UIImage *image=[UIImage imageNamed:@"weixinErweima_03"];
    NSArray *imageArr=@[image,image,image,image,image,image,image,image,image,image];
    NSMutableArray *dataArray=[[NSMutableArray alloc]init];
    for (UIImage *image1 in imageArr) {
         NSData *data=UIImagePNGRepresentation(image1);
        [dataArray addObject:data];
        
    }
    NSMutableArray *urlArry=[[NSMutableArray alloc]init];
    NSInteger i=90;
    for (NSData *data in dataArray) {
        i++;
        [upManager putData:data key:[NSString stringWithFormat:@"zxin%ld",i] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            NSLog(@"info %@",info);
            NSLog(@"resp %@",resp);
            if (resp!=nil) {
                [urlArry addObject:[resp objectForKey:@"key"]];
            }
        } option:nil];
    }
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
