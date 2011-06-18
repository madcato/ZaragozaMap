//
//  MapViewController.m
//  ZaragozaMap
//
//  Created by Daniel Vela on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "BiZiAnnotationView.h"
#import "BiZiItem.h"


@implementation MapViewController

@synthesize map;
@synthesize locationManager;
@synthesize infoView;
@synthesize request;
@synthesize bizi;
@synthesize nobizi;
@synthesize timedate;
@synthesize address;
@synthesize progressIndicator;
@synthesize refresh;

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


	
	self.refresh.enabled = NO;
	self.refresh.hidden = YES;

	infoView.frame = CGRectMake(0.0, -infoView.frame.size.height, infoView.frame.size.width, infoView.frame.size.height);


	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	CGFloat components[4] = {0, 0, 0, 1};
	CGColorRef almostBlack = CGColorCreate(space,components);
	infoView.layer.shadowColor = almostBlack;
	infoView.layer.shadowOffset = CGSizeMake(0.0, 6.0);
	infoView.layer.shadowOpacity = 1.0;
	infoView.layer.shadowRadius = 5.0;

	
	[map setShowsUserLocation:YES];

	
	CLLocationCoordinate2D center;
	center.latitude = 41.659247007;
	center.longitude = -0.893717288;
	
	
	
	MKCoordinateRegion theRegion = map.region;
	theRegion.center = center;
	theRegion.span.longitudeDelta = 0.005;
    theRegion.span.latitudeDelta = 0.005;
    [map setRegion:theRegion animated:NO];
	

	[self loadStations];
}


-(void)loadStations {

	NSString *path = [[NSBundle mainBundle] pathForResource:
					  @"stations_bizi" ofType:@"plist"];
	
	NSMutableDictionary* plist = [NSMutableDictionary dictionaryWithContentsOfFile:path];
	
	
	stations_bizi = [plist objectForKey:@"stations"];
	annotations = [NSMutableArray array];
	for(NSDictionary* station in stations_bizi) {
/*		
		CLLocationCoordinate2D coordinate;
		coordinate.latitude = [[station objectForKey:@"latitude"] floatValue];
		coordinate.longitude = [[station objectForKey:@"longitude"] floatValue];
		
		NSDictionary* address = [NSDictionary dictionaryWithObjectsAndKeys:[station objectForKey:@"idStation"],kABPersonAddressStateKey
																			,[station objectForKey:@"addressnew"],kABPersonAddressStreetKey
																		,nil];
		MKPlacemark* place = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:address];
*/	
		
		BiZiItem* place = [[BiZiItem alloc] init];
		place.longitude = [[station objectForKey:@"longitude"] doubleValue];
		place.latitude = [[station objectForKey:@"latitude"] doubleValue];
		place.addressNew = [station objectForKey:@"addressnew"]; 
		place.idStation = [station objectForKey:@"idStation"]; 
							
		[annotations addObject:place];
		[map addAnnotation:place];
		[place release];
	}
	
	annotationsRemoved = NO;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(IBAction)centerMap:(id)caller {
	
	if(self.locationManager != nil) {
		self.locationManager.delegate = nil;
		self.locationManager = nil;
	}
	
	self.locationManager = [[[CLLocationManager alloc] init] autorelease];
	self.locationManager.delegate = self; // Tells the location manager to send updates to this object
	self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
	self.locationManager.distanceFilter = kCLDistanceFilterNone;
	
	
	[self.locationManager startMonitoringSignificantLocationChanges];
	
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{

	
	MKCoordinateRegion theRegion = map.region;
	theRegion.center = newLocation.coordinate;
    [map setRegion:theRegion animated:YES];
	
	
	[self.locationManager stopMonitoringSignificantLocationChanges];
}


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
	self.map = nil;
	self.locationManager = nil;
	[stations_bizi release];stations_bizi = nil;
	[annotations release];annotations = nil;
	[loadingView release];loadingView = nil;
	
}


- (void)dealloc {

	[refresh release];
	[progressIndicator release];
	[bizi release];
	[nobizi release];
	[timedate release];
	[address release];
	
	[loadingView release];
	[annotations release];
	[stations_bizi release];
	[locationManager release];
	[map release];
    [super dealloc];
}

#pragma mark -
#pragma mark Help View
- (void)showHelpView
{
    if (loadingView == nil)
    {
        loadingView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 160.0, 300.0, 60.0)];
        loadingView.opaque = NO;
        loadingView.backgroundColor = [UIColor darkGrayColor];
        loadingView.alpha = 0.8;
		loadingView.layer.cornerRadius = 15.0;
		
		UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(30.0,0,240.0,60.0)];
		label.textAlignment = UITextAlignmentCenter;
		label.numberOfLines = 2;
		label.font = [UIFont boldSystemFontOfSize:17];
		label.text = @"Para ver la información, aumente el nivel de zoom.";
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor clearColor];
		[loadingView addSubview:label];
        [label release];
    }
	
    [self.view addSubview:loadingView];
}

- (void)hideHelpView
{
    [loadingView removeFromSuperview];
}


#pragma mark -
#pragma mark MkMapView delegate methods

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
	
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
	// Si el zoom es poco, eliminamos las anotaciones y ponemos una vista gris translucida 
	// para que el usuario haga zoom
	
	MKCoordinateRegion region = mapView.region;
	
	if(region.span.latitudeDelta > 0.01) {
		
		[mapView removeAnnotations:mapView.annotations];
		annotationsRemoved = YES;
		
		// Pongo vista informativa
		
		[self showHelpView];
	} else {
		
		if(annotationsRemoved == YES) {
			[self loadStations];		
			[self hideHelpView];
		}
	}

	
}

- (MKAnnotationView *)mapView:(MKMapView *)m viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *AnnotationViewID = @"annotationViewID";
	
	if(![annotation isKindOfClass:[BiZiItem class]]) {
		return nil;
	}
    BiZiAnnotationView *annotationView =
	(BiZiAnnotationView *)[m dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil)
    {
        annotationView = [[[BiZiAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID withDelegate:self] autorelease];
    }
    
    annotationView.annotation = annotation;
    
    return annotationView;
}

#pragma mark -
#pragma mark Map View management

- (void)layoutSubView:(BOOL)show
{
	
	CGFloat animationDuration = 0.2f;
    // by default content consumes the entire view area
    CGRect contentFrame = self.view.bounds;
    // the banner still needs to be adjusted further, but this is a reasonable starting point
    // the y value will need to be adjusted by the banner height to get the final position
	CGPoint infoSubOrigin = CGPointMake(0.0, 0.0); //CGRectGetMinX(contentFrame), CGRectGetMaxY(contentFrame));
    CGFloat subViewHeight = self.infoView.bounds.size.height;
    
	
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
                         infoView.frame = CGRectMake(infoSubOrigin.x, infoSubOrigin.y, infoView.frame.size.width, infoView.frame.size.height);
                     }];
}

-(void)biziStationTouched:(id<MKAnnotation>)station {

	
	if([station isKindOfClass:[BiZiItem class]]) {
		
		lastStation = station;
		
		self.refresh.enabled = NO;
		self.refresh.hidden = YES;
		[self.progressIndicator startAnimating];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		
		BiZiItem* item = (BiZiItem*)station;
		NSString* idStation = item.idStation;
		NSString* addressNew = item.addressNew;
		
		request = [[WebRequestXML alloc] init];
		
		[request downloadXML:@"http://www.bizizaragoza.com/callwebservice/StationBussinesStatus.php"
				  forStation:idStation withAddressNew:addressNew withDelegate:self];
		
		
		[self layoutSubView:YES];
	}
	
}


#pragma mark -
#pragma mark Request responses
-(void)requestFinishedWithBiZi:(BiZiResponse*)response {

	
	[self.progressIndicator stopAnimating];
	self.refresh.hidden = NO;
	self.refresh.enabled = YES;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
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

-(void)requestDidFinishWithError:(NSError*)error {
	[self.progressIndicator stopAnimating];
	self.refresh.hidden = YES;
	self.refresh.enabled = NO;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(IBAction)runRefresh {
	if(lastStation != nil) {
		[self biziStationTouched:lastStation];
	}
}

@end
