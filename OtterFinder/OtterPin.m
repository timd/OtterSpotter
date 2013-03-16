//
//  OtterPin.m
//  OtterFinder
//
//  Created by Tim on 16/03/2013.
//  Copyright (c) 2013 Charismatic Megafauna Ltd. All rights reserved.
//

#import "OtterPin.h"

@interface OtterPin()

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite) NSString* title;
@property (nonatomic, readwrite) NSString* subtitle;

@end

@implementation OtterPin

- (id)initWithCoordinates:(CLLocationCoordinate2D)location
                placeName:(NSString *)placeName
              description:(NSString *)description;
{
    self = [super init];
    if (self)
    {
        _coordinate = location;
        _title = placeName;
        _subtitle = description;
    }
    
    return self;
}

@end
