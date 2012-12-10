//
//  MapViewController.m
//  InnovationAwards
//
//  Created by Mark Harris on 12/9/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import "MapViewController.h"
#import "MapAnnotation.h"

@interface MapViewController ()

@end

@implementation MapViewController

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
	// Do any additional setup after loading the view.
    
    // add annotations
    CLLocationCoordinate2D ccLocation;
    CLLocationCoordinate2D tcLocation;
    
    ccLocation.latitude = 39.9716;
    ccLocation.longitude = -83.0005;
    tcLocation.latitude = 39.9981;
    tcLocation.longitude = -83.04161;
    
    MKPointAnnotation *mkp = [[MKPointAnnotation alloc] init];
    mkp.title = @"TechColumbus";
    mkp.subtitle = @"1275 Kinnear Rd.";
    mkp.coordinate = tcLocation;
    
    MKPointAnnotation *mkpCC = [[MKPointAnnotation alloc] init];
    mkpCC.title = @"Innovation Awards - Convention Center";
    mkpCC.subtitle = @"400 N. High St., Battelle Hall";
    mkpCC.coordinate = ccLocation;
    
    [self.mapView addAnnotation:mkp];
    [self.mapView addAnnotation:mkpCC];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    CLLocationCoordinate2D columbus;
    columbus.latitude = 39.961100;
    columbus.longitude = -82.998900;
    [self.mapView setRegion:MKCoordinateRegionMake(columbus, MKCoordinateSpanMake(0.030f, 0.030f)) animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
