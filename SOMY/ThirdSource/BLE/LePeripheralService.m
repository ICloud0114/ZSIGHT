


#import "LePeripheralService.h"
#import "LeDiscovery.h"


NSString *kSimpleBLEPeripheralUUIDString = @"4EEFFDDF-ABFB-8275-B3D3-0FC84D3E879C";
NSString *kSimpleBLEPeripheralServicesUUIDString = @"0A60";
NSString *kSimpleBLEPeripheralReadCharacteristicUUIDString = @"0A67";
NSString *kSimpleBLEPeripheralWriteCharacteristicUUIDString = @"0A66";


@interface LePeripheralService() <CBPeripheralDelegate> {
@private
    CBPeripheral		*servicePeripheral;
    
    CBService			*BLEPeripheralService;
    
    CBCharacteristic	*readCharacteristic;
    CBCharacteristic    *writeCharacteristic;
    
    CBUUID              *peripheralUUID;
    CBUUID              *peripheralServiceUUID;
    CBUUID              *readCharacteristicUUID;
    CBUUID              *writeCharacteristicUUID;

    id<LePeripheralDelegate>	peripheralDelegate;
}
@property (nonatomic, retain) CBCharacteristic    *writeCharacteristic;
@end



@implementation LePeripheralService
@synthesize strDeviceTag = _strDeviceTag;
@synthesize writeCharacteristic;

@synthesize peripheral = servicePeripheral;


#pragma mark -
#pragma mark Init
/****************************************************************************/
/*								Init										*/
/****************************************************************************/
- (id) initWithPeripheral:(CBPeripheral *)peripheral controller:(id<LePeripheralDelegate>)controller
{
    self = [super init];
    if (self) {
        servicePeripheral = peripheral ;
        [servicePeripheral setDelegate:self];
		peripheralDelegate = controller;
        
        peripheralUUID	= [CBUUID UUIDWithString:kSimpleBLEPeripheralUUIDString];
        peripheralServiceUUID = [CBUUID UUIDWithString:kSimpleBLEPeripheralServicesUUIDString];
        readCharacteristicUUID = [CBUUID UUIDWithString:kSimpleBLEPeripheralReadCharacteristicUUIDString] ;
        writeCharacteristicUUID	= [CBUUID UUIDWithString:kSimpleBLEPeripheralWriteCharacteristicUUIDString] ;
	}
    return self;
}





- (void) reset
{
    [[LeDiscovery sharedInstance] disconnectPeripheral:servicePeripheral];
    peripheralDelegate = nil;
	if (servicePeripheral) {
		servicePeripheral = nil;
	}
}



#pragma mark -
#pragma mark Service interaction
/****************************************************************************/
/*							Service Interactions							*/
/****************************************************************************/
- (void) start
{
	CBUUID	*serviceUUID	= [CBUUID UUIDWithString:kSimpleBLEPeripheralServicesUUIDString];
	NSArray	*serviceArray	= [NSArray arrayWithObjects:serviceUUID, nil];

    [servicePeripheral discoverServices:serviceArray];
}

//查询蓝牙服务回调函数
- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
	NSArray	*services	= nil;
	NSArray	*uuids	= [NSArray arrayWithObjects:readCharacteristicUUID,writeCharacteristicUUID,
								   nil];

	if (peripheral != servicePeripheral) {
		NSLog(@"Wrong Peripheral.\n");
		return ;
	}
    
    if (error != nil) {
        NSLog(@"Error %@\n", error);
		return ;
	}

	services = [peripheral services];
	if (!services || ![services count]) {
		return ;
	}

	BLEPeripheralService = nil;
    
	for (CBService *service in services) {
		if ([[service UUID] isEqual:[CBUUID UUIDWithString:kSimpleBLEPeripheralServicesUUIDString]]) {
			BLEPeripheralService = service;
			break;
		}
	}

	if (BLEPeripheralService) {
		[peripheral discoverCharacteristics:uuids forService:BLEPeripheralService];
	}
}

//查询蓝牙所带的特征值回调函数
- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error;
{
		if (peripheral != servicePeripheral) {
		NSLog(@"Wrong Peripheral.\n");
		return ;
	}
	
	if (service != BLEPeripheralService) {
		NSLog(@"Wrong Service.\n");
		return ;
	}
    
    if (error != nil) {
		NSLog(@"Error %@\n", error);
		return ;
	}
    
    NSArray *characteristics = [service characteristics];
	for (CBCharacteristic *characteristic in characteristics) {
        NSLog(@"discovered characteristic %@", [characteristic UUID]);
        NSLog(@"readCharacteristicUUID:%@\nwriteCharacteristicUUID:%@", readCharacteristicUUID, writeCharacteristicUUID);
		if ([[characteristic UUID] isEqual:readCharacteristicUUID]) { // 读的通道
            NSLog(@"Discovered readCharacteristic");
			readCharacteristic = characteristic ;
            NSLog(@"readCharacteristic:%@", readCharacteristic);
			[peripheral setNotifyValue:YES forCharacteristic:readCharacteristic];
		}else if ([[characteristic UUID] isEqual:writeCharacteristicUUID]){// 写的通道
            NSLog(@"Discovered writeCharacteristic");
            writeCharacteristic = characteristic ;
            NSLog(@"writeCharacteristic:%@", writeCharacteristic);
			[peripheral readValueForCharacteristic:characteristic];
        }
	}
}



#pragma mark -
#pragma mark Characteristics interaction
/****************************************************************************/
/*						Characteristics Interactions						*/
/****************************************************************************/

- (void)enteredBackground
{
    // Find the fishtank service
    for (CBService *service in [servicePeripheral services]) {
        if ([[service UUID] isEqual:[CBUUID UUIDWithString:kSimpleBLEPeripheralServicesUUIDString]]) {
            
            // Find the temperature characteristic
            for (CBCharacteristic *characteristic in [service characteristics]) {
                if ( [[characteristic UUID] isEqual:[CBUUID UUIDWithString:kSimpleBLEPeripheralReadCharacteristicUUIDString]] ) {
                    
                    // And STOP getting notifications from it
                    [servicePeripheral setNotifyValue:NO forCharacteristic:characteristic];
                }
            }
        }
    }
}

- (void)enteredForeground
{
    // Find the fishtank service
    for (CBService *service in [servicePeripheral services]) {
        if ([[service UUID] isEqual:[CBUUID UUIDWithString:kSimpleBLEPeripheralServicesUUIDString]]) {
            
            // Find the temperature characteristic
            for (CBCharacteristic *characteristic in [service characteristics]) {
                if ( [[characteristic UUID] isEqual:[CBUUID UUIDWithString:kSimpleBLEPeripheralReadCharacteristicUUIDString]] ) {
                    
                    // And START getting notifications from it
                    [servicePeripheral setNotifyValue:YES forCharacteristic:characteristic];
                }
            }
        }
    }
}
- (NSData *) readValue
{
	if (readCharacteristic) {
        return [readCharacteristic value];
    }
    return nil;
}
- (void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
	if (peripheral != servicePeripheral) {
		NSLog(@"Wrong peripheral\n");
		return ;
	}
    if ([error code] != 0) {
		NSLog(@"Error %@\n", error);
		return ;
	}
    /* Temperature change */
    if ([[characteristic UUID] isEqual:readCharacteristicUUID]) {
        [peripheralDelegate peripheralDidReadValue:self value:[readCharacteristic value]];
        return;
    }
    if ([characteristic.UUID isEqual:writeCharacteristicUUID]) {
        [peripheralDelegate peripheralDidReadValue:self value:[writeCharacteristic value]];
    }
}

- (void) peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    /* When a write occurs, need to set off a re-read of the local CBCharacteristic to update its value */
    NSLog(@"write error = %@",[error description]);
    [peripheral readValueForCharacteristic:characteristic];
    
}

#pragma mark - 写数据
- (void)writeValue:(NSData *)data{
    if (!data) {
        NSLog(@"data == nil");
		return ;
    }
    
    if (!servicePeripheral) {
        NSLog(@"Not connected to a peripheral");
		return ;
    }
    
    if (!writeCharacteristic) {
        NSLog(@"%@ No valid write characteristic", writeCharacteristic);
        return;
    }
    
    [servicePeripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithResponse];
}
@end
