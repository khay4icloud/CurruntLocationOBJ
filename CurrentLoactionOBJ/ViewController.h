//
//  ViewController.h
//  CurrentLoactionOBJ
//
//  Created by Sri Kalyan Ganja on 4/18/17.
//  Copyright © 2017 KLYN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
- (IBAction)getCurrentLocation:(id)sender;

@end

