//
//  LinkBlueViewController.h
//  SOMY
//
//  Created by smile on 14-10-11.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BluetoothTypeHeartRate,
    BluetoothTypeAnimation,
} BluetoothType;
@interface LinkBlueViewController : UIViewController
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BluetoothType bluetoothType;
@end
