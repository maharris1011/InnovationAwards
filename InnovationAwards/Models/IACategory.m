//
//  IACategory.m
//  InnovationAwards
//
//  Created by Mark Harris on 1/3/13.
//  Copyright (c) 2013 TechColumbus. All rights reserved.
//

#import "IACategory.h"
#import "IASemifinalist.h"
#import "TFHpple.h"

@implementation IACategory

@synthesize name = _name;
@synthesize url = _url;
@synthesize abbrev = _abbrev;
@synthesize semifinalists = _semifinalists;

- (id)init
{
    if (self = [super init])
    {
        _name = nil;
        _url = nil;
        _abbrev = nil;
        _semifinalists = nil;
    }
    return self;
}

-(NSArray *)semifinalists
{
    if (_semifinalists == nil)
    {
        // go to the web and retrieve our list of semifinalists
        NSMutableArray *semis = [[NSMutableArray alloc] initWithCapacity:0];
        
        NSURL *cat_url = [NSURL URLWithString:self.url];
        NSData *htmlData = [NSData dataWithContentsOfURL:cat_url];
        
        if (htmlData != nil) {
            TFHpple *parser = [TFHpple hppleWithHTMLData:htmlData];
            NSArray *sfNodes = [parser searchWithXPathQuery:@"//div[@class='post-author-info']"];
            for (TFHppleElement *element in sfNodes)
            {
                // reach in & grab out semifinalist information
                IASemifinalist *sf = [[IASemifinalist alloc] initWithHTML:element];
                
                [semis addObject:sf];
            }
        }
        
        _semifinalists = [semis mutableCopy];
    }
    return _semifinalists;
}

-(NSString *)url
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.techcolumbusinnovationawards.org/2012_WSF_%@_test4.html", self.abbrev];
    return urlString;
}

@end
