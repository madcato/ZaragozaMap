//
//  AlertViewController.m
//  ZaragozaMap
//
//  Created by Daniel Vela on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlertViewController.h"


@implementation AlertViewController

@synthesize parentView;
@synthesize blackView;

-(IBAction)hornButtonTouched {
	if (viewActive) {
		[self layoutSubView:MODE_BUTTON];
	} else {
		[self layoutSubView:MODE_SHOW];
	}


}

- (void)layoutSubView:(int)mode
{
	
	CGFloat animationDuration = 0.2f;
    // by default content consumes the entire view area
    CGRect contentFrame = self.parentView.frame;
    // the banner still needs to be adjusted further, but this is a reasonable starting point
    // the y value will need to be adjusted by the banner height to get the final position
	CGPoint origin = CGPointMake(0.0, 0.0); //CGRectGetMinX(contentFrame), CGRectGetMaxY(contentFrame));
    CGFloat viewHeight = self.view.bounds.size.height;

	
	
    // Depending on if the banner has been loaded, we adjust the content frame and banner location
    // to accomodate the ad being on or off screen.
    // This layout is for an ad at the bottom of the view.
	switch (mode) {
		case MODE_HIDE:{
			origin.x = -self.view.frame.size.width;
			origin.y = 480;
			viewActive = NO;
			break;
		}
		case MODE_SHOW:{
			origin.x = -1;
			origin.y = contentFrame.size.height - viewHeight + 1;
			viewActive = YES;
			break;
		}
		case MODE_BUTTON:{
			origin.x = -self.view.frame.size.width + 38;
			origin.y = contentFrame.size.height - 38;
			viewActive = NO;
			break;
		}
		default:
			break;
	}
	
   
    // And finally animate the changes, running layout for the content view if required.
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         /*map.frame = contentFrame;
						  [map layoutIfNeeded];*/
                         self.view.frame = CGRectMake(origin.x, origin.y, self.view.frame.size.width, self.view.frame.size.height);
                     }];
}

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
	
	self.view.frame = CGRectMake(-self.view.frame.size.width, 480, self.view.frame.size.width, self.view.frame.size.height);
	

	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	CGFloat components[4] = {0, 0, 0, 0.5};
	CGColorRef almostBlack = CGColorCreate(space,components);
	
	self.blackView.layer.shadowColor = almostBlack;
	self.blackView.layer.shadowOffset = CGSizeMake(-5.0, -5.0);
	self.blackView.layer.shadowOpacity = 1.0;
	self.blackView.layer.shadowRadius = 5.0;
    self.blackView.layer.shouldRasterize = YES;
	
	CGColorSpaceRef space2 = CGColorSpaceCreateDeviceRGB();
	CGFloat components2[4] = {1, 1, 1, 1};
	CGColorRef almostWhite = CGColorCreate(space2,components2);
	self.view.layer.borderColor = almostWhite;
	self.view.layer.borderWidth = 1.0;
	
    CFRelease(almostBlack);
    CFRelease(almostWhite);
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
	
	self.blackView = nil;
}


- (void)dealloc {
	[blackView release];
    [super dealloc];
}


@end
