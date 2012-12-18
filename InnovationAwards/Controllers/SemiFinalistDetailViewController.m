//
//  SemiFinalistDetailViewController.m
//  InnovationAwards
//
//  Created by Mark Harris on 12/9/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import "SemiFinalistDetailViewController.h"
#import "PullToRefresh/PullToRefreshView.h"

@interface SemiFinalistDetailViewController ()

- (void)setupSocializeEntity;

@end

@implementation SemiFinalistDetailViewController

@synthesize urlOfCategory = _urlOfCategory;

- (void)setupSocializeEntity
{
    self.entity = [SZEntity entityWithKey:self.urlOfCategory name:self.semifinalistName];
    self.actionBar = [SZActionBarUtils showActionBarWithViewController:self entity:self.entity options:nil];
    
    SZShareOptions *shareOptions = [SZShareUtils userShareOptions];
    shareOptions.dontShareLocation = NO;
    self.actionBar.shareOptions = shareOptions;
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%@", self.semifinalistName], @"szsd_title",
                            [NSString stringWithFormat:@"Nominated for %@", self.categoryName], @"szsd_description",
                            nil];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    NSAssert(error == nil, @"Error writing json: %@", [error localizedDescription]);
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    self.entity.meta = jsonString;
    
    [SZEntityUtils addEntity:self.entity success:^(id<SZEntity> serverEntity) {
        NSLog(@"Successfully updated entity meta: %@", [serverEntity meta]);
    } failure:^(NSError *error) {
        NSLog(@"Failure: %@", [error localizedDescription]);
    }];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithEntity:(id<SocializeEntity>)entity
{
    NSLog(@"Init with Entity Called with entity %@", entity);
    if (self = [super init])
    {
        // set up the instance data
        // by parsing the entity key.  the entity is:
        // http://www.techcolumbusinnovationawards.org/<something>.html/<category name>/semifinalistname
        NSLog(@"name = %@", [entity key]);
        
        NSURL *urlEntity = [NSURL URLWithString:[entity name]];
        NSArray *urlPathComps = [urlEntity pathComponents];
        NSInteger numComps = [urlPathComps count];
        _semifinalistName = [urlPathComps objectAtIndex:(numComps - 1)];
        _categoryName = [urlPathComps objectAtIndex:(numComps - 2)];
        _urlOfCategory = [urlPathComps objectAtIndex:0];

        NSLog(@"urlOfCategory = %@", _urlOfCategory);
        NSLog(@"semifinalistName = %@", _semifinalistName);
        NSLog(@"categoryName = %@", _categoryName);
        return self;
    }
    
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    NSURL *url = [NSURL URLWithString:self.urlOfCategory];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
    
    [self.navigationItem setTitle:self.semifinalistName];
    [self setupSocializeEntity];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.toolbarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.actionBar == nil) {
        
        [self setupSocializeEntity];
        
    }
    self.navigationController.toolbarHidden = NO;
}

- (IBAction)backPressed:(id)sender {
    [self.webView goBack];
}

- (IBAction)forwardPressed:(id)sender {
    [self.webView goForward];
}

@end
