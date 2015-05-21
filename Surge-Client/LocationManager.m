//
//  LocationManager.m
//  Surge-Client
//
//  Created by Dustin Guerrero on 4/28/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager()

@property (strong, nonatomic) CLLocationManager* manager;
@property (strong, nonatomic) NSMutableArray *observers;

@end

@implementation LocationManager
static int errorCount = 0;
#define MAX_LOCATION_ERROR 3

+ (LocationManager*) sharedInstance {
  static LocationManager *sharedInstance = nil;
  static dispatch_once_t token;
  dispatch_once(&token, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

- (instancetype) init {
  self = [super init];
  if(self) {
    
    //Must check authorizationStatus before initiating a CLLocationManager
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status != kCLAuthorizationStatusRestricted && status != kCLAuthorizationStatusDenied) {
      _manager = [[CLLocationManager alloc] init];
      _manager.delegate = self;
      _manager.desiredAccuracy = kCLLocationAccuracyBest;
      [_manager startUpdatingLocation];
    }
    if (status == kCLAuthorizationStatusNotDetermined) {
      //Must check if selector exists before messaging it
      if ([_manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_manager requestWhenInUseAuthorization];
      }
    }
    
    _observers = [[NSMutableArray alloc] init];
  }
  return self;
}


- (void) addLocationManagerDelegate:(id<LocationManagerDelegate>)delegate {
  if (![self.observers containsObject:delegate]) {
    [self.observers addObject:delegate];
  }
  [self.manager startUpdatingLocation];
}

- (void) removeLocationManagerDelegate:(id<LocationManagerDelegate>)delegate {
  if ([self.observers containsObject:delegate]) {
    [self.observers removeObject:delegate];
  }
  
}

- (void) update {
  [self.manager startUpdatingLocation];
}

#pragma mark - Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
  [self.manager stopUpdatingLocation];
  _lastLocation = locations.lastObject;
  MKCoordinateRegion region = MKCoordinateRegionMake(_lastLocation.coordinate, MKCoordinateSpanMake(0.00725, 0.00725));
  for(id<LocationManagerDelegate> observer in self.observers) {
    if (observer) {
      [[observer mapViewToUpdateOnNewLocation] setRegion: region animated: false];
    }
  }
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
  errorCount += 1;
  if(errorCount >= MAX_LOCATION_ERROR) {
    [self.manager stopUpdatingLocation];
    errorCount = 0;
  }
}

@end