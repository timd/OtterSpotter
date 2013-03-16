//
//  OtterClient.h
//  OtterFinder
//
//  Created by Tim on 16/03/2013.
//  Copyright (c) 2013 Charismatic Megafauna Ltd. All rights reserved.
//

#import "AFHTTPClient.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "OtterClientProtocol.h"

@interface OtterClient : AFHTTPClient

@property (nonatomic, weak) id <OtterClientProtocol> delegate;

+(OtterClient *)sharedClient;
-(void)getOtterDataForUpperCoord:(CLLocationCoordinate2D)upperCoord
                   andLowerCoord:(CLLocationCoordinate2D)lowerCoord;

@end
