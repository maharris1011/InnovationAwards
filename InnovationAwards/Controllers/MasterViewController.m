//
//  MasterViewController.m
//  InnovationAwards
//
//  Created by Mark Harris on 12/9/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import "MasterViewController.h"
#import "UIButton+SSGradient.h"
#import "AppDelegate.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}

@property (nonatomic, strong) NSArray *pageImages;
@property (nonatomic, strong) NSArray *pageTransitions; // segues to other views
@property (nonatomic, strong) NSMutableArray *pageViews;
@property BOOL pageControlIsChangingPage;

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
@synthesize pageControlIsChangingPage;

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
        frame = CGRectInset(frame, 10.0f, 0.0f);
        
        // 3
        UIImageView *newPageView = [[UIImageView alloc] initWithImage:[self.pageImages objectAtIndex:page]];
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        newPageView.tag = page;
        newPageView.layer.shadowColor = [UIColor blackColor].CGColor;
        newPageView.layer.shadowOffset = CGSizeMake(1, 1);
        newPageView.layer.shadowOpacity = .8;
        newPageView.layer.shadowRadius = 10.0;
        newPageView.layer.shouldRasterize = YES;
        newPageView.clipsToBounds = NO;
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

- (void)configureView
{
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
    self.registerButton.titleLabel.font = [UIFont fontWithName:IA_Font600 size:15.0];
    
    gradient = buttonGradientWithColor(lightPurple, darkPurple);
    [self.directionsButton addGradient:gradient];
    self.directionsButton.layer.borderColor = darkPurple.CGColor;
    self.directionsButton.layer.borderWidth = 1;
    self.directionsButton.titleLabel.font = [UIFont fontWithName:IA_Font600 size:15.0];
    
    // set fonts
    self.dateText.font = [UIFont fontWithName:IA_Font600 size:15.0];
    self.locationText.font = [UIFont fontWithName:IA_Font600 size:15.0];
    self.roomText.font = [UIFont fontWithName:IA_Font600 size:15.0];
    
    // set up the images we're going to scroll through
    self.pageImages = [NSArray arrayWithObjects:
                       [UIImage imageNamed:@"ia12_app_callouts_1.png"],
                       [UIImage imageNamed:@"ia12_app_callouts_2.png"],
                       [UIImage imageNamed:@"ia12_app_callouts_3.png"],
                       [UIImage imageNamed:@"ia12_app_callouts_5.png"],
                       [UIImage imageNamed:@"ia12_app_callouts_4.png"],
                       nil];
    self.pageTransitions = [NSArray arrayWithObjects:
                            @"showSemifinalists",
                            @"showTwitter",
                            @"showFacebook",
                            @"showLinkedIn",
                            @"showEventDetails",
                            nil];
    
    NSInteger pageCount = self.pageImages.count;
    
    // set the initial page
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = pageCount;
    
    // add each of the pages to the scrollview
    self.pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; ++i) {
        [self.pageViews addObject:[NSNull null]];
    }   
    
    // color the toolbar appropriately
    [self.navigationController.toolbar setTintColor:[UIColor blackColor]];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set the scrollview so that we can transition to the next view when we tap on it.
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [self.scrollView addGestureRecognizer:singleTapGestureRecognizer];

    // set up the location window so we can click & get directions
    UITapGestureRecognizer *tapForDirections = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleLocationTap:)];
    tapForDirections.numberOfTapsRequired = 1;
    tapForDirections.enabled = YES;
    tapForDirections.cancelsTouchesInView = NO;
    [self.locationView addGestureRecognizer:tapForDirections];

    [self configureView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage *headerBackground = [UIImage imageNamed:@"headerBackgroundRounded.png"];
    [self.navigationController.navigationBar setBackgroundImage:headerBackground forBarMetrics:UIBarMetricsDefault] ;

    self.navigationController.toolbarHidden = YES;    
    
    // 4
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);

    // 5
    [self loadVisiblePages];
}

- (void)viewDidLayoutSubviews
{
    // move the page control just below the clickable images
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    [self.pageControl setFrame:CGRectMake(0, pagesScrollViewSize.height+10, 320, 36)];
    
    // move the buttons to be midway between "location" and the bottom of the pageControl
    NSInteger buttonWidth = self.registerButton.frame.size.width;
    NSInteger buttonHeight = self.registerButton.frame.size.height;
    NSInteger bottomOfPageControl = self.pageControl.frame.origin.y + self.pageControl.frame.size.height;
    NSInteger buttonY = bottomOfPageControl + ((self.locationView.frame.origin.y - bottomOfPageControl - buttonHeight) / 2);
    
    CGRect registerButtonFrame = self.registerButton.frame;
    CGRect directionsButtonFrame = self.directionsButton.frame;
    
    self.registerButton.frame = CGRectMake(registerButtonFrame.origin.x, buttonY, buttonWidth, buttonHeight);
    self.directionsButton.frame = CGRectMake(directionsButtonFrame.origin.x, buttonY, buttonWidth, buttonHeight);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return [self shouldAutorotateToInterfaceOrientation:self.interfaceOrientation];
}


-(NSInteger)supportedInterfaceOrientations{
    NSInteger mask = 0;
    if ([self shouldAutorotateToInterfaceOrientation: UIInterfaceOrientationLandscapeRight])
        mask |= UIInterfaceOrientationMaskLandscapeRight;
    if ([self shouldAutorotateToInterfaceOrientation: UIInterfaceOrientationLandscapeLeft])
        mask |= UIInterfaceOrientationMaskLandscapeLeft;
    if ([self shouldAutorotateToInterfaceOrientation: UIInterfaceOrientationPortrait])
        mask |= UIInterfaceOrientationMaskPortrait;
    if ([self shouldAutorotateToInterfaceOrientation: UIInterfaceOrientationPortraitUpsideDown])
        mask |= UIInterfaceOrientationMaskPortraitUpsideDown;
    return mask;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationBar *navBar = self.navigationController.navigationBar;
    [navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

- (IBAction)registerButtonWasPressed:(id)sender {
    // do nothing -- handled in the segue
}


#pragma mark PageViewControllerDelegate messages

- (IBAction)changePage:(id)sender {
    /*
     *  Change the scroll view
     */
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    pageControlIsChangingPage = YES;
}

- (void)viewDidUnload {
    [self setDateText:nil];
    [self setLocationText:nil];
    [self setRoomText:nil];
    [super viewDidUnload];
}
@end
