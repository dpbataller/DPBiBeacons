//
//  DPBViewController.h
//  iBeacons-Demo
//
//  Created by David Pedrosa Bataller on 24/03/14.
//  Copyright (c) 2014 David Pedrosa Bataller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DPBViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) CLBeaconRegion    *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UILabel  *beaconState;
@property (strong, nonatomic) IBOutlet UILabel  *beaconUUID;
@property (strong, nonatomic) IBOutlet UILabel  *beaconMajor;
@property (strong, nonatomic) IBOutlet UILabel  *beaconMinor;
@property (strong, nonatomic) IBOutlet UILabel  *beaconDistance;
@property (strong, nonatomic) IBOutlet UILabel *beaconProximity;

- (void)createBeaconRegionWithUUID:(NSString *)uuid;

@end
