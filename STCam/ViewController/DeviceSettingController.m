//
//  DeviceSettingController.m
//  STCam
//
//  Created by guyunlong on 10/14/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "DeviceSettingController.h"
#import "PrefixHeader.h"
#import "STFileManager.h"
#import "CommonSettingCell.h"
@interface DeviceSettingController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong)UIImageView * devThumbView;//设备缩略图
@property(nonatomic,strong)UILabel * snLabel;
@property(nonatomic,strong)UILabel * uidLabel;
@property(nonatomic,strong)UITableView * mTableView;
@property(nonatomic,strong)UIButton  * deleteButton;//删除按钮
@property(nonatomic,strong)NSMutableArray  * rowsArray;//列表数据
@end

@implementation DeviceSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initValue];
    [self.mTableView reloadData];
}

-(void)initValue{
    _rowsArray = [NSMutableArray new];
    
    InfoModel * model0 = [InfoModel new];
    InfoModel * model1 = [InfoModel new];
    InfoModel * model2 = [InfoModel new];
    InfoModel * model3 = [InfoModel new];
    InfoModel * model4 = [InfoModel new];
    
    
    
    [model0 setTitle:@"device_name".localizedString];
    [model1 setTitle:@"action_device_pwd".localizedString];
    [model2 setTitle:@"action_push".localizedString];
    [model3 setTitle:@"string_DevAdvancedSettings".localizedString];
    [model4 setTitle:@"action_version".localizedString];
    
   
    
    [_rowsArray addObject:model0];
    [_rowsArray addObject:model1];
    [_rowsArray addObject:model2];
    [_rowsArray addObject:model3];
    [_rowsArray addObject:model4];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(_model){
        STFileManager * manager = [STFileManager sharedManager];
        if (![manager fileExistsForUrl:@"Thumbnail"]) {
            [manager createDirectoryNamed:@"Thumbnail"];
        }
        NSString * fileName = [manager localPathForFile:[NSString stringWithFormat:@"%@.png",self.model.SN] inDirectory:@"Thumbnail"];
        UIImage * image  =[UIImage imageWithContentsOfFile:fileName];
        if (image) {
            [_devThumbView setImage:image];
            _devThumbView.contentMode = UIViewContentModeScaleToFill;
        }
        else{
            [_devThumbView setImage:[UIImage imageNamed:@"imagethumb"]];
        }
        
        [_snLabel setText:[NSString stringWithFormat:@"SN:%@",self.model.SN]];
        if ([self.model.IPUID length] == 20) {
             [_uidLabel setText:[NSString stringWithFormat:@"UID:%@",self.model.IPUID]];
            [_snLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.devThumbView.mas_centerY).with.offset(-kPadding/3);
            }];
           
        }
        else{
            [_uidLabel setHidden:YES];
            [_snLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.devThumbView.mas_centerY);
            }];
        }
        
        InfoModel * model0 = [_rowsArray objectAtIndex:0];
        [model0 setInfo:_model.DevName];
        [self.mTableView reloadData];
       
    }
    
}
-(void)loadView{
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initNav];
    _devThumbView = [[UIImageView alloc] initWithFrame:CGRectMake(kPadding, kPadding, 100*kWidthCoefficient, 50*kWidthCoefficient)];
    [self.view addSubview:_devThumbView];
    
    _snLabel = [UILabel new];
    [self.view addSubview:_snLabel];
    
    _uidLabel = [UILabel new];
    [self.view addSubview:_uidLabel];
    
    [_snLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.bottom.mas_equalTo(self.devThumbView.mas_centerY).with.offset(-kPadding/3);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-kPadding);
        make.height.equalTo(@24);
        make.left.mas_equalTo(self.devThumbView.mas_right).with.offset(kPadding);
    }];
    
    [_uidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.devThumbView.mas_centerY).with.offset(kPadding/3);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-kPadding);
        make.height.equalTo(@24);
        make.left.mas_equalTo(self.devThumbView.mas_right).with.offset(kPadding);
    }];
    
    _mTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView setUserInteractionEnabled:NO];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView;
    });
    CGFloat y = 50*kWidthCoefficient + 2*kPadding;
    [_mTableView setFrame:CGRectMake(0, y, kScreenWidth, 5*[CommonSettingCell cellHeight])];
    [self.view addSubview:_mTableView];
    
    y+= 5*[CommonSettingCell cellHeight] + 5*kPadding;
    _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(2*kPadding, y, kScreenWidth-4*kPadding, kButtonHeight)];
    [_deleteButton setTitle:@"action_delete_device".localizedString forState:UIControlStateNormal];
    [_deleteButton setAppThemeType:ButtonStyleStyleAppTheme];
    [self.view addSubview:_deleteButton];
    
    
}

-(void)initNav{
    [self setTitle:@"action_dev_setting".localizedString];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_rowsArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    CommonSettingCell * cell = [CommonSettingCell CommonSettingCellWith:tableView indexPath:indexPath];
    [cell setModel:_rowsArray[indexPath.row]];
    [cell setFrame:CGRectMake(0, 0, kScreenWidth, [CommonSettingCell cellHeight])];
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
    
    return cell;
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CommonSettingCell cellHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //    MediaDetailController *ctl = [MediaDetailController new];
    //    [ctl setHidesBottomBarWhenPushed:YES];
    //    [ctl setModel:_devListViewModel.deviceArray[indexPath.row]];
    //    [self.navigationController pushViewController:ctl animated:YES];
}

@end