//
//  EAWeekListViewController.h
//  SOMY
//
//  Created by easaa on 9/2/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EAWeekListViewController;
@protocol EAWeekListDelegate <NSObject>

- (void)EAWeekListViewController:(EAWeekListViewController *)controller selectRepeatWeekByDictionary:(NSMutableDictionary *)weekInfomation;
@end

@interface EAWeekListViewController : UIViewController

@property (nonatomic ,retain) id<EAWeekListDelegate> delegate;

@end

