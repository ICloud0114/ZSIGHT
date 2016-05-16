//
//  EAWarnViewController.h
//  SOMY
//
//  Created by LoveLi1y on 14/11/28.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EAWarnSettingDelegate <NSObject>

- (void)manualSettingWarnTemperature:(NSString *)warnTemperature;

@end

@interface EAWarnViewController : UIViewController

@property (nonatomic, assign)CGFloat warnTemperature;

@property (nonatomic, retain)id<EAWarnSettingDelegate> delegate;
@end
