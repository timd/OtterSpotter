//
//  TPDetailOverlay.h
//  OtterFinder
//
//  Created by Tim on 16/03/2013.
//  Copyright (c) 2013 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPDetailOverlay : UIView

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

+(TPDetailOverlay *) viewWithNibName:(NSString *)nibName owner:(NSObject *)owner;
    
@end
