//
//  EAMusicListViewController.h
//  SOMY
//
//  Created by easaa on 9/2/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EAMusicListViewController;
@protocol EAMusicListDelegate <NSObject>

- (void)EAMusicListViewController:(EAMusicListViewController *)controller selectMusicByString:(NSString *)musicName;

@end
@interface EAMusicListViewController : UIViewController
@property (nonatomic ,retain) id<EAMusicListDelegate> delegate;
@property (nonatomic ,assign) BOOL isSelect;// YES 设置铃声 ，NO 普通播放铃声
@end
