//
//  EAAddMemberViewController.h
//  SOMY
//
//  Created by easaa on 9/2/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EAAddMemberDelegate <NSObject>

- (void)addMemberSuccessAndRefreshMemberList;

@end
@interface EAAddMemberViewController : UIViewController


@property (nonatomic, retain)id<EAAddMemberDelegate> delegate;
@end
