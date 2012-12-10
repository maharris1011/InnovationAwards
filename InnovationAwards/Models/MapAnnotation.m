//
//  MapAnnotation.m
//  InnovationAwards
//
//  Created by Mark Harris on 12/9/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation


@synthesize coordinate = _coordinate;
@synthesize title = _title;
@synthesize subtitle = _subtitle;

- (id) initWithCoordinate: (CLLocationCoordinate2D) aCoordinate
{
    if (self = [super init]) {
        _coordinate = aCoordinate;
        return self;
    }
    return nil;
}


@end
