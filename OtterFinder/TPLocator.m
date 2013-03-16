//
//  TPLocator.m
//  OtterFinder
//
//  Created by Tim on 16/03/2013.
//  Copyright (c) 2013 Charismatic Megafauna Ltd. All rights reserved.
//

#import "TPLocator.h"

@implementation TPLocator

+ (TPLocator *)sharedLocator {
    
    static TPLocator *_sharedLocator = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedLocator = [[TPLocator alloc] init];
    });
    
    return _sharedLocator;
    
}

@end
