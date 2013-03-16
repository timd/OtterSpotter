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

@interface TPMainViewController ()

@property (nonatomic, strong) CLLocationManager *locManager;
@property (nonatomic, strong) OtterClient *otterClient;
@property (nonatomic) BOOL isLocating;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

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
    [self.mapView showsUserLocation];
    
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
#pragma mark Interaction methods

- (IBAction)didTapLocateButton:(id)sender {
    
    if (self.isLocating) {
        [self.locManager stopUpdatingLocation];
        self.isLocating = NO;
    } else {
        [self.locManager startUpdatingLocation];
        self.isLocating = YES;
    }
    
}

- (IBAction)didTapOtterButton:(id)sender {
    
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
}

#pragma mark -
#pragma mark OtterClientProtocol methods

-(void)plotOtterDataFromJsonDictionary:(NSDictionary *)jsonDictionary {

    NSLog(@"jsonDictionary = %@", jsonDictionary);

}

-(void)handleOtterDataErrorWithError:(NSError *)error {
    NSLog("Otter error receieved: %@", error);
}

@end
