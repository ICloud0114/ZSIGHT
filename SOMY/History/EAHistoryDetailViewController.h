//
//  EAHistoryDetailViewController.h
//  SOMY
//
//  Created by easaa on 9/2/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EAHistoryDetailViewController : UIViewController

@property (nonatomic, copy)NSString * userId;
@property (nonatomic, copy)NSString *memberId;
@property (nonatomic, copy)NSString *userName;
@property (nonatomic, copy)NSString *selectDate;
@property (nonatomic, copy)NSString *tableName;
@property (nonatomic, copy)NSString *topTemperature;
@property (nonatomic)BOOL getLocalData;
@end
//user_id=用户id
//member_id=成员用户id(如果是自已的温度，值为0)
//member_name=成员用户name
//device_id=设备id(不填选出全部)
//test_time=测试开始时间(格式有要求，必须是yyyy-MM-dd)
//lang_type=语言类型(中文:Zh-Hans,英文:en)

