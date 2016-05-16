//
//  EAAddAlarmViewController.h
//  SOMY
//
//  Created by easaa on 9/2/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>


@class EAAddAlarmViewController;
@protocol EAAddAlarmDelegate <NSObject>

- (void)EAAddAlarmViewController:(EAAddAlarmViewController *)controller addNewAlarmByDictionary:(NSDictionary *)alarmDictionary;
- (void)refreshAlarmListAction;

@end

@interface EAAddAlarmViewController : UIViewController

@property (nonatomic ,retain) id<EAAddAlarmDelegate> delegate;

- (id)initWithAlarmInfomation:(NSDictionary *)infoDictionary;
@end
