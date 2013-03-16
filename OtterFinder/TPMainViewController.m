//
//  TPMainViewController.m
//  OtterFinder
//
//  Created by Tim on 16/03/2013.
//  Copyright (c) 2013 Charismatic Megafauna Ltd. All rights reserved.
//

#import "TPMainViewController.h"
#import "TPLocator.h"
#import "OtterClient.h"
#import "TPDetailOverlay.h"
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"

#import "OtterPin.h"

@interface TPMainViewController ()

@property (nonatomic, strong) CLLocationManager *locManager;
@property (nonatomic, strong) OtterClient *otterClient;
@property (nonatomic) BOOL isLocating;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) TPDetailOverlay *detailOverlay;

@end

@implementation TPMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.locManager = [[CLLocationManager alloc] init];
    [self.locManager setDelegate:self];
    [self.locManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    self.otterClient = [OtterClient sharedClient];
    [self.otterClient setDelegate:self];
    [self.mapView setShowsUserLocation:YES];

    [self didTapLocateButton:nil];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark CLLocationManager delegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation  {
    
    // Centre map on new location
    CLLocationCoordinate2D newLoc = newLocation.coordinate;
    [self.mapView setCenterCoordinate:newLoc animated:YES];
    
}

#pragma mark -
#pragma mark MKMapView delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    static NSString* myIdentifier = @"myIdentifier";
    MKAnnotationView* otterPin = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:myIdentifier];
    
    if (!otterPin)
    {
        otterPin = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:myIdentifier];
        otterPin.image = [UIImage imageNamed:@"otter"];

    }
    return otterPin;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *aV;
    
    for (aV in views) {
        
        // Don't pin drop if annotation is user location
        if ([aV.annotation isKindOfClass:[MKUserLocation class]]) {
            continue;
        }
        
        // Check if current annotation is inside visible map rect, else go to next one
        MKMapPoint point =  MKMapPointForCoordinate(aV.annotation.coordinate);
        if (!MKMapRectContainsPoint(self.mapView.visibleMapRect, point)) {
            continue;
        }
        
        CGRect endFrame = aV.frame;
        
        // Move annotation out of view
        aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - self.view.frame.size.height, aV.frame.size.width, aV.frame.size.height);
        
        // Animate drop
        [UIView animateWithDuration:0.5 delay:0.04*[views indexOfObject:aV] options: UIViewAnimationOptionCurveLinear animations:^{
            
            aV.frame = endFrame;
            
            // Animate squash
        }completion:^(BOOL finished){
            if (finished) {
                [UIView animateWithDuration:0.05 animations:^{
                    aV.transform = CGAffineTransformMakeScale(1.0, 0.8);
                    
                }completion:^(BOOL finished){
                    if (finished) {
                        [UIView animateWithDuration:0.1 animations:^{
                            aV.transform = CGAffineTransformIdentity;
                        }];
                    }
                }];
            }
        }];
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"did tap otter");
    
    if (self.detailOverlay) {
        [self.detailOverlay removeFromSuperview];
    }
    
    if ([view.annotation isKindOfClass:[MKUserLocation class]]) {
        return;
    }
    
    OtterPin *otterPin = (OtterPin *)view.annotation;
    NSLog(@"otterpin = %@", otterPin.otterDictionary);
    
    self.detailOverlay = [TPDetailOverlay viewWithNibName:@"DetailOverlay" owner:self];
    self.detailOverlay.layer.cornerRadius = 5;
    self.detailOverlay.layer.masksToBounds = YES;
    
    CGPoint p = [self.mapView convertCoordinate:view.annotation.coordinate toPointToView:self.mapView];
    CGRect frame = CGRectMake(p.x, p.y, self.detailOverlay.frame.size.width, self.detailOverlay.frame.size.height);
    self.detailOverlay.frame = frame;
    [self.detailOverlay setAlpha:0.0f];
    [self.detailOverlay.locationLabel setText:[otterPin.otterDictionary objectForKey:@"siteName"]];

    [self.mapView addSubview:self.detailOverlay];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.detailOverlay setAlpha:1.0f];
    } completion:nil];
    
}

#pragma mark -
#pragma mark Interaction methods

- (IBAction)didTapLocateButton:(id)sender {
    
    if (self.isLocating) {
        [self.locManager stopUpdatingLocation];
        self.isLocating = NO;
    } else {
        [self.locManager startUpdatingLocation];

        MKCoordinateRegion region;
        region.center = self.mapView.userLocation.coordinate;
        
        MKCoordinateSpan span;
        span.latitudeDelta  = 0.5; // Change these values to change the zoom
        span.longitudeDelta = 0.5;
        region.span = span;
        
        [self.mapView setRegion:region animated:YES];
        
        self.isLocating = YES;
    }
    
}

- (IBAction)didTapOtterButton:(id)sender {
    
    for (id annotation in self.mapView.annotations) {
        if (annotation != self.mapView.userLocation) {
            [self.mapView removeAnnotation:annotation];
        }
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setLabelText:@"Fetching otters..."];
    
    //To calculate the search bounds...
    //First we need to calculate the corners of the map so we get the points
    CGPoint nePoint = CGPointMake(self.mapView.bounds.origin.x + self.mapView.bounds.size.width, self.mapView.bounds.origin.y);
    CGPoint swPoint = CGPointMake((self.mapView.bounds.origin.x), (self.mapView.bounds.origin.y + self.mapView.bounds.size.height));
    
    //Then transform those point into lat,lng values
    CLLocationCoordinate2D neCoord;
    neCoord = [self.mapView convertPoint:nePoint toCoordinateFromView:self.mapView];
    
    CLLocationCoordinate2D swCoord;
    swCoord = [self.mapView convertPoint:swPoint toCoordinateFromView:self.mapView];
    
    NSLog(@"neCord = %f , %f", neCoord.latitude, neCoord.longitude);
    NSLog(@"swCord = %f, %f", swCoord.latitude, swCoord.longitude);
    
    [self.otterClient getOtterDataForUpperCoord:neCoord andLowerCoord:swCoord];
    
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"Region did change");
    
    if (self.detailOverlay) {
        [UIView animateWithDuration:0.25f animations:^{
            [self.detailOverlay setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self.detailOverlay removeFromSuperview];
        }];
    }
}

#pragma mark -
#pragma mark OtterClientProtocol methods

-(void)plotOtterDataFromJsonDictionary:(NSDictionary *)jsonDictionary {

    // Grab otters array
    NSArray *otters = [jsonDictionary objectForKey:@"otters"];
    
    for (NSDictionary *otterDict in otters) {
        
        NSString *gridRefLatString = [otterDict objectForKey:@"lat"];
        NSString *gridRefLonString = [otterDict objectForKey:@"long"];
        
        double gridRefLat = [gridRefLatString doubleValue];
        double gridRefLon = [gridRefLonString doubleValue];
        
        CLLocationCoordinate2D coord;
        coord.latitude = (CLLocationDegrees)gridRefLat;
        coord.longitude = (CLLocationDegrees)gridRefLon;
        
        NSLog(@"Otter: %f , %f", coord.latitude, coord.longitude);
        
        OtterPin *otterPin = [[OtterPin alloc] initWithCoordinates:coord placeName:@"foo" description:@"bar"];
        [otterPin setOtterDictionary:otterDict];
        [self.mapView addAnnotation:otterPin];
        
    }
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

}

-(void)handleOtterDataErrorWithError:(NSError *)error {
    NSLog(@"Otter error receieved: %@", error);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something went wrong" message:@"Something has otterly failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
}

@end
