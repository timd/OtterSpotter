//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "NSObject+KiwiSpyAdditions.h"

#import "KWCaptureSpy.h"
#import "KWMessagePattern.h"
#import "NSObject+KiwiStubAdditions.h"

@implementation NSObject (KiwiSpyAdditions)

- (KWCaptureSpy *)captureArgument:(SEL)selector atIndex:(NSUInteger)index {
    KWCaptureSpy *spy = [[[KWCaptureSpy alloc] initWithArgumentIndex:index] autorelease];
    KWMessagePattern *pattern = [[[KWMessagePattern alloc] initWithSelector:selector] autorelease];
    [self addMessageSpy:spy forMessagePattern:pattern];
    return spy;
}

@end
