//
//  AddDeviceController.m
//  STCam
//
//  Created by coverme on 10/16/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "AddDeviceController.h"
#import "PrefixHeader.h"
#import <AVFoundation/AVFoundation.h>
#import "DevShareModel.h"
#import "WCQRCodeVC.h"
#define buttonHeight 1.25*kButtonHeight
@interface AddDeviceController ()<QRCodeDelegate>
@property (nonatomic, strong) UIButton *smartAddButton;
@property (nonatomic, strong) UIButton *apTStaAddButton;
@property (nonatomic, strong) UIButton *wifiAddButton;
@property (nonatomic, strong) UIButton *qrCodeAddButton;
@end

@implementation AddDeviceController

-(void)initNav{
    [self setTitle:@"action_add_device".localizedString];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 28, 28);
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarItem;
    
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)loadView{
    [super loadView];
    [self initNav];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    CGFloat y = 3*kPadding;
    _smartAddButton= [[UIButton alloc] initWithFrame:CGRectMake(2*kPadding, y, kScreenWidth-4*kPadding, buttonHeight)];
    [_smartAddButton setTitle:@"action_add_one_key_setting".localizedString forState:UIControlStateNormal];
    [_smartAddButton setAppThemeType:ButtonStyleHollowAppTheme];
    [self.view addSubview:_smartAddButton];
    
    y+=buttonHeight+3*kPadding;
    _apTStaAddButton= [[UIButton alloc] initWithFrame:CGRectMake(2*kPadding, y, kScreenWidth-4*kPadding, buttonHeight)];
    [_apTStaAddButton setTitle:@"action_add_ap_sta".localizedString forState:UIControlStateNormal];
    [_apTStaAddButton setAppThemeType:ButtonStyleHollowAppTheme];
    [self.view addSubview:_apTStaAddButton];
    
    y+=buttonHeight+3*kPadding;
    _wifiAddButton= [[UIButton alloc] initWithFrame:CGRectMake(2*kPadding, y, kScreenWidth-4*kPadding, buttonHeight)];
    [_wifiAddButton setTitle:@"action_add_device_search".localizedString forState:UIControlStateNormal];
    [_wifiAddButton setAppThemeType:ButtonStyleHollowAppTheme];
    [self.view addSubview:_wifiAddButton];
    
    y+=buttonHeight+3*kPadding;
    _qrCodeAddButton= [[UIButton alloc] initWithFrame:CGRectMake(2*kPadding, y, kScreenWidth-4*kPadding, buttonHeight)];
    [_qrCodeAddButton setTitle:@"action_add_share_device".localizedString forState:UIControlStateNormal];
    [_qrCodeAddButton setAppThemeType:ButtonStyleHollowAppTheme];
    [self.view addSubview:_qrCodeAddButton];
    
    [_smartAddButton addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_apTStaAddButton addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_wifiAddButton addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_qrCodeAddButton addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)addBtnClicked:(id)sender{
    if(sender == _smartAddButton){
        
    }
    else if(sender == _apTStaAddButton){
        
    }
    else if(sender == _wifiAddButton){
        
    }
    else if(sender == _qrCodeAddButton){
        WCQRCodeVC * vc = [WCQRCodeVC new];
        vc.delegate = self;
        [self QRCodeScanVC:vc];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)QRCodeScanVC:(UIViewController *)scanVC {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
                case AVAuthorizationStatusNotDetermined: {
                    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                        if (granted) {
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [self.navigationController pushViewController:scanVC animated:YES];
                            });
                            NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                        } else {
                            NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                        }
                    }];
                    break;
                }
                case AVAuthorizationStatusAuthorized: {
                    [self.navigationController pushViewController:scanVC animated:YES];
                    break;
                }
                case AVAuthorizationStatusDenied: {
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
                    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    
                    [alertC addAction:alertA];
                    [self presentViewController:alertC animated:YES completion:nil];
                    break;
                }
                case AVAuthorizationStatusRestricted: {
                    NSLog(@"因为系统原因, 无法访问相册");
                    break;
                }
                
            default:
                break;
        }
        return;
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:alertA];
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma QRCodeDelegate
- (void)SCanQRCodeResult:(NSString*)result{
    if(result){
        NSData *utf8Data = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        id dictionary = [NSJSONSerialization JSONObjectWithData:utf8Data options:NSJSONReadingMutableLeaves error:&error];
        if([dictionary isKindOfClass:[NSDictionary class]]){
            DevShareModel * model = [DevShareModel DevShareModelWithDict:dictionary];
            if(model){
                
            }
        }
        
    }
}



@end