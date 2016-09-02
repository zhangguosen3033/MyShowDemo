
#import "StartLiveView.h"
#import "LFLiveSession.h"
#import "UIControl+Add.h"
#import "UIView+Add.h"
#define XJScreenH [UIScreen mainScreen].bounds.size.height
#define XJScreenW [UIScreen mainScreen].bounds.size.width
@interface StartLiveView() <LFLiveSessionDelegate>

//美颜
@property (nonatomic, strong) UIButton *beautyButton;

//切换前后摄像头
@property (nonatomic, strong) UIButton *cameraButton;

//关闭
@property (nonatomic, strong) UIButton *closeButton;

@property(nonatomic,strong)UILabel *stateLabel;

//开始直播
@property (nonatomic, strong) UIButton *startLiveButton;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) LFLiveDebug *debugInfo;

@property (nonatomic, strong) LFLiveSession *session;

@end

static int padding = 30;
@implementation StartLiveView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        
        //加载视频录制
        [self requestAccessForVideo];
        
        //加载音频录制
        [self requestAccessForAudio];
        
        //创建界面容器
        [self addSubview:self.containerView];
        
        // 添加按钮
        [self.containerView addSubview:self.closeButton];
        [self.containerView addSubview:self.cameraButton];
        [self.containerView addSubview:self.beautyButton];
        [self.containerView addSubview:self.startLiveButton];
        [self.containerView addSubview:self.stateLabel];
    }
    return self;
}

#pragma mark ---- <加载视频录制>
- (void)requestAccessForVideo{
    __weak typeof(self) _self = self;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            // 许可对话没有出现，发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_self.session setRunning:YES];
                    });
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            // 已经开启授权，可继续
            [_self.session setRunning:YES];
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            // 用户明确地拒绝授权，或者相机设备无法访问
            
            break;
        default:
            break;
    }
}

#pragma mark ---- <加载音频录制>
- (void)requestAccessForAudio{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            break;
        default:
            break;
    }
}


#pragma mark ---- <创建会话>
- (LFLiveSession*)session{
    if(!_session){
        /***   默认分辨率368 ＊ 640  音频：44.1 iphone6以上48  双声道  方向竖屏 ***/
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_Medium2]];
        
        /**    自己定制高质量音频128K 分辨率设置为720*1280 方向竖屏 */
        /*
         LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
         audioConfiguration.numberOfChannels = 2;
         audioConfiguration.audioBitrate = LFLiveAudioBitRate_128Kbps;
         audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
         
         LFLiveVideoConfiguration *videoConfiguration = [LFLiveVideoConfiguration new];
         videoConfiguration.videoSize = CGSizeMake(720, 1280);
         videoConfiguration.videoBitRate = 800*1024;
         videoConfiguration.videoMaxBitRate = 1000*1024;
         videoConfiguration.videoMinBitRate = 500*1024;
         videoConfiguration.videoFrameRate = 15;
         videoConfiguration.videoMaxKeyframeInterval = 30;
         videoConfiguration.orientation = UIInterfaceOrientationPortrait;
         videoConfiguration.sessionPreset = LFCaptureSessionPreset720x1280;
         
         _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:videoConfiguration liveType:LFLiveRTMP];
         */
        
        // 设置代理
        _session.delegate = self;
        _session.running = YES;
        _session.preView = self;
    }
    return _session;
}

#pragma mark ---- <界面容器>
- (UIView*)containerView{
    if(!_containerView){
        _containerView = [UIView new];
        _containerView.frame = self.bounds;
        _containerView.backgroundColor = [UIColor clearColor];
        _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _containerView;
}

#pragma mark ---- <关闭界面>
- (UIButton*)closeButton{
    
    if(!_closeButton){
        _closeButton = [UIButton new];
        
        //位置
        _closeButton.frame = CGRectMake(XJScreenW - padding * 2, padding, padding, padding);

        [_closeButton setImage:[UIImage imageNamed:@"close_preview"] forState:UIControlStateNormal];
        _closeButton.exclusiveTouch = YES;
        __weak __typeof__(self) weakSelf = self;
        [_closeButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
            [weakSelf.viewController dismissViewControllerAnimated:YES completion:nil];
        }];

    }
    return _closeButton;
}

#pragma mark --- <状态显示label>

-(UILabel *)stateLabel{
    
    if (!_stateLabel) {
        
        self.stateLabel =[UILabel new];

        [self.containerView addSubview:self.stateLabel];

        [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {

            make.left.mas_equalTo(self.beautyButton.mas_right).offset(padding);

            make.right.mas_equalTo(self.cameraButton.mas_left).offset(padding);

            make.centerY.mas_equalTo(self.cameraButton);

        }];
        
        _stateLabel.textColor =[UIColor whiteColor];

        _stateLabel.text = @"未开始连接";
    }
    
    return _stateLabel;
    
}

#pragma mark ---- <切换摄像头>
- (UIButton*)cameraButton{
    if(!_cameraButton){

        _cameraButton = [UIButton new];
        
         //位置
        _cameraButton.frame = CGRectMake(XJScreenW - padding * 4, padding, padding, padding);
        
        [_cameraButton setImage:[UIImage imageNamed:@"camra_preview"] forState:UIControlStateNormal];
        _cameraButton.exclusiveTouch = YES;
        __weak typeof(self) _self = self;

        [_cameraButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
            AVCaptureDevicePosition devicePositon = _self.session.captureDevicePosition;
            _self.session.captureDevicePosition = (devicePositon == AVCaptureDevicePositionBack) ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
        }];
        
     }
    return _cameraButton;
}

#pragma mark ---- <美颜功能>
- (UIButton*)beautyButton{
    if(!_beautyButton){
        _beautyButton = [UIButton new];

        //位置
        _beautyButton.frame = CGRectMake(padding, padding, padding, padding);
        
        [_beautyButton setImage:[UIImage imageNamed:@"camra_beauty"] forState:UIControlStateSelected];
        [_beautyButton setImage:[UIImage imageNamed:@"camra_beauty_close"] forState:UIControlStateNormal];
        _beautyButton.exclusiveTouch = YES;
        __weak typeof(self) _self = self;
        [_beautyButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
            _self.session.beautyFace = !_self.session.beautyFace;
            _self.beautyButton.selected = !_self.session.beautyFace;
        }];
    }
    return _beautyButton;
}

#pragma mark ---- <开始录制>
//调用LF的API开始录制
- (UIButton*)startLiveButton{
    if(!_startLiveButton){
        
        _startLiveButton = [UIButton new];
        
        //位置
        _startLiveButton.frame = CGRectMake((XJScreenW - 200) * 0.5, XJScreenH - 100, 200, 40);
        
        _startLiveButton.layer.cornerRadius = _startLiveButton.frame.size.height * 0.5;
        [_startLiveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_startLiveButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_startLiveButton setTitle:@"开始直播" forState:UIControlStateNormal];
        [_startLiveButton setBackgroundColor:[UIColor grayColor]];
        _startLiveButton.exclusiveTouch = YES;
        __weak typeof(self) _self = self;
        [_startLiveButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
            _self.startLiveButton.selected = !_self.startLiveButton.selected;
            if(_self.startLiveButton.selected){
                [_self.startLiveButton setTitle:@"结束直播" forState:UIControlStateNormal];
                LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
                stream.url = @"rtmp://202.117.80.19:1935/live/live4";
                [_self.session startLive:stream];
            }else{
                [_self.session stopLive];

                [_self.startLiveButton setTitle:@"开始直播" forState:UIControlStateNormal];
            }
        }];
    }
    return _startLiveButton;
}

#pragma mark ---- <LFStreamingSessionDelegate>

/** live status changed will callback */
- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange:(LFLiveState)state{
    
    NSString *tempStatus;
    switch (state) {
        case LFLiveReady:
            tempStatus = @"准备中";
            break;
        case LFLivePending:
            tempStatus = @"连接中";
            break;
        case LFLiveStart:
            tempStatus = @"已连接";
            break;
        case LFLiveStop:
            tempStatus = @"已断开";
            break;
        case LFLiveError:
            tempStatus = @"连接出错";
            break;
        default:
            break;
    }
    self.stateLabel.text = [NSString stringWithFormat:@"状态: %@", tempStatus];

    NSLog(@"%@",self.stateLabel.text);
}

/** live debug info callback */
- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug*)debugInfo{
    
}

/** callback socket errorcode */
- (void)liveSession:(nullable LFLiveSession*)session errorCode:(LFLiveSocketErrorCode)errorCode{
    
}



@end
