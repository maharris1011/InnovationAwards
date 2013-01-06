//
//  MasterViewController.h
//  InnovationAwards
//
//  Created by Mark Harris on 12/9/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MasterViewController : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet UIView *locationView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) IBOutlet UIButton *directionsButton;

- (IBAction)registerButtonWasPressed:(id)sender;
- (IBAction)changePage:(id)sender;

@end
