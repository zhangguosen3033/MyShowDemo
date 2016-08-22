//
//  MBProgressHUD+GSProgressHUD.h
//  MyShow
//
//  Created by Apple on 16/8/17.
//  Copyright © 2016年 张国森. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (GSProgressHUD)
+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;


@end
