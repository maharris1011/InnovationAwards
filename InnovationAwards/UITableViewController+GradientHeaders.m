//
//  UITableViewController+GradientHeaders.m
//  iSandlot
//
//  Created by Mark Harris on 11/18/12.
//
//
#import "UIView+SSGradient.h"
#import "UITableViewController+GradientHeaders.h"
#import "Constants.h"


CAGradientLayer *darkPurpleGradient(void)
{
    return gradientWithColor(darkPurple, lightPurple);
}

@implementation UITableViewController (GradientHeaders)

- (UIView *)gradientHeaderViewForSection:(NSInteger)section
{
    UITableView *tableView = self.tableView;
    CGFloat width = CGRectGetWidth(tableView.bounds);
    CGFloat height = [self tableView:tableView heightForHeaderInSection:section];
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,0,width,height)] ;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)] ;
    
    // create the gradient for the background
    [headerView addGradient:darkPurpleGradient()];
    [backgroundView setOpaque:NO];
    [backgroundView setAlpha:0.7];
    [headerView setAlpha:0.7];
    
    // create the label view
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,0,width,height)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = IA_headlineBold;
    headerLabel.shadowOffset = CGSizeMake(1, 1);
    headerLabel.textColor = yellowText;
    headerLabel.shadowColor = [UIColor darkGrayColor];
    headerLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    [headerLabel setOpaque:NO];
    
    // add our new views to this header & return it
    [headerView addSubview:backgroundView];
    [headerView addSubview:headerLabel];
    headerView.layer.borderColor = darkPurple.CGColor;
    headerView.layer.borderWidth = 1.0f;
    [headerView setOpaque:NO];
    
    return headerView;
}

- (UIView *)gradientViewForCell:(UITableViewCell *)cell
{
    CGFloat width = CGRectGetWidth(cell.bounds);
    CGFloat height = cell.bounds.size.height;
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,0,width,height)] ;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)] ;
    
    // create the gradient for the background
    [view addGradient:darkPurpleGradient()];
    [backgroundView setOpaque:NO];
    [backgroundView setAlpha:0.7];

    // add our new views to this header & return it
    [view addSubview:backgroundView];
    view.layer.borderColor = darkPurple.CGColor;
    view.layer.borderWidth = 1.0f;
    [view setOpaque:NO];

    return view;
}

@end
