
//  LeSimple.m
//  Camera
//
//  Created by 阮毅文 on 14-10-9.
//  Copyright (c) 2014年 阮毅文. All rights reserved.
//

#import "LeSimple.h"
#import "LinkBlueViewController.h"
static LeSimple *simple = nil;
@implementation LeSimple
- (void)dealloc
{
    if (_connectionTimer)
    {
        [_connectionTimer invalidate];
        _connectionTimer = nil;
    }
}
+ (LeSimple *)shareLeSimple
{
    if (simple == nil)
    {
        simple = [[LeSimple alloc] init];
        [simple searchDevice];
    }
    return simple;
}
//- (void)connectionDevice{
//    _foundPeripherals = [[NSMutableArray alloc] init];
//    [self searchDevice];
//}
-(void)stop
{
    [[LeDiscovery sharedInstance] stopScanning];
}
- (void)searchDevice
{
    [[LeDiscovery sharedInstance] setPeripheralDelegate:self];
    [[LeDiscovery sharedInstance] startScanningForUUIDString:nil];//扫描蓝牙设备
    self.foundPeripherals = [[NSMutableArray alloc] init];
    
    
}
- (void)serviceDidConnect:(LePeripheralService *)service
{
    self.service = service;
}
- (void) serviceDidDisconnect:(LePeripheralService*)service
{
    //30秒后重新连接
    _connectionTimer = [NSTimer scheduledTimerWithTimeInterval:6
                                                       target:self
                                                     selector:@selector(searchDevice)
                                                     userInfo:nil
                                                      repeats:YES];
}
#pragma mark - 蓝牙进入后台
- (void)didEnterBackgroundNotification:(NSNotification*)notification
{
    NSLog(@"Entered background notification called.");
    //    [self writeData];
}
- (void)didEnterForegroundNotification:(NSNotification*)notification
{
}
#pragma mark LePeripheralDelegate

- (void) centralManagerDidUpdateState:(CBCentralManagerState)state
{//系统蓝牙状态改变
    switch (state)
    {
		case CBCentralManagerStatePoweredOff:
		{
            /* Tell user to power ON BT for functionality, but not on first run - the Framework will alert in that instance. */
            
			break;
		}
            
		case CBCentralManagerStateUnauthorized:
		{
			/* Tell user the app is not allowed. */
			break;
		}
            
		case CBCentralManagerStateUnknown:
		{
			/* Bad news, let's wait for another event. */
			break;
		}
            
		case CBCentralManagerStatePoweredOn:
		{
            [self searchDevice];
			break;
		}
            
		case CBCentralManagerStateResetting:
		{
			break;
		}
            
        default:
        {
            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"UNSUPORTBLUETOOTH_4_0" delegate:nil cancelButtonTitle:nil otherButtonTitles:DPLocalizedString(@"Confirm"), nil];
            [alertV show];
            
        }
            break;
	}
}
- (void) serviceDidDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData
{//扫描到设备,advertisementData广播数据
    [self.foundPeripherals  setArray:[[LeDiscovery sharedInstance] foundPeripherals]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadUI" object:self.foundPeripherals];
    
    NSString *adDataStr = [[advertisementData objectForKey:CBAdvertisementDataManufacturerDataKey] description];
    NSLog(@"peripheral.name :%@",peripheral.name);
      if ([peripheral.name isEqualToString:@"Somy T01"])
      {
    
          if ([[NSUserDefaults standardUserDefaults]objectForKey:@"selectDevice"])
          {
              NSString *range = [adDataStr substringWithRange:NSMakeRange(10, 6)];
              NSString *uuid = [NSString stringWithFormat:@"%@",range];
              
              if ([uuid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"]])
              {
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"BlueData" object:adDataStr];
              }
              
          }
          else
          {
              [[NSNotificationCenter defaultCenter] postNotificationName:@"BlueData" object:adDataStr];
          }

        NSLog(@"advertisementData==%@",advertisementData);
        NSLog(@"peripheral.name=======ZJHD2");
        NSLog(@"广播数据-adDataStr:%@", adDataStr);
        return;
    }
    
    NSLog(@"地址长度:%lu",(unsigned long)adDataStr.length);
    if (!adDataStr)
    {
        NSLog(@"广播数据为空");
        return;
    }
    adDataStr =  adDataStr;//[CKTool stringFormat:adDataStr];
}
- (void) peripheralDidReadValue:(LePeripheralService *)service value:(NSData *)data
{
    
    NSLog(@"读到的数据=%@",[data description]);
    if (!data)
    {
        return;
    }
        self.service = service;
    
}
- (void) writeValue:(NSData *)data{
    if (!data)
    {
        return;
    }
    if (!self.service) {
        NSLog(@"service is nil");
        return;
    }
    NSLog(@"%@",data);
    [self.service writeValue:data];
    
}
@end

