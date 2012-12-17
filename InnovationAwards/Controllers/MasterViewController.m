//
//  MasterViewController.m
//  InnovationAwards
//
//  Created by Mark Harris on 12/9/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import "MasterViewController.h"
#import "UIButton+SSGradient.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}

@property (nonatomic, strong) NSArray *pageImages;
@property (nonatomic, strong) NSArray *pageTransitions; // segues to other views
@property (nonatomic, strong) NSMutableArray *pageViews;

- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;
- (void)handleImageTap:(UITapGestureRecognizer *)sender;
- (void)handleLocationTap:(UITapGestureRecognizer *)sender;

@end

@implementation MasterViewController

@synthesize backgroundView = _backgroundView;
@synthesize locationView = _locationView;
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize pageImages = _pageImages;
@synthesize pageViews = _pageViews;
@synthesize registerButton = _registerButton;

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what you have to display, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

- (void)handleImageTap:(UITapGestureRecognizer *)sender
{
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        // the array 'pageTransitions' has the names of the segues to go to
        [self performSegueWithIdentifier:[self.pageTransitions objectAtIndex:self.pageControl.currentPage]  sender:self];
        
    }
}

- (void)handleLocationTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        // if tap in the location view, get directions
        [self performSegueWithIdentifier:@"showDirections" sender:self];
    }
}


- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what you have to display, then do nothing
        return;
    }
    
    // 1
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        // 2
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        // 3
        UIImageView *newPageView = [[UIImageView alloc] initWithImage:[self.pageImages objectAtIndex:page]];
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        newPageView.tag = page;
        
        [self.scrollView addSubview:newPageView];
        // 4
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
}

- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.pageControl.currentPage = page;
    
    // Work out which pages you want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    
	// Load pages in our range
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    
	// Purge anything after the last page
    for (NSInteger i=lastPage+1; i<self.pageImages.count; i++) {
        [self purgePage:i];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages that are now on screen
    [self loadVisiblePages];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // set the background image
    UIImage *bgImage = [UIImage imageNamed:@"mainBackground.png"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    CGRect deviceSize = [[UIScreen mainScreen] bounds];
    [bgImageView setFrame:CGRectMake(0, 0, deviceSize.size.width, deviceSize.size.height)];
    
    [self.view insertSubview:bgImageView atIndex:0];
    
    // add gradients to the "register now" button
    CAGradientLayer *gradient = buttonGradientWithColor(lightPurple, darkPurple);
    [self.registerButton addGradient:gradient];
    self.registerButton.layer.borderColor = darkPurple.CGColor;
    self.registerButton.layer.borderWidth = 1;
    
    gradient = buttonGradientWithColor(lightPurple, darkPurple);
    [self.directionsButton addGradient:gradient];
    self.directionsButton.layer.borderColor = darkPurple.CGColor;
    self.directionsButton.layer.borderWidth = 1;

    // set up the images we're going to scroll through
    self.pageImages = [NSArray arrayWithObjects:
                       [UIImage imageNamed:@"ia12_app_callouts_1.png"],
                       [UIImage imageNamed:@"ia12_app_callouts_2.png"],
                       [UIImage imageNamed:@"ia12_app_callouts_3.png"],
                       [UIImage imageNamed:@"ia12_app_callouts_4.png"],
                       nil];
    self.pageTransitions = [NSArray arrayWithObjects:
                            @"showSemifinalists",
                            @"showTwitter",
                            @"showFacebook",
                            @"showSponsors"
                            , nil];
    
    NSInteger pageCount = self.pageImages.count;
    
    // set the initial page
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = pageCount;
    
    // add each of the pages to the scrollview
    self.pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; ++i) {
        [self.pageViews addObject:[NSNull null]];
    }
    
    // set the scrollview so that we can transition to the next view when we tap on it.
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [self.scrollView addGestureRecognizer:singleTapGestureRecognizer];
    
    // move the buttons so they're just over top of the "location" frame
    NSInteger buttonWidth = self.registerButton.frame.size.width;
    NSInteger buttonHeight = self.registerButton.frame.size.height;
    NSInteger buttonY = self.locationView.frame.origin.y - 25 - buttonHeight;
        
    CGRect registerButtonFrame = self.registerButton.frame;
    CGRect directionsButtonFrame = self.directionsButton.frame;
    
    self.registerButton.frame = CGRectMake(registerButtonFrame.origin.x, buttonY, buttonWidth, buttonHeight);
    self.directionsButton.frame = CGRectMake(directionsButtonFrame.origin.x, buttonY, buttonWidth, buttonHeight);
    
    // set up the location window so we can click & get directions
    UITapGestureRecognizer *tapForDirections = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleLocationTap:)];
    tapForDirections.numberOfTapsRequired = 1;
    tapForDirections.enabled = YES;
    tapForDirections.cancelsTouchesInView = NO;
    [self.locationView addGestureRecognizer:tapForDirections];
    
    // color the toolbar appropriately
    [self.navigationController.toolbar setTintColor:[UIColor blackColor]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"headerBackground.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    [self.scrollView setFrame:CGRectMake(0, 66, 320, 146)];
    
    // 4
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);
    
    // 5
    [self loadVisiblePages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationBar *navBar = self.navigationController.navigationBar;
    [navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    NSLog(@"doing segue %@", [segue identifier]);
    
}

- (IBAction)registerButtonWasPressed:(id)sender {
}
@end
