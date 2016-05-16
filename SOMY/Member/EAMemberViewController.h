//
//  EAMemberViewController.h
//  SOMY
//
//  Created by easaa on 9/2/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EASelectMemberDelegate <NSObject>

- (void)selectMemberWithInfomation:(NSDictionary *)dictionary;

@end

@interface EAMemberViewController : UIViewController

@property (nonatomic ,retain) id<EASelectMemberDelegate> delegate;
@end
