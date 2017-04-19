//
//  ViewController.m
//  CurrentLoactionOBJ
//
//  Created by Sri Kalyan Ganja on 4/18/17.
//  Copyright © 2017 KLYN. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController {
    
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    
}

@synthesize latitudeLabel;
@synthesize longitudeLabel;
@synthesize addressLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)getCurrentLocation:(id)sender {
    
    if ([CLLocationManager locationServicesEnabled]) {
        [self startStandardUpdates];
    } else {
        NSLog(@"Location services are not enabled by the user");
    }
}

- (void) startStandardUpdates {
        
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    
    locationManager.delegate = self;
    
    [locationManager requestWhenInUseAuthorization];
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 500; // meters
    
    [locationManager startUpdatingLocation];
    
}

#pragma mark - CLLocationMangerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"didFailWithError: %@", error);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Failed to get location" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    // The objects in the array are organized in the order in which they occurred.
    // Therefore, the most recent location update is at the end of the array.
    CLLocation *currentLocation = [locations lastObject];
    
    NSLog(@"didUpdateToLocation: %@",currentLocation);
    
    if (currentLocation != nil) {
        latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
    }
    
    // Stop Location Manager
    [locationManager stopUpdatingLocation];
    
    // Reverse Geocoding
    NSLog(@"Resolving the address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        
        if (error == nil && [placemarks count]>0) {
            placemark = [placemarks lastObject];
            addressLabel.text = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                 placemark.subThoroughfare, placemark.thoroughfare,
                                 placemark.postalCode, placemark.locality,
                                 placemark.administrativeArea,
                                 placemark.country];
            
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    }];
}


@end
