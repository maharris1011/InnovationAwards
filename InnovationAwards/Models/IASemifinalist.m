//
//  IASemifinalist.m
//  InnovationAwards
//
//  Created by Mark Harris on 1/3/13.
//  Copyright (c) 2013 TechColumbus. All rights reserved.
//
#import "AppDelegate.h"
#import "IASemifinalist.h"
#import "IACategory.h"
#import "TFHppleElement+IDSearch.h"

@implementation IASemifinalist

@synthesize company = _company;
@synthesize company_url_safe = _company_url_safe;
@synthesize contact = _contact;
@synthesize site_url = _site_url;
@synthesize bio  = _bio;
@synthesize linkedin = _linkedin;
@synthesize facebook = _facebook;
@synthesize twitter = _twitter;
@synthesize image_path = _image_path;
@synthesize isWinner = _isWinner;


- (NSString *)company_url_safe
{
    NSString *str = [self.company stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return str;
}

- (id)initWithFake:(int)n
{
    if (self = [super init]) {
        _company = [NSString stringWithFormat:@"Coming Soon..."];
        _contact = [NSString stringWithFormat:@""];
        _site_url = [NSString stringWithFormat:@""];
        _bio = [NSString stringWithFormat:@""];
        _linkedin = [NSString stringWithFormat:@""];
        _facebook = [NSString stringWithFormat:@""];
        _twitter = [NSString stringWithFormat:@""];
        _image_path = [NSString stringWithFormat:@""];
        _isWinner = FALSE;
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
        
        // peel out the content of each child of the <p id="sf_bio"> tag
        // have to do this to overcome the bug where we don't get enough text from the page
        _bio = @"";
        for (TFHppleElement *child in [e firstChildWithId:@"sf_bio"].children) {
            // parse out the text of each child of the bio element
            if (nil != child.content)
            {
                if ([_bio isEqualToString:@""]) {
                    _bio = [NSString stringWithFormat:@"%@", [child.content stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\r\n"]]];
                }
                else {
                    _bio = [_bio stringByAppendingString:child.content];
                }
            }
        }
        _linkedin = [[e firstChildWithId:@"sf_linkedin"].attributes objectForKey:@"href"];
        _facebook = [[e firstChildWithId:@"sf_facebook"].attributes objectForKey:@"href"];
        _twitter = [[e firstChildWithId:@"sf_twitter"].attributes objectForKey:@"href"];
        
        NSString *imagePath = [[e firstChildWithId:@"sf_photo"].attributes objectForKey:@"src"];
        if (nil != imagePath) {
            _image_path = [NSString stringWithFormat:@"http://www.techcolumbusinnovationawards.org/%@", imagePath];
        }
        else {
            _image_path = nil;
        }
        
        // a whole bunch of data cleanup
        NSRange r = [_facebook rangeOfString:@"fref=ts"];
        if (r.location == NSNotFound) {
            _facebook = [_facebook stringByAppendingString:@"?fref=ts"];
        }
        _facebook = [_facebook stringByReplacingOccurrencesOfString:@"/#!/" withString:@"/"];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)d
{
    if (self = [super init]) {
        // initialize
        _company = [d objectForKey:@"company"];
        _contact = [d objectForKey:@"contact"];
        _site_url = [d objectForKey:@"site_url"];
        _bio     = [d objectForKey:@"bio"];
        _linkedin = [d objectForKey:@"linkedIn"];
        _facebook = [d objectForKey:@"facebook"];
        _twitter = [d objectForKey:@"twitter"];
        _image_path = [d objectForKey:@"img"];
    }
    return self;
}

+(IASemifinalist *)semifinalistFromEntity:(id<SocializeEntity>)entity
{
    // set up the instance data
    // by parsing the entity key.  the entity is:
    // http://www.techcolumbusinnovationawards.org/2012_WSF_CAT.html#semifinalistname
    // where CAT is the 3-letter abbreviation for the category
    
    // first locate the category our semifinalist belongs to
    IACategory *category = [IACategory categoryFromEntity:entity];
    
    if (nil != category) {
        NSLog(@"looking in category %@", category.name);
        // find the semifinalist we're looking for
        NSArray *urlAndCompany = [[entity key] componentsSeparatedByString:@"#"];
        NSString *company = nil;
        if ([urlAndCompany count] == 2) {
            company = [[urlAndCompany objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"looking for semifinalist %@", company);
        
            for (IASemifinalist *sfi in category.semifinalists) {
                if ([sfi.company isEqualToString:company]) {
                    return sfi;
                }
            }
        }
    }
    return nil;
}


@end
