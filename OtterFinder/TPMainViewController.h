//
//  TPMainViewController.h
//  OtterFinder
//
//  Created by Tim on 16/03/2013.
//  Copyright (c) 2013 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "OtterClientProtocol.h"

@interface TPMainViewController : UIViewController <CLLocationManagerDelegate, OtterClientProtocol>

@end
