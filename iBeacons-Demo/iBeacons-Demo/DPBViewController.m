//
//  DPBViewController.m
//  iBeacons-Demo
//
//  Created by David Pedrosa Bataller on 24/03/14.
//  Copyright (c) 2014 David Pedrosa Bataller. All rights reserved.
//

#import "DPBViewController.h"

@interface DPBViewController ()

@end

@implementation DPBViewController

#pragma mark - Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createBeaconRegionWithUUID:@"53445830-3584-11E3-AA6E-0800200C9A66"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
- (void)createBeaconRegionWithUUID:(NSString *)uuid {
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    NSUUID *beaconUUID = [[NSUUID alloc] initWithUUIDString:uuid];
    
    _beaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:beaconUUID identifier:@"com.dpbataller.demo"];
    _beaconRegion.notifyEntryStateOnDisplay = YES;
    
    /*
     * Cuando CLLocationManager detecte que hemos entrado o salido de una región llamará a los siguientes métodos de CLLocationManagerDelegate:
     * locationManager:didEnterRegion:
     * locationManager:didExitRegion:
     * locationManager:didDetermineState:forRegion:
     */
    
    if ([CLLocationManager isMonitoringAvailableForClass:[_beaconRegion class]]) {
        NSLog(@"Beacon Monitoring start right now...");
        [_locationManager startMonitoringForRegion:_beaconRegion];
        
    } else {
        NSLog(@"Beacon monitoring not available. Most probably this device doesn't support Bluetooth 4.0");
    }
    
}

#pragma mark - Beacon Monitoring

- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion*)region
{
    // Hemos entrado en una región, ahora buscamos los beacons
    [_locationManager startRangingBeaconsInRegion:self.beaconRegion];
    _beaconState.text = @"Buscando Beacons...";
}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion*)region
{
    // Hemos salido de la región
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    _beaconState.text = @"No se encuentran beacons";
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if (state == CLRegionStateOutside) {
        [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
        NSLog(@"Estás fuera de una zona con beacons");
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = @"Estás fuera de una zona con beacons";
        notification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        
    } else {
        if ([CLLocationManager isRangingAvailable]) {
            NSLog(@"Beeacon ranging start right now...");
            [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
            
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.alertBody = @"Estás dentro de una zona con beacons";
            notification.soundName = UILocalNotificationDefaultSoundName;
            [[UIApplication sharedApplication] presentLocalNotificationNow:notification];

        } else {
            NSLog(@"Beacon ranging not available. Most probably this device doesn't support Bluetooth 4.0");
        }
    }
}

#pragma mark - Beacon Ranging
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if ([beacons count] > 0) {
        CLBeacon *closestBeacon = [beacons firstObject];
        NSLog(@"%@",closestBeacon);
        _beaconState.text       = @"Beacon encontrado!";
        _beaconUUID.text        = [NSString stringWithFormat:@"%@",[closestBeacon.proximityUUID UUIDString]];
        _beaconMajor.text       = [NSString stringWithFormat:@"%ld",(long)closestBeacon.major.integerValue];
        _beaconMinor.text       = [NSString stringWithFormat:@"%ld",(long)closestBeacon.minor.integerValue];
        _beaconProximity.text   = [NSString stringWithFormat:@"%ld",(long)closestBeacon.proximity];
        
        switch (closestBeacon.proximity) {
            case CLProximityImmediate:
                NSLog(@"Beacon %@ located immediately close to you with Major %ld and Minor: %ld", [closestBeacon.proximityUUID UUIDString], (long)closestBeacon.major.integerValue, (long)closestBeacon.minor.integerValue);
                
                _beaconDistance.text = @"Inmediata";
                [self.view setBackgroundColor:[UIColor redColor]];
                break;
                
            case CLProximityNear:
                NSLog(@"Beacon %@ located near you with Major %ld and Minor: %ld", [closestBeacon.proximityUUID UUIDString], (long)closestBeacon.major.integerValue, (long)closestBeacon.minor.integerValue);
                _beaconDistance.text = @"Cercana";
                [self.view setBackgroundColor:[UIColor orangeColor]];
                
                break;
            case CLProximityFar:
                NSLog(@"Beacon %@ located far from you with Major %ld and Minor: %ld", [closestBeacon.proximityUUID UUIDString], (long)closestBeacon.major.integerValue, (long)closestBeacon.minor.integerValue);
                _beaconDistance.text = @"Lejana";
                [self.view setBackgroundColor:[UIColor blueColor]];

                break;
            default:
                NSLog(@"Beacon %@ has unknown proximity with Major %ld and Minor: %ld", [closestBeacon.proximityUUID UUIDString], (long)closestBeacon.major.integerValue, (long)closestBeacon.minor.integerValue);
                _beaconDistance.text = @"Desconocida";
                
                break;
        }
    }
}

@end
