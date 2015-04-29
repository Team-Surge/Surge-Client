//
//  LocationManager.h
//  Surge-Client
//
//  Created by Dustin Guerrero on 4/28/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreLocation/CoreLocation.h"

@protocol LocationManagerDelegate

- (void)locationManagerDidUpdateLocation:(CLLocation *)location;

@end

@interface LocationManager : NSObject<CLLocationManagerDelegate>
@property (strong,nonatomic) CLLocation *lastLocation;

+ (LocationManager *)sharedInstance;
- (void) addLocationManagerDelegate:(id<LocationManagerDelegate>) delegate;
- (void) removeLocationManagerDelegate:(id<LocationManagerDelegate>) delegate;

@end