//
//  ConfigurationViewController.m
//  ZaragozaMap
//
//  Created by Daniel Vela on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConfigurationViewController.h"


@implementation ConfigurationViewController

@synthesize parentView;
@synthesize blackView;
@synthesize delegate;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	viewActive = NO;
	
	self.view.frame = CGRectMake(282, 378, self.view.frame.size.width, self.view.frame.size.height);

	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	CGFloat components[4] = {0, 0, 0, 1};
	CGColorRef almostBlack = CGColorCreate(space,components);
	
	self.blackView.layer.shadowColor = almostBlack;
	self.blackView.layer.shadowOffset = CGSizeMake(-5.0, -5.0);
	self.blackView.layer.shadowOpacity = 1.0;
	self.blackView.layer.shadowRadius = 5.0;
	
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	self.blackView = blackView;
}


- (void)dealloc {
	[blackView release];
    [super dealloc];
}

#pragma mark -
#pragma mark View

- (void)layoutSubView:(BOOL)show
{
	viewActive = show;
	
	CGFloat animationDuration = 0.2f;
    // by default content consumes the entire view area
    CGRect contentFrame = self.parentView.frame;
    // the banner still needs to be adjusted further, but this is a reasonable starting point
    // the y value will need to be adjusted by the banner height to get the final position
	CGPoint origin = CGPointMake(0.0, 0.0); //CGRectGetMinX(contentFrame), CGRectGetMaxY(contentFrame));
    CGFloat viewHeight = self.view.bounds.size.height;
    CGFloat viewWidth = self.view.bounds.size.width;
	
	
    // Depending on if the banner has been loaded, we adjust the content frame and banner location
    // to accomodate the ad being on or off screen.
    // This layout is for an ad at the bottom of the view.
    if (show)
    {
		origin.x = contentFrame.size.width - viewWidth;
		origin.y = contentFrame.size.height - viewHeight;
    }
    else
    {
		origin.x = contentFrame.size.width - 38;
		origin.y = contentFrame.size.height - 38;
    }
    
    // And finally animate the changes, running layout for the content view if required.
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         /*map.frame = contentFrame;
						  [map layoutIfNeeded];*/
                         self.view.frame = CGRectMake(origin.x, origin.y, self.view.frame.size.width, self.view.frame.size.height);
                     }];
}

#pragma mark -
#pragma mark Actions

-(IBAction)confButtonTouched {
	[self layoutSubView:!viewActive];
}

-(IBAction)filterButtonTouched {
	[self.delegate presentFilter];
	
	
}

@end
