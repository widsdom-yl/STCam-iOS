//
//  DoorControlCCell.h
//  STCam
//
//  Created by guyunlong on 2019/1/3.
//  Copyright © 2019年 South. All rights reserved.
//

#import <UIKit/UIKit.h>
#define doorBtnWidth (kScreenWidth-2*kPadding)/5
#define doorBtnHeight 40
#define DoorControlCCellIdentify @"DoorControlCCellIdentify"
@interface DoorControlCCell : UICollectionViewCell
@property (strong, nonatomic) NSString *title;
@property(copy,nonatomic)void (^btnClickBlock)(NSInteger channel);
+(CGSize)ccellSize;
@end
