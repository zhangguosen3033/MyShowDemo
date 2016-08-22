//
//  PushStremViewController.m
//  MyShow
//
//  Created by Apple on 16/8/16.
//  Copyright © 2016年 张国森. All rights reserved.
//

#import "PushStremViewController.h"
#import "StartViewController.h"
@interface PushStremViewController ()

@property(nonatomic,strong)UITextField *nametext;
@end

@implementation PushStremViewController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden =YES;
}
-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    self.navigationController.navigationBar.hidden =NO;

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_zbfx"]];
    
    [self Setname];
    // Do any additional setup after loading the view.
}

-(void)Setname{
    
    self.nametext =[[UITextField alloc]init];
    
    self.nametext.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"global_background"]];
    
    self.nametext.text= @"设置房间名";
    
    self.nametext.textColor =[UIColor whiteColor];
    
    [self.view addSubview:self.nametext];
    
    [self.nametext mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view.mas_left).offset(SCREENWIDTH/5);

        make.top.mas_equalTo(self.view).offset(100);
        
        make.height.mas_equalTo(@45);
        
        make.width.mas_equalTo(@(SCREENHEIGH/4));
                
    }];
    
    
    UIButton *startBTN =[UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.view addSubview:startBTN];
    
    [startBTN setTitle:@"开始直播" forState:UIControlStateNormal];
    
    [startBTN addTarget:self action:@selector(playInputClick) forControlEvents:UIControlEventTouchUpInside];
    
    startBTN.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"room_button"]];
    
    [startBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view.mas_left).offset(SCREENWIDTH/5);
        
        make.top.mas_equalTo(self.nametext.mas_bottom).offset(100);
        
        make.height.mas_equalTo(@45);
        
        make.width.mas_equalTo(@(250));
        
    }];
    
}

-(void)playInputClick{
    
    StartViewController *vc =[[StartViewController alloc]init];
    
    [self presentViewController:vc animated:YES completion:nil];
    
    
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
