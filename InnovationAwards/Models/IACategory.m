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
#import "AppDelegate.h"

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

+ (IACategory *)categoryFromEntity:(id<SocializeEntity>)entity
{
    // find the semifinalist we're looking for
    NSArray *urlAndCompany = [[entity key] componentsSeparatedByString:@"#"];
    NSString *categoryURL = [urlAndCompany objectAtIndex:0];
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    for (IACategory *cat in [app sharedCategories])
    {
        if ([cat.url isEqualToString:categoryURL]) {
            return cat;
        }
    }
    return nil;
}

-(IASemifinalist *)findSemifinalistWithCompany:(NSString *)company
{
    for (IASemifinalist *sf in self.semifinalists) {
        if ([sf.company isEqualToString:company]) {
            return sf;
        }
    }
    return nil;
}

-(NSInteger)indexOfSemifinalistWithCompany:(NSString *)company
{
    for (NSInteger i = 0; i < [self.semifinalists count]; i++) {
        IASemifinalist *sf = [self.semifinalists objectAtIndex:i];
        if ([sf.company isEqualToString:company]) {
            return i;
        }
    }
    return -1;
}

-(NSArray *)semifinalists
{
    if ([_semifinalists count] == 0)
    {
        // go to the web and retrieve our list of semifinalists
        NSMutableArray *semis = [[NSMutableArray alloc] initWithCapacity:0];
        
        NSURL *cat_url = [NSURL URLWithString:self.url];
        NSData *htmlData = [NSData dataWithContentsOfURL:cat_url];
        
        if (htmlData != nil)
        {
            TFHpple *parser = [TFHpple hppleWithHTMLData:htmlData];

            NSArray *semifinalistNode = [parser searchWithXPathQuery:@"//div[@class='post-author-info']"];
            for (TFHppleElement *element in semifinalistNode)
            {
                TFHppleElement *winnerNode = [element firstChildWithClassName:@"post-author-winner-info"];
                if (winnerNode == nil)
                {
                    // we have a regular semifinalist
                    // reach in & grab out semifinalist information
                    IASemifinalist *sf = [[IASemifinalist alloc] initWithHTML:element];
                    [semis addObject:sf];
                }
                else
                {
                    // we have a winner of the category, so we parse the
                    // div with class post-author-winner-info as if it wer
                    // a regular semifinalist
                    IASemifinalist *sf = [[IASemifinalist alloc] initWithHTML:winnerNode];
                    sf.isWinner = YES;
                    [semis addObject:sf];
                }
            }
            
        }
        
        if ([semis count] == 0) {
            // if no one in the category, put a "placeholder" in
            [semis addObject:[[IASemifinalist alloc] initWithFake:1]];
        }
        
        _semifinalists = semis;
    }
    return _semifinalists;
}

-(NSString *)url
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.techcolumbusinnovationawards.org/2012_WSF_%@.html", self.abbrev];
    return urlString;
}

@end
