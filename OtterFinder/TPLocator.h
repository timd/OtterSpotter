//
//  TPLocator.h
//  OtterFinder
//
//  Created by Tim on 16/03/2013.
//  Copyright (c) 2013 Charismatic Megafauna Ltd. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface TPLocator : CLLocation

+(TPLocator *)sharedLocator;

@end
