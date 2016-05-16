//
//  EALoginViewController.h
//  SOMY
//
//  Created by easaa on 9/2/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol EARefreshMemberDelegate <NSObject>
- (void)loginSuccessAndRefreshMemberView;

@end
@interface EALoginViewController : UIViewController

@property (nonatomic, retain)id<EARefreshMemberDelegate> delegate;

@end
