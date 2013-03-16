//
//  TPDetailOverlay.m
//  OtterFinder
//
//  Created by Tim on 16/03/2013.
//  Copyright (c) 2013 Charismatic Megafauna Ltd. All rights reserved.
//

#import "TPDetailOverlay.h"

@interface TPDetailOverlay()


@end

@implementation TPDetailOverlay

+(TPDetailOverlay *) viewWithNibName:(NSString *)nibName owner:(NSObject *)owner {
    
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    id customView = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[self class]]) {
            customView = nibItem;
            break;
        }
    }
    return customView;
}

- (IBAction)didTapOverlayButton:(id)sender {

    [UIView animateWithDuration:0.5 animations:^{
        [self setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
