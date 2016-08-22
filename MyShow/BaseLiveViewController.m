//
//  BaseLiveViewController.m
//  MyShow
//
//  Created by Apple on 16/8/16.
//  Copyright © 2016年 张国森. All rights reserved.
//

#import "BaseLiveViewController.h"
#import "CommendLiveViewController.h"
#import "LiveViewController.h"
#import "WMPageController.h"
@interface BaseLiveViewController ()

@end

@implementation BaseLiveViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self bulidNavigationBarView];
        
  
}
- (void)bulidNavigationBarView
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"head_crown_24x24"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarClick)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search_15x14"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarClick)];
}
- (void)rightBarClick{
    
}
- (void)leftBarClick{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
