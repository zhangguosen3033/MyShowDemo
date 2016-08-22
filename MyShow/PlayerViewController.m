//
//  PlayerViewController.m
//  MyShow
//
//  Created by Apple on 16/8/17.
//  Copyright © 2016年 张国森. All rights reserved.
//

#import "PlayerViewController.h"
#import "BarrageRenderer.h"
#import "NSSafeObject.h"
#import "ALinBottomToolView.h"

#define XJScreenH [UIScreen mainScreen].bounds.size.height
#define XJScreenW [UIScreen mainScreen].bounds.size.width
#define Color(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
@interface PlayerViewController ()
{
    BarrageRenderer *_renderer;
    
    NSTimer * _timer;


}

@property (nonatomic, strong) BAURLSessionTask  *tasks;


/** 直播播放器 */
@property (nonatomic, strong) IJKFFMoviePlayerController *moviePlayer;
/** 底部的工具栏 */
@property(nonatomic, weak) ALinBottomToolView *toolView;
/** 顶部主播相关视图 */
//@property(nonatomic, weak) ALinLiveAnchorView *anchorView;
/** 同类型直播视图 */
//@property(nonatomic, weak) ALinCatEarView *catEarView;
/** 同一个工会的主播/相关主播 */
//@property(nonatomic, weak) UIImageView *otherView;
/** 直播开始前的占位图片 */
@property(nonatomic, weak) UIImageView *placeHolderView;
/** 粒子动画 */
@property(nonatomic, weak) CAEmitterLayer *emitterLayer;
/** 直播结束的界面 */
//@property (nonatomic, weak) ALinLiveEndView *endView;
@end

@implementation PlayerViewController

- (UIImageView *)placeHolderView
{
    if (!_placeHolderView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = self.view.bounds;
        imageView.image = [UIImage imageNamed:@"profile_user_414x414"];
        [self.view addSubview:imageView];
        _placeHolderView = imageView;
        
        [self showGifLoding:nil inView:self.placeHolderView];
        // 强制布局
        [_placeHolderView layoutIfNeeded];
    }
    return _placeHolderView;
}

bool _isSelected = NO;


- (void)viewDidLoad {
    [super viewDidLoad];

//    NSLog(@"直播数据%@",self.lives);
    
    [self Play];
    
    [self CreatotherUI];

}

-(void)CreatotherUI{
    
    ALinBottomToolView *toolView = [[ALinBottomToolView alloc] init];
    
    [toolView setClickToolBlock:^(LiveToolType type) {
        switch (type) {
            case LiveToolTypePublicTalk:
                
                //打开关闭弹幕
                _isSelected = !_isSelected;
                _isSelected ? [_renderer start] : [_renderer stop];
                
                break;
                
            case LiveToolTypePrivateTalk:
                
                //发送弹幕
            {
                
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"输入发送的内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送",nil];
                alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
  
                [alertView show];
                
                
            }
                break;
            case LiveToolTypeGift:
                
                //送礼物
                [MBProgressHUD showSuccess:@"点击了礼物按钮"];
                
                break;
            case LiveToolTypeRank:
                
                //奖杯
                [MBProgressHUD showSuccess:@"点击了奖杯按钮"];
                
                break;
            case LiveToolTypeShare:
                
                //分享
                
                [MBProgressHUD showSuccess:@"点击了分享按钮"];
                
                break;
            case LiveToolTypeClose:
                
                //退出直播
                [self quit];
                break;
            default:
                break;
        }
    }];
    
    [self.view insertSubview:toolView aboveSubview:self.moviePlayer.view];
    
    [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@-10);
        make.height.equalTo(@40);
    }];
    _toolView = toolView;

  
    //动画效果制作
    
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    // 发射器在xy平面的中心位置
    emitterLayer.emitterPosition = CGPointMake(self.moviePlayer.view.frame.size.width-50,self.moviePlayer.view.frame.size.height-50);
    // 发射器的尺寸大小
    emitterLayer.emitterSize = CGSizeMake(20, 20);
    // 渲染模式
    emitterLayer.renderMode = kCAEmitterLayerUnordered;
    // 开启三维效果
    //    _emitterLayer.preservesDepth = YES;
    NSMutableArray *array = [NSMutableArray array];
    // 创建粒子
    for (int i = 0; i<10; i++) {
        // 发射单元
        CAEmitterCell *stepCell = [CAEmitterCell emitterCell];
        // 粒子的创建速率，默认为1/s
        stepCell.birthRate = 1;
        // 粒子存活时间
        stepCell.lifetime = arc4random_uniform(4) + 1;
        // 粒子的生存时间容差
        stepCell.lifetimeRange = 1.5;
        // 颜色
        // fire.color=[[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1]CGColor];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"good%d_30x30", i]];
        // 粒子显示的内容
        stepCell.contents = (id)[image CGImage];
        // 粒子的名字
        //            [fire setName:@"step%d", i];
        // 粒子的运动速度
        stepCell.velocity = arc4random_uniform(100) + 100;
        // 粒子速度的容差
        stepCell.velocityRange = 80;
        // 粒子在xy平面的发射角度
        stepCell.emissionLongitude = M_PI+M_PI_2;;
        // 粒子发射角度的容差
        stepCell.emissionRange = M_PI_2/6;
        // 缩放比例
        stepCell.scale = 0.3;
        [array addObject:stepCell];
    }
    
    emitterLayer.emitterCells = array;

    [self.moviePlayer.view.layer insertSublayer:emitterLayer below:self.toolView.layer];
    
    _emitterLayer = emitterLayer;

    self.toolView.hidden = NO;
    
    _renderer = [[BarrageRenderer alloc] init];
    _renderer.canvasMargin = UIEdgeInsetsMake(SCREENHEIGH * 0.3, 10, 10, 10);
    [self.view addSubview:_renderer.view];
    
    NSSafeObject * safeObj = [[NSSafeObject alloc]initWithObject:self withSelector:@selector(autoSendBarrage)];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:safeObj selector:@selector(excute) userInfo:nil repeats:YES];
    
}
#pragma mark -提示框的协议方法
//当点击提示框上某一个按钮时调用这个方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //从0开始，对应按钮的顺序是从取消按钮依次对应提示框上的按钮
    switch (buttonIndex) {
        case 0:
        {
            //点击取消按钮
            NSLog(@"取消按钮被点击");
        }
            break;
        case 1:
        {
            NSLog(@"确定按钮被点击");
            
            UITextField *textField = [alertView textFieldAtIndex:0];
            //用用户名和密码提交给服务端
            NSLog(@"弹幕输入：%@",textField.text);
            
            //这里发送到服务端
            
        }
            
        default:
            break;
    }
    
}


- (void)autoSendBarrage
{
    NSInteger spriteNumber = [_renderer spritesNumberWithName:nil];
    if (spriteNumber <= 50) { // 限制屏幕上的弹幕量
        [_renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L]];
    }
}

#pragma mark - 弹幕描述符生产方法

long _index = 0;
/// 生成精灵描述 - 过场文字弹幕
- (BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(NSInteger)direction
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = self.danMuText[arc4random_uniform((uint32_t)self.danMuText.count)];
    descriptor.params[@"textColor"] = Color(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256));
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    descriptor.params[@"clickAction"] = ^{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"弹幕被点击" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
    };
    return descriptor;
}

- (NSArray *)danMuText
{
    return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"danmu.plist" ofType:nil]];
}


- (void)quit
{
    
    if (_moviePlayer) {
        [self.moviePlayer shutdown];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    [_renderer stop];
    [_renderer.view removeFromSuperview];
    _renderer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)viewWillAppear:(BOOL)animated {
   
    [super viewWillAppear:animated];
    
    [self.moviePlayer play];
    
 }

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
  

    
}

-(void)Play{
    
    if (_moviePlayer) {
        if (_moviePlayer) {
            [self.view insertSubview:self.placeHolderView aboveSubview:_moviePlayer.view];
        }
       
        [_moviePlayer shutdown];
        [_moviePlayer.view removeFromSuperview];
        _moviePlayer = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.imageUrl] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.parentVc showGifLoding:nil inView:self.placeHolderView];
            self.placeHolderView.image = [UIImage blurImage:image blur:0.8];
        });
    }];
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    [options setPlayerOptionIntValue:1  forKey:@"videotoolbox"];
    
    // 帧速率(fps) （可以改，确认非标准桢率会导致音画不同步，所以只能设定为15或者29.97）
    [options setPlayerOptionIntValue:29.97 forKey:@"r"];
    // -vol——设置音量大小，256为标准音量。（要设置成两倍音量时则输入512，依此类推
    [options setPlayerOptionIntValue:512 forKey:@"vol"];
    IJKFFMoviePlayerController *moviePlayer = [[IJKFFMoviePlayerController alloc] initWithContentURLString:self.playurl withOptions:options];
    moviePlayer.view.frame = self.view.bounds;
    
    // 填充fill
    moviePlayer.scalingMode = IJKMPMovieScalingModeAspectFill;
    // 设置自动播放(必须设置为NO, 防止自动播放, 才能更好的控制直播的状态)
    moviePlayer.shouldAutoplay = NO;
    // 默认不显示
    moviePlayer.shouldShowHudView = NO;
    
    [self.view addSubview:moviePlayer.view];
    
    [moviePlayer prepareToPlay];
    
    self.moviePlayer = moviePlayer;
    
    // 设置监听
    [self initObserver];
    
}

- (void)initObserver
{
    // 监听视频是否播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinish) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateDidChange) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:self.moviePlayer];
}

#pragma mark - notify method

- (void)stateDidChange
{
    if ((self.moviePlayer.loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        if (!self.moviePlayer.isPlaying) {
            [self.moviePlayer play];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (_placeHolderView) {
                    [_placeHolderView removeFromSuperview];
                    _placeHolderView = nil;
                    [self.moviePlayer.view addSubview:_renderer.view];
                }
                [self hideGufLoding];
            });
        }else{
            // 如果是网络状态不好, 断开后恢复, 也需要去掉加载
            if (self.gifView.isAnimating) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self hideGufLoding];
                });
                
            }
        }
    }else if (self.moviePlayer.loadState & IJKMPMovieLoadStateStalled){ // 网速不佳, 自动暂停状态
        [self showGifLoding:nil inView:self.moviePlayer.view];
    }
}

- (void)didFinish
{
    NSLog(@"加载状态...%ld %ld %s", self.moviePlayer.loadState, self.moviePlayer.playbackState, __func__);
    // 因为网速或者其他原因导致直播stop了, 也要显示GIF
    if (self.moviePlayer.loadState & IJKMPMovieLoadStateStalled && !self.parentVc.gifView) {
        [self showGifLoding:nil inView:self.moviePlayer.view];
        return;
    }
    //    方法：
    //      1、重新获取直播地址，服务端控制是否有地址返回。
    //      2、用户http请求该地址，若请求成功表示直播未结束，否则结束
    __weak typeof(self)weakSelf = self;
    
    self.tasks = [BANetManager ba_requestWithType:BAHttpRequestTypeGet withUrlString:self.playurl withParameters:nil withSuccessBlock:^(id response) {
        
        [weakSelf.moviePlayer play];
        
             return;
    } withFailureBlock:^(NSError *error) {
        
        [weakSelf.moviePlayer shutdown];
        [weakSelf.moviePlayer.view removeFromSuperview];
        weakSelf.moviePlayer = nil;
        
        [MBProgressHUD showError:@"网络错误"];
        
    } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
    

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
