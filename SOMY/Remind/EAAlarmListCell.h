//
//  EAAlarmListCell.h
//  SOMY
//
//  Created by LoveLi1y on 14/10/29.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EAAlarmListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *switchButton;
@property (weak, nonatomic) IBOutlet UILabel *alarmTime;
@property (weak, nonatomic) IBOutlet UILabel *weekday;

@end
