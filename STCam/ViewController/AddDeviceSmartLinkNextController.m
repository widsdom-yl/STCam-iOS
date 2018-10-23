//
//  AddDeviceSmartLinkNextController.m
//  STCam
//
//  Created by guyunlong on 10/22/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "AddDeviceSmartLinkNextController.h"
#import "PrefixHeader.h"
#import <SpinKit/RTSpinKitView.h>
@interface AddDeviceSmartLinkNextController ()
@property(nonatomic,strong)UIView * topBackView;
@property(nonatomic,strong)UIView * middleBackView;
@property(nonatomic,strong)UIButton * nextButton;
@property(nonatomic,strong)UILabel * tipLb;
@property(nonatomic,strong)UILabel * infoLb;
@property(nonatomic,strong)UILabel * timeLeftLb;
@property(nonatomic,assign)NSInteger  timeLeft;
@property(nonatomic,strong)UIButton * cancelButton;
@property(nonatomic,strong)NSTimer * fireTimer;
@end

@implementation AddDeviceSmartLinkNextController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    @weakify(self)
    _fireTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        @strongify(self);
        --self.timeLeft;
        if (self.timeLeft <= 0) {
            [self.fireTimer invalidate];
            self.fireTimer = nil;
            [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count-3] animated:YES];
        }
        [self.timeLeftLb setText:[NSString stringWithFormat:@"string_finish_timeleft_%ld".localizedString,self.timeLeft]];
        
    }];
}
-(void)loadView{
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initNav];
}
-(void)initNav{
    [self setTitle:@"SmartConfig_connect".localizedString];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 28, 28);
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarItem;
    
    
    
    CGFloat y = 2*kPadding;
    /***********************top*************************/
    _topBackView = [[UIView alloc] initWithFrame:CGRectMake(kPadding*2, y, kScreenWidth-4*kPadding, 0)];
    [self.topBackView setBackgroundColor:[UIColor whiteColor]];
    [self.topBackView.layer setCornerRadius:5.0];
    [self.topBackView.layer setBorderWidth:1.0];
    [self.topBackView.layer setBorderColor:[UIColor colorWithHexString:@"0xcfcfcf"].CGColor];
    [self.view addSubview:_topBackView];
    
    _tipLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-4*kPadding, 40*kWidthCoefficient)];
    [_tipLb setTextAlignment:NSTextAlignmentCenter];
    [_tipLb setTextColor:kMainColor];
    [_tipLb setText:@"string_tip".localizedString];
    [_topBackView addSubview:_tipLb];
    CGFloat topY = 40*kWidthCoefficient;
    UIView * spilt = [[UIView alloc] initWithFrame:CGRectMake(0, topY,kScreenWidth-4*kPadding , 1)];
    [spilt setBackgroundColor:[UIColor colorWithHexString:@"0xcfcfcf"]];
    [_topBackView addSubview:spilt];
    topY+=1+2*kPadding;
    NSString * info = @"action_one_key_setting_desc1".localizedString;
    _infoLb = [[UILabel alloc] initWithFrame:CGRectMake(2*kPadding, topY, kScreenWidth-4*kPadding-4*kPadding, 0)];
    [_topBackView addSubview:_infoLb];
    [_infoLb setNumberOfLines:0];
    [_infoLb setTextColor:[UIColor colorWithHexString:@"0x969696"]];
    [_infoLb setText:info];
    [_infoLb sizeToFit];
    topY = CGRectGetMaxY(_infoLb.frame);
    topY+=2*kPadding;
    
    _timeLeft = 10;
    _timeLeftLb = [[UILabel alloc] initWithFrame:CGRectMake(0, topY, kScreenWidth-4*kPadding, 21*kWidthCoefficient)];
    [_timeLeftLb setTextAlignment:NSTextAlignmentCenter];
    [_timeLeftLb setTextColor:kMainColor];
    [_timeLeftLb setText:[NSString stringWithFormat:@"string_finish_timeleft_%ld".localizedString,_timeLeft]];
    [_topBackView addSubview:_timeLeftLb];
    topY += 21*kWidthCoefficient+kPadding;
    
    
    [_topBackView setHeight:topY];
    
    y += topY + 4*kPadding;
    
    RTSpinKitView *spinner = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleCircle color:kMainColor];
    [self.view addSubview:spinner];
    spinner.spinnerSize = 50.0*kWidthCoefficient;
    [spinner sizeToFit];
    [spinner setCenter:CGPointMake(kScreenWidth/2, y+25.0*kWidthCoefficient)];
    
    y += 5*kPadding + 50.0*kWidthCoefficient;
    _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(2*kPadding, y, kScreenWidth-4*kPadding, kButtonHeight)];
    [_cancelButton setTitle:@"cancel".localizedString forState:UIControlStateNormal];
    [_cancelButton setAppThemeType:ButtonStyleStyleAppTheme];
    [self.view addSubview:_cancelButton];
    
    [_nextButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)cancelButtonClicked{
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
