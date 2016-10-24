//
//  WBSScanQRCodeViewController.m
//  WPUnlocker
//  https://github.com/iMuFeng/iUnlocker
//  Created by mufeng on 16/6/3.
//  Copyright © 2016年 puckjs.com. All rights reserved.
//

#import "WBSScanQRCodeViewController.h"
#import "WBSQRCodeLoginViewController.h"
#import "WBSQRCodeOauthViewController.h"

@interface WBSScanQRCodeViewController () <SFSafariViewControllerDelegate>

@property (strong,nonatomic) NSTimer *timer;

@property (strong,nonatomic) UIImageView *scanImageView;
@property (strong,nonatomic) UIImageView *animationImageView;

@property (strong,nonatomic) AVCaptureDevice *device;
@property (strong,nonatomic) AVCaptureDeviceInput *input;
@property (strong,nonatomic) AVCaptureMetadataOutput *output;
@property (strong,nonatomic) AVCaptureSession *session;
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *preview;

@end

@implementation WBSScanQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self setCamera];
}

- (void)setupViews {
    [self setBackground];
    [self setScanFrame];
    [self setScanAnimation];
    [self setDescription];
    [self setCancelButton];
}

- (void)setBackground {
    UIView *bv1 = [[UIView alloc] initWithFrame:(CGRect){0, 0, SCREEN_W, 150}];
    bv1.alpha = 0.8f;
    bv1.backgroundColor = UIColorFromHEXRGB(0x333333);
    [self.view addSubview:bv1];
    
    UIView *bv2 = [[UIView alloc] initWithFrame:(CGRect){0, 150, (SCREEN_W-285)/2, 285}];
    bv2.alpha = 0.8f;
    bv2.backgroundColor = UIColorFromHEXRGB(0x333333);
    [self.view addSubview:bv2];
    
    UIView *bv3 = [[UIView alloc] initWithFrame:(CGRect){(SCREEN_W+285)/2, 150, (SCREEN_H-285)/2, 285}];
    bv3.alpha = 0.8f;
    bv3.backgroundColor = UIColorFromHEXRGB(0x333333);
    [self.view addSubview:bv3];
    
    UIView *bv4 = [[UIView alloc] initWithFrame:(CGRect){0, 435, SCREEN_W, SCREEN_H-435}];
    bv4.alpha = 0.8f;
    bv4.backgroundColor = UIColorFromHEXRGB(0x333333);
    [self.view addSubview:bv4];
    
    self.edgesForExtendedLayout = NO;
}

- (void)setScanFrame {
    self.scanImageView = [[UIImageView alloc] initWithFrame:(CGRect){(SCREEN_W-285)/2, 150, 285, 285}];
    self.scanImageView.image = [UIImage imageNamed:@"scan_frame.png"];
    [self.view addSubview:self.scanImageView];
}

- (void)setScanAnimation {
    self.animationImageView = [[UIImageView alloc] initWithFrame:(CGRect){(SCREEN_W-285)/2, 150, 285, 2}];
    self.animationImageView.image = [UIImage imageNamed:@"scan_animation.png"];
    [self.view addSubview:self.animationImageView];
}

- (void)setDescription {
    UILabel *description = [[UILabel alloc] initWithFrame:(CGRect){0, 450.f, SCREEN_W, 16.f}];
    [description setTextColor:[UIColor colorWithWhite:256.f alpha:0.6]];
    [description setText:@"将二维码放入框内，即可自动扫描"];
    [description setFont:[UIFont fontWithName:@"Helvetica" size:13.f]];
    [description setTextAlignment:NSTextAlignmentCenter];
    
    [self.view addSubview:description];
}

- (void)setCamera {
    if (self.session == nil) {
        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
        self.output = [[AVCaptureMetadataOutput alloc]init];
        [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        [self.output setRectOfInterest:(CGRect){(150)/SCREEN_H, ((SCREEN_W-285)/2)/SCREEN_W, 285/SCREEN_H, 285/SCREEN_W}];
        
        self.session = [[AVCaptureSession alloc]init];
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];
        
        if ([self.session canAddInput:self.input]) {
            [self.session addInput:self.input];
        }
        
        if ([self.session canAddOutput:self.output]) {
            [self.session addOutput:self.output];
        }
        
        self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        self.preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
        self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.preview.frame = self.view.bounds;
        [self.view.layer insertSublayer:self.preview atIndex:0];
    }
}

- (void)setCancelButton {
    UIButton *button = [[UIButton alloc] initWithFrame:(CGRect){(SCREEN_W-150.f)/2, (SCREEN_H-50.f), 150.f, 35.f}];
    [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
    [button setTitle:@"取消扫码" forState:UIControlStateNormal];
    [button setTitleColor: UIColorFromHEXRGB(0xffffff) forState:UIControlStateNormal];
    [button setTitleColor: UIColorFromHEXRGB(0xaaaaaa) forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(toRootViewController) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (void)scanAnimation {
    [UIView animateWithDuration:1 animations:^{
        CGFloat endPoint = 0.0f;
        if (self.animationImageView.frame.origin.y < self.scanImageView.center.y) {
            endPoint = self.scanImageView.frame.origin.y + self.scanImageView.frame.size.height - 5;
        }else{
            endPoint = self.scanImageView.frame.origin.y + 5;
        }
        CGRect frame = self.animationImageView.frame;
        frame.origin.y = endPoint;
        [self.animationImageView setFrame:frame];
    }];
}

- (void)handleScanResult:(NSString *)result {
    NSLog(@"扫码成功，信息为：%@", result);
    
    id targetController;
    
    if ([result hasPrefix:@"iunlocker://"]) {
        targetController = [[WBSQRCodeLoginViewController alloc] init];
        [targetController setUrl:result];
        
        [self.navigationController pushViewController:targetController animated:YES];
    } else if ([result hasPrefix:@"iunlocker-auth://"]) {
        targetController = [[WBSQRCodeOauthViewController alloc] init];
        [targetController setUrl:result];
        
        [self.navigationController pushViewController:targetController animated:YES];
    } else {
        SFSafariViewController *targetController = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:result] entersReaderIfAvailable:NO];
        targetController.delegate = self;
        
        [self presentViewController:targetController animated:YES completion:nil];
    }
}

- (void)refreshViewController {
    [self.timer invalidate];
    self.timer = nil;
    
    [self.session startRunning];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scanAnimation) userInfo:nil repeats:YES];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSString *stringValue;
    
    if ([metadataObjects count] >0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [self.session stopRunning];
    
    [self.timer invalidate];
    self.timer = nil;
    
    [self handleScanResult:stringValue];
}

- (void)toRootViewController {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self refreshViewController];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
