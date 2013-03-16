//
//  OtterClient.m
//  OtterFinder
//
//  Created by Tim on 16/03/2013.
//  Copyright (c) 2013 Charismatic Megafauna Ltd. All rights reserved.
//

#import "OtterClient.h"
#import "AFNetworking.h"
#import "OHHTTPStubs.h"

@implementation OtterClient

+ (OtterClient *)sharedClient {
    
    static OtterClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[OtterClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseApiUrl]];
    });
    
    return _sharedClient;
    
}

-(void)stubNetworkCalls {
    [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse*(NSURLRequest *request, BOOL onlyCheck) {
        return [OHHTTPStubsResponse responseWithFile:@"test.json" contentType:@"text/json" responseTime:0.5];
    }];
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setDefaultHeader:@"Content-Type" value:@"application/json"];
    [self setParameterEncoding:AFJSONParameterEncoding];
    
    if (kStubNetworkCalls) {
        [self stubNetworkCalls];
    }
    
    return self;
}

-(void)getOtterDataForUpperCoord:(CLLocationCoordinate2D)upperCoord
                   andLowerCoord:(CLLocationCoordinate2D)lowerCoord {

    double upperLat = upperCoord.latitude;
    double upperLon = upperCoord.longitude;
    double lowerLat = lowerCoord.latitude;
    double lowerLon = lowerCoord.longitude;
    
    //  GET http://damp-sierra-3977.herokuapp.com/otters?topLat=12.34&topLong=12.34&bottomLat=12.34&bottomLong=12.34
    
    NSString *queryString = [NSString stringWithFormat:@"?topLat=%f&topLong=%f&bottomLat=%f&bottomLong=%f", upperLat, upperLon, lowerLat, lowerLon];
    NSString *urlString = [NSString stringWithFormat:@"%@/otters%@", kBaseApiUrl, queryString];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // SUCCESS
        NSLog(@"Received %@", [JSON class]);
        [self.delegate plotOtterDataFromJsonDictionary:JSON];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // FAILURE
        NSLog(@"Error in OtterClient: %@", error);
        [self.delegate handleOtterDataErrorWithError:error];
    }];
    
    [operation setShouldExecuteAsBackgroundTaskWithExpirationHandler:nil];
    
    [operation start];
    
}

@end
