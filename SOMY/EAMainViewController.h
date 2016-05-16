//
//  EAMainViewController.h
//  SOMY
//
//  Created by easaa on 9/2/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAMemberViewController.h"
#import "EAWarnViewController.h"
@protocol EARefreshMemberDelegate <NSObject>

- (void)refreshHistoryListWithInfomation:(NSDictionary *)dictionary;

@end
@interface EAMainViewController : UIViewController<EASelectMemberDelegate,EAWarnSettingDelegate>

@property (nonatomic,retain) id<EARefreshMemberDelegate> delegate;

@end
