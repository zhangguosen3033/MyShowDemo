//
//  StartViewController.m
//  MyShow
//
//  Created by Apple on 16/8/18.
//  Copyright © 2016年 张国森. All rights reserved.
//

#import "StartViewController.h"
#import "StartLiveView.h"
@interface StartViewController ()

@end

@implementation StartViewController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
}
-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
      self.view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_zbfx"]];
//
    [self start];

}

-(void)start{
    
    
    StartLiveView *view = [[StartLiveView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];

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
