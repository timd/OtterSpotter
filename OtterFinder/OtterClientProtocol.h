//
//  OtterClientProtocol.h
//  OtterFinder
//
//  Created by Tim on 16/03/2013.
//  Copyright (c) 2013 Charismatic Megafauna Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OtterClientProtocol <NSObject>

-(void)plotOtterDataFromJsonDictionary:(NSDictionary *)jsonDictionary;
-(void)handleOtterDataErrorWithError:(NSError *)error;

@end
