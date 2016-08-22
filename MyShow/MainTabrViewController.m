//
//  MainTabrViewController.m
//  MyShow
//
//  Created by Apple on 16/8/16.
//  Copyright © 2016年 张国森. All rights reserved.
//

#import "MainTabrViewController.h"
#import "MeViewController.h"
#import "PushStremViewController.h"
#import "BaseLiveViewController.h"

#import "CommendLiveViewController.h"
#import "LiveViewController.h"
#import "WMPageController.h"
@interface MainTabrViewController ()

@end

@implementation MainTabrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
 
    [self SetUi];
    
    [self setupTabBarBackgroundImage];
    
    [self CheckNet];
    
    
}
-(void)CheckNet{
    
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    // 2.设置网络状态改变后的处理
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
                
            case AFNetworkReachabilityStatusUnknown: // 未知网络
            {
                
                [MBProgressHUD showSuccess:@"未知网络"];
                
                break;
            }
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
            {
                [MBProgressHUD showSuccess:@"无网络连接"];
                
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
            {
                [MBProgressHUD showSuccess:@"4G/3G流量状态"];
                
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
            {
                [MBProgressHUD showSuccess:@"当前为WIFI环境"];
                break;
            }
        }
    }];
    
    // 3.开始监控
    [manager startMonitoring];

}

-(void)SetUi{
    
    WMPageController *page = [self addPageController];

    UINavigationController *LiveNav =[[UINavigationController alloc]initWithRootViewController:page];
    
    PushStremViewController *Push =[[PushStremViewController alloc]init];
    
    UINavigationController *PushNav =[[UINavigationController alloc]initWithRootViewController:Push];
    
    
    MeViewController *Mine =[[MeViewController alloc]init];
    
    UINavigationController *MineNav =[[UINavigationController alloc]initWithRootViewController:Mine];
    
    self.viewControllers = @[LiveNav,PushNav,MineNav];
    
    NSArray *array = self.viewControllers;
    
    NSArray *SimagesArray = @[@"tab_live_p", @"tab_room_p", @"tab_me_p"];
    
    
    NSArray *imagesArray = @[@"tab_live", @"tab_room", @"tab_me"];
    
    for (int i = 0; i < array.count ; i++) {
        
        UIViewController *vc= array[i];
        
        vc.tabBarItem = [[UITabBarItem alloc]initWithTitle:nil image:[[UIImage imageNamed:imagesArray[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed: SimagesArray[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        vc.tabBarItem.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0);
        
    }
 
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"global_background"] forBarMetrics:UIBarMetricsDefault];
    
    
    
}

- (void)setupTabBarBackgroundImage {
    
//    //隐藏阴影线
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    
    UIImage *image = [UIImage imageNamed:@"tab_bg"];
    
    CGFloat top = 40; // 顶端盖高度
    CGFloat bottom = 40 ; // 底端盖高度
    CGFloat left = 100; // 左端盖宽度
    CGFloat right = 100; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    
    // 指定为拉伸模式，伸缩后重新赋值
    UIImage *TabBgImage = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    self.tabBar.backgroundImage = TabBgImage;
    
}

//自定义TabBar高度
- (void)viewWillLayoutSubviews {
    
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = 60;
    tabFrame.origin.y = self.view.frame.size.height - 60;
    self.tabBar.frame = tabFrame;
    
}


-(BaseLiveViewController *)addPageController{
    // 1.5
    NSMutableArray *salesVCs = [[NSMutableArray alloc] init];
    NSMutableArray *salesVCTitles = [[NSMutableArray alloc] init];
    for (int i = 0; i < 2; i++) {
        Class vcClass;
        NSString *title;
        switch (i) {
            case 0:
                vcClass = [CommendLiveViewController class];
                title = @"推荐";
                break;
            case 1:
                vcClass = [CommendLiveViewController class];
                title = @"关注";
                break;
        }
        [salesVCs addObject:vcClass];
        [salesVCTitles addObject:title];
    }
    
    
    
    BaseLiveViewController *salesVC = [[BaseLiveViewController alloc] initWithViewControllerClasses:salesVCs andTheirTitles:salesVCTitles];
        
    //在导航栏上展示
    salesVC.progressHeight = 3;
    salesVC.menuHeight = 44;
    salesVC.menuViewStyle = WMMenuViewStyleLine;
    salesVC.titleSizeSelected = 18;
    salesVC.titleSizeNormal = 18;
    salesVC.titleColorSelected = [UIColor colorWithRed:8/255.0 green:206/255.0 blue:109/255.0 alpha:1];
    salesVC.menuViewContentMargin = 0;
    salesVC.showOnNavigationBar = YES;
    salesVC.menuBGColor = [UIColor clearColor];
    return salesVC;
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
