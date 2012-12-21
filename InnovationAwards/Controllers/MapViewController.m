//
//  MapViewController.m
//  InnovationAwards
//
//  Created by Mark Harris on 12/9/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import "MapViewController.h"
#import "AppDelegate.h"

@interface MapViewController ()

@end



@implementation MapViewController

@synthesize conventionCenter = _conventionCenter;
@synthesize techColumbus = _techColumbus;
@synthesize columbus = _columbus;

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
    
    // add annotations
    self.conventionCenter = CLLocationCoordinate2DMake(39.9716, -83.0005);
    self.techColumbus = CLLocationCoordinate2DMake(39.9981, -83.04161);
    self.columbus = CLLocationCoordinate2DMake(39.961100, -82.998900);
    
    
    MKPointAnnotation *mkp = [[MKPointAnnotation alloc] init];
    mkp.title = @"TechColumbus";
    mkp.subtitle = @"1275 Kinnear Rd.";
    mkp.coordinate = self.techColumbus;
    
    MKPointAnnotation *mkpCC = [[MKPointAnnotation alloc] init];
    mkpCC.title = @"Innovation Awards - Convention Center";
    mkpCC.subtitle = @"400 N. High St., Battelle Hall";
    mkpCC.coordinate = self.conventionCenter;
    
    [self.mapView addAnnotation:mkp];
    [self.mapView addAnnotation:mkpCC];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.mapView setRegion:MKCoordinateRegionMake(self.columbus, MKCoordinateSpanMake(0.030f, 0.030f)) animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- MKMapViewDelegate methods
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    for (MKPinAnnotationView *mkaview in views) {
        if ([mkaview.annotation.title isEqualToString:@"Innovation Awards - Convention Center"])
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            mkaview.rightCalloutAccessoryView = button;
        }
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSString *url = nil;
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]])
    {
        // open google maps
        url = [NSString stringWithFormat:@"comgooglemaps://?q=Greater+Columbus+Convention+Center&center=%f,%f", self.conventionCenter.latitude, self.conventionCenter.longitude];
    }
    else
    {
        // open maps in safari
        url = [NSString stringWithFormat:@"http://maps.apple.com/?daddr=400+N.+High+St.,+Columbus,+Ohio,+43205&ll=%f,%f", self.conventionCenter.latitude, self.conventionCenter.longitude];
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
}


@end
