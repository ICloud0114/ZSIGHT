



#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "LePeripheralService.h"






/****************************************************************************/
/*							Discovery class									*/
/****************************************************************************/
@interface LeDiscovery : NSObject{
    CBCentralManagerState previousState;
    NSString *_strDeviceType;
    NSMutableDictionary *_bundlePeripherals;
}
@property (nonatomic, retain) NSString *strDeviceType; ///< str 设备类型

+ (id) sharedInstance;


/****************************************************************************/
/*								UI controls									*/
/****************************************************************************/
@property (nonatomic, assign) id<LePeripheralDelegate>          peripheralDelegate;


/****************************************************************************/
/*								Actions										*/
/****************************************************************************/
//开始扫描
- (void) startScanningForUUIDString:(NSString *)uuidString;
//停止扫描
- (void) stopScanning;
//连接口
- (void) connectPeripheral:(CBPeripheral*)peripheral;
//断开
- (void) disconnectPeripheral:(CBPeripheral*)peripheral;


/****************************************************************************/
/*							Access to the devices							*/
/****************************************************************************/
@property (retain, nonatomic) NSMutableArray    *foundPeripherals;
@property (retain, nonatomic) NSMutableArray	*connectedServices;	// Array of LePeripheralService
@property (retain, nonatomic) NSMutableDictionary *bundlePeripherals; ///< arr 绑定的设备
//@property (retain, nonatomic) NSMutableDictionary *dicArray;
@property (retain, nonatomic) NSMutableArray *dicArray;

@end
