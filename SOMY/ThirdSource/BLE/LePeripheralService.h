



#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


/****************************************************************************/
/*						Service Characteristics								*/
/****************************************************************************/
extern NSString *kSimpleBLEPeripheralUUIDString;
extern NSString *kSimpleBLEPeripheralServicesUUIDString;
extern NSString *kSimpleBLEPeripheralReadCharacteristicUUIDString;
extern NSString *kSimpleBLEPeripheralWriteCharacteristicUUIDString;

/****************************************************************************/
/*								Protocol									*/
/****************************************************************************/
@class LePeripheralService;


@protocol LePeripheralDelegate<NSObject>

@optional
- (void) centralManagerDidUpdateState:(CBCentralManagerState)state;
- (void) serviceDidDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData;
- (void) serviceDidConnect:(LePeripheralService*)service;
- (void) serviceDidFailToConnect:(CBPeripheral *)peripheral;
- (void) serviceDidDisconnect:(LePeripheralService*)service;
- (void) peripheralDidReadValue:(LePeripheralService *)service value:(NSData *)data;
@end


/****************************************************************************/
/*						LePeripheralService                         */
/****************************************************************************/
@interface LePeripheralService : NSObject{
    NSString *_strDevice;
}

- (id) initWithPeripheral:(CBPeripheral *)peripheral controller:(id<LePeripheralDelegate>)controller;
- (void) reset;
- (void) start;

/* Querying Sensor */


/* Behave properly when heading into and out of the background */
- (void)enteredBackground;
- (void)enteredForeground;

- (NSData *)readValue;
- (void)writeValue:(NSData *)data;

@property (readonly) CBPeripheral *peripheral;
@property (nonatomic, retain) NSString *strDeviceTag;
@end
