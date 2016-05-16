



#import "LeDiscovery.h"


@interface LeDiscovery () <CBCentralManagerDelegate, CBPeripheralDelegate> {
	CBCentralManager    *centralManager;
	BOOL				pendingInit;
}
@end


@implementation LeDiscovery
@synthesize strDeviceType = _strDeviceType;
@synthesize foundPeripherals;
@synthesize connectedServices;
@synthesize peripheralDelegate;
@synthesize bundlePeripherals = _bundlePeripherals;
@synthesize dicArray;


#pragma mark -
#pragma mark Init
/****************************************************************************/
/*									Init									*/
/****************************************************************************/
+ (id) sharedInstance
{
	static LeDiscovery	*this	= nil;

	if (!this)
		this = [[LeDiscovery alloc] init];

	return this;
}


- (id) init
{
    self = [super init];
    if (self) {
        previousState = -1;
		pendingInit = YES;
		centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];

		foundPeripherals = [[NSMutableArray alloc] init];
		connectedServices = [[NSMutableArray alloc] init];
        dicArray = [NSMutableArray array];
        self.bundlePeripherals = [NSMutableDictionary dictionaryWithCapacity:40];
        
        
	}
    return self;
}



#pragma mark Discovery
/****************************************************************************/
/*								Discovery                                   */
/****************************************************************************/
//扫描设备
- (void) startScanningForUUIDString:(NSString *)uuidString
{
	NSMutableArray *uuidArray = nil;
    if (uuidString)
    {
        uuidArray = [NSMutableArray arrayWithObjects:[CBUUID UUIDWithString:uuidString], nil];
    }
	NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];

	[centralManager scanForPeripheralsWithServices:uuidArray options:options];
}

//停止扫描设备
- (void) stopScanning
{
	[centralManager stopScan];
}

#pragma mark Connection/Disconnection
/****************************************************************************/
/*						Connection/Disconnection                            */
/****************************************************************************/
//发起连接设备请求
- (void) connectPeripheral:(CBPeripheral*)peripheral
{
	if (![peripheral isConnected])
    {
		[centralManager connectPeripheral:peripheral options:nil];
	}
}

//断开与设备的连接
- (void) disconnectPeripheral:(CBPeripheral*)peripheral
{
    if (peripheral == nil)
    {
        return;
    }
	[centralManager cancelPeripheralConnection:peripheral];
}

#pragma mark - CBCentralManagerDelegate

//扫描到设备后的回调函数
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"数据 %@ 1-- %@ 2-- %@ 3-- %d ",advertisementData,peripheral,central,RSSI);
    
	if (![foundPeripherals containsObject:peripheral])
    {
		[foundPeripherals addObject:peripheral];
    }
    if (peripheral)
    {
        if ([peripheralDelegate respondsToSelector:@selector(serviceDidDiscoverPeripheral:advertisementData:)])
        {
            [peripheralDelegate serviceDidDiscoverPeripheral:peripheral advertisementData:advertisementData];
        }
    }
}

- (void) centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
	/* Add to list. */
	for (CBPeripheral *peripheral in peripherals)
    {
        if (![foundPeripherals containsObject:peripheral]) {
            [foundPeripherals addObject:peripheral];
        }
        [self disconnectPeripheral:peripheral];
        if ([peripheralDelegate respondsToSelector:@selector(serviceDidDiscoverPeripheral:advertisementData:)]) {
            [peripheralDelegate serviceDidDiscoverPeripheral:peripheral advertisementData:nil];
        }
		//[central connectPeripheral:peripheral options:nil];
	}
}


- (void) centralManager:(CBCentralManager *)central didRetrievePeripheral:(CBPeripheral *)peripheral
{
	//[central connectPeripheral:peripheral options:nil];
    if (![foundPeripherals containsObject:peripheral]) {
		[foundPeripherals addObject:peripheral];
    }
    [self disconnectPeripheral:peripheral];
    if ([peripheralDelegate respondsToSelector:@selector(serviceDidDiscoverPeripheral:advertisementData:)]) {
        [peripheralDelegate serviceDidDiscoverPeripheral:peripheral advertisementData:nil];
    }
    
}


- (void) centralManager:(CBCentralManager *)central didFailToRetrievePeripheralForUUID:(CFUUIDRef)UUID error:(NSError *)error
{
	/* Nuke from plist. */
}

//连接上设备回调函数
- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
	/* Create a service instance. */
	LePeripheralService	*service = [[LePeripheralService alloc] initWithPeripheral:peripheral controller:peripheralDelegate];
	[service start];
    service.strDeviceTag = [NSString stringWithFormat:@"%@", self.strDeviceType];
	if (![connectedServices containsObject:service])
    {
        [connectedServices addObject:service];
    }
	if ([foundPeripherals containsObject:peripheral])
    {
       [foundPeripherals removeObject:peripheral];
    }

    if ([peripheralDelegate respondsToSelector:@selector(serviceDidConnect:)]) {
        [peripheralDelegate serviceDidConnect:service];
    }
    
}

//连接失败回调函数
- (void) centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Attempted connection to peripheral %@ failed: %@", [peripheral name], [error localizedDescription]);
    if ([peripheralDelegate respondsToSelector:@selector(serviceDidFailToConnect:)])
    {
        [peripheralDelegate serviceDidFailToConnect:peripheral];
    }
    
}

//断开连接回调函数
- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
	for (LePeripheralService *service in connectedServices)
    {
		if ([service peripheral] == peripheral)
        {
			[connectedServices removeObject:service];
            if ([peripheralDelegate respondsToSelector:@selector(serviceDidDisconnect:)]) {
                [peripheralDelegate serviceDidDisconnect:service];
            }
			break;
		}
	}
}


- (void) clearDevices
{
    LePeripheralService	*service;
    [foundPeripherals removeAllObjects];
    
    for (service in connectedServices) {
        [service reset];
    }
    [connectedServices removeAllObjects];
}


- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"蓝牙状态更新 = %d",[centralManager state]);
    
	switch ([centralManager state]) {
		case CBCentralManagerStatePoweredOff:
		{
            [self clearDevices];
            
			/* Tell user to power ON BT for functionality, but not on first run - the Framework will alert in that instance. */
//            if (previousState != -1) {
//                //[discoveryDelegate discoveryStatePoweredOff];
//            }
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
			pendingInit = NO;
			//[self loadSavedDevices];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
            {
                [centralManager retrieveConnectedPeripherals];
            }
            else
            {
                NSArray *peripherals = [centralManager retrieveConnectedPeripheralsWithServices:[NSArray arrayWithObjects:[CBUUID UUIDWithString:kSimpleBLEPeripheralServicesUUIDString], nil]];
                for (CBPeripheral *peripheral in peripherals)
                {
                    if (![foundPeripherals containsObject:peripheral])
                    {
                        [foundPeripherals addObject:peripheral];
                    }
                    [self disconnectPeripheral:peripheral];
                    if ([peripheralDelegate respondsToSelector:@selector(serviceDidDiscoverPeripheral:advertisementData:)])
                    {
                        [peripheralDelegate serviceDidDiscoverPeripheral:peripheral advertisementData:nil];
                    }
                }
            }
			
			break;
		}
            
		case CBCentralManagerStateResetting:
		{
			[self clearDevices];
            
			pendingInit = YES;
			break;
		}
        default:
            break;
	}
    if ([peripheralDelegate respondsToSelector:@selector(centralManagerDidUpdateState:)])
    {
        [peripheralDelegate centralManagerDidUpdateState:[centralManager state]];
    }
    
    previousState = [centralManager state];
}
@end
