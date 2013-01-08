//
//  MapViewController.h
//  InnovationAwards
//
//  Created by Mark Harris on 12/9/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController<MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, assign) CLLocationCoordinate2D conventionCenter;
@property (nonatomic, assign) CLLocationCoordinate2D techColumbus;
@property (nonatomic, assign) CLLocationCoordinate2D columbus;

@property MKPointAnnotation *mkpCC;

@end
