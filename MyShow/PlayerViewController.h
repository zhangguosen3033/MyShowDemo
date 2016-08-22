//
//  PlayerViewController.h
//  MyShow
//
//  Created by Apple on 16/8/17.
//  Copyright © 2016年 张国森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerViewController : UIViewController

@property(nonatomic,strong)NSString *playurl;

@property(nonatomic,strong)NSString *imageUrl;
/** 直播 */
@property (nonatomic, strong) NSArray *lives;
/** 当前的index */
@property (nonatomic, assign) NSUInteger currentIndex;

@property (nonatomic, weak) UIViewController *parentVc;

@end
