    //
//  BiZiViewController.m
//  ZaragozaMap
//
//  Created by Daniel Vela on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BiZiViewController.h"
#import "BiZiItem.h"


@implementation BiZiViewController

@synthesize bizi;
@synthesize nobizi;
@synthesize timedate;
@synthesize address;
@synthesize progressIndicator;
@synthesize refresh;
@synthesize locationManager;
@synthesize request;
@synthesize lastStation;
@synthesize parent;
@synthesize blackView;

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	CGFloat components[4] = {0, 0, 0, 1};
	CGColorRef almostBlack = CGColorCreate(space,components);
	
	self.blackView.layer.shadowColor = almostBlack;
	self.blackView.layer.shadowOffset = CGSizeMake(0.0, 6.0);
	self.blackView.layer.shadowOpacity = 1.0;
	self.blackView.layer.shadowRadius = 5.0;
	
	
	CGColorSpaceRef space2 = CGColorSpaceCreateDeviceRGB();
	CGFloat components2[4] = {1, 1, 1, 1};
	CGColorRef almostWhite = CGColorCreate(space2,components2);
	self.view.layer.borderColor = almostWhite;
	self.view.layer.borderWidth = 1.0;
	
	
	self.refresh.enabled = NO;
	self.refresh.hidden = YES;

	
	self.view.frame = CGRectMake(0.0, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
	
	
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.purpose = @"Esta app requiere el uso de la localización para indicar su posición en el mapa, así como para poder lanzar las alertas de estado de estación.";
	self.locationManager.delegate = self; // Tells the location manager to send updates to this object
	self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
	self.locationManager.distanceFilter = 50; //kCLDistanceFilterNone;
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
	
	self.refresh = nil;
	self.progressIndicator = nil;
	self.bizi = nil;
	self.nobizi = nil;
	self.timedate = nil;
	self.address = nil;
	self.blackView = nil;
}


- (void)dealloc {
    [super dealloc];
	
	[blackView release];
	[refresh release];
	[progressIndicator release];
	[bizi release];
	[nobizi release];
	[timedate release];
	[address release];
	
}

- (void)layoutSubView:(BOOL)show
{
	if(show == NO) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	}
	
	CGFloat animationDuration = 0.3f;
    // by default content consumes the entire view area
    CGRect contentFrame = self.view.bounds;
    // the banner still needs to be adjusted further, but this is a reasonable starting point
    // the y value will need to be adjusted by the banner height to get the final position
	CGPoint infoSubOrigin = CGPointMake(0.0, 0.0); //CGRectGetMinX(contentFrame), CGRectGetMaxY(contentFrame));
    CGFloat subViewHeight = self.view.bounds.size.height;
    
	
    // Depending on if the banner has been loaded, we adjust the content frame and banner location
    // to accomodate the ad being on or off screen.
    // This layout is for an ad at the bottom of the view.
    if (show)
    {
		contentFrame.origin.y += subViewHeight;
        contentFrame.size.height -= subViewHeight;
    }
    else
    {
		infoSubOrigin.y -= subViewHeight;
    }
    
    // And finally animate the changes, running layout for the content view if required.
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         /*map.frame = contentFrame;
						  [map layoutIfNeeded];*/
                         self.view.frame = CGRectMake(infoSubOrigin.x -1, infoSubOrigin.y -1, self.view.frame.size.width, self.view.frame.size.height);
                     }];
}

-(void) setBiziData:(BiZiResponse*)response {
	self.bizi.text = response.bizi;
	
	if([response.bizi isEqualToString:@"0"]) {
		self.bizi.textColor = [UIColor redColor];
	} else {
		self.bizi.textColor = [UIColor greenColor];
	}
	
	self.nobizi.text = response.nobizi;
	if([response.nobizi isEqualToString:@"0"]) {
		self.nobizi.textColor = [UIColor redColor];
	} else {
		self.nobizi.textColor = [UIColor greenColor];
	}
	
	
	self.timedate.text = response.timedate;
	self.address.text = [[response.address lowercaseString] capitalizedString];
	
}

#pragma mark -
#pragma mark Request responses

-(void) generateNotificationNow:(NSString*)text {
	UILocalNotification* notification = [[UILocalNotification alloc] init];
	
	notification.fireDate = [NSDate date];
	
	notification.alertBody = text;
	
	notification.soundName = UILocalNotificationDefaultSoundName;
	
	[[UIApplication sharedApplication] scheduleLocalNotification:notification];
	[notification release];
	NSLog(@"Notification thrown");
}

-(void)requestFinishedWithBiZi:(BiZiResponse*)response {
	
	if(alertFull == YES) {
		if([response.nobizi isEqualToString:@"0"]) {
			alertFull = NO;
			[self setBiziData:response];
			[self generateNotificationNow:@"La estación de bizi se ha llenado y no hay huecos disponibles."];
			
			[self.locationManager stopUpdatingLocation];
		}
	}
	
	if(alertEmpty == YES) {
		if([response.bizi isEqualToString:@"0"]) {
			alertEmpty = NO;
			[self setBiziData:response];
			[self generateNotificationNow:@"La estación de Bizi se ha quedado vacía. No hay bicicletas disponibles."];
			
			[self.locationManager stopUpdatingLocation];
		}
	}
}

-(void)requestDidFinishWithError:(NSError*)error {
	[self.progressIndicator stopAnimating];
	self.refresh.hidden = YES;
	self.refresh.enabled = NO;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark -
#pragma mark IBActions

-(IBAction)alertNoDockButton {
	NSLog(@"Alert Empty configured");
	alertEmpty = YES;
	alertStation = lastStation;
	[self.locationManager startUpdatingLocation];
}

-(IBAction)alertNoBiziButton {
	NSLog(@"Alert Full configured");
	alertFull = YES;
	alertStation = lastStation;
	[self.locationManager startUpdatingLocation];
}

-(IBAction)runRefresh {
	if(lastStation != nil) {
		[self biziStationTouched:lastStation];
	}
}

#pragma mark -
#pragma mark Map View management

-(void)biziStationTouched:(id<MKAnnotation>)station {
	
	
	if([station isKindOfClass:[BiZiItem class]]) {
		
		bizi.text = @"";
		nobizi.text = @"";
		address.text = @"";
		timedate.text = @"";
		
		lastStation = station;
		
		refresh.enabled = NO;
		refresh.hidden = YES;
		[progressIndicator startAnimating];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		
		BiZiItem* item = (BiZiItem*)station;
		NSString* idStation = item.idStation;
		NSString* addressNew = item.addressNew;
		
		request = [[WebRequestXML alloc] init];
		
		[request downloadXML:BIZI_URL
				  forStation:idStation withAddressNew:addressNew withDelegate:parent];
		
		
		[self layoutSubView:YES];
	}
	
}

#pragma mark -
#pragma mark location

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{

		
	BiZiItem* item = (BiZiItem*)alertStation;
	NSString* idStation = item.idStation;
	NSString* addressNew = item.addressNew;
	
	request = [[WebRequestXML alloc] init];
	
	[request downloadXML:BIZI_URL
			  forStation:idStation withAddressNew:addressNew withDelegate:self];

	
	
	
	NSLog(@"Location Update %f, %f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
}

@end
