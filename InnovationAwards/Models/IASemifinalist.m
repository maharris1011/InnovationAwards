//
//  IASemifinalist.m
//  InnovationAwards
//
//  Created by Mark Harris on 1/3/13.
//  Copyright (c) 2013 TechColumbus. All rights reserved.
//

#import "IASemifinalist.h"
#import "TFHppleElement+IDSearch.h"

@implementation IASemifinalist

@synthesize company = _company;
@synthesize contact = _contact;
@synthesize site_url = _site_url;
@synthesize bio  = _bio;
@synthesize linkedin = _linkedin;
@synthesize facebook = _facebook;
@synthesize twitter = _twitter;
@synthesize image_path = _image_path;

- (id)initWithFake:(int)n
{
    if (self = [super init]) {
        _company = [NSString stringWithFormat:@"company %d", n];
        _contact = [NSString stringWithFormat:@"contact %d", n];
        _site_url = [NSString stringWithFormat:@"site_url %d", n];
        _bio = [NSString stringWithFormat:@"bio %d", n];
        _linkedin = [NSString stringWithFormat:@"linkedin %d", n];
        _facebook = [NSString stringWithFormat:@"facebook %d", n];
        _twitter = [NSString stringWithFormat:@"twitter %d", n];
        _image_path = [NSString stringWithFormat:@"image_path %d", n];
    }
    return self;
}

- (id)initWithHTML:(TFHppleElement *)e
{
    if (self = [super init])
    {
        // walk through the element, filling in the information
        TFHppleElement *companyElement = [e firstChildWithId:@"sf_company"];
        _company = [[companyElement firstChild] content];
        
        _contact = [[e firstChildWithId:@"sf_contact"] firstChild].content;
        _site_url = [[e firstChildWithId:@"sf_website"].attributes objectForKey:@"href"];
        
        
        _bio = [[e firstChildWithId:@"sf_bio"] firstChild].content;
        _linkedin = [[e firstChildWithId:@"sf_linkedin"].attributes objectForKey:@"href"];
        _facebook = [[e firstChildWithId:@"sf_facebook"].attributes objectForKey:@"href"];
        _twitter = [[e firstChildWithId:@"sf_twitter"].attributes objectForKey:@"href"];
        
        _image_path = [[e firstChildWithId:@"sf_photo"].attributes objectForKey:@"src"];
    }
    return self;
}

@end
