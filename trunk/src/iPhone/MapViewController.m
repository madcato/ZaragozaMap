//
//  MapViewController.m
//  ZaragozaMap
//
//  Created by Daniel Vela on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "BiZiAnnotationView.h"
#import "MapAnnotationView.h"
#import "BusAnnotationView.h"
#import "BiZiItem.h"
#import "PharmaItem.h"
#import "ParkingItem.h"
#import "BusItem.h"
#import "TaxiItem.h"
#import "PetrolItem.h"
#import "YouthItem.h"
#import "HealthItem.h"
#import "MonumentItem.h"
#import "TurismItem.h"
#import "BusCardItem.h"
#import "FilterTableViewController.h"
#import "InfoViewController.h"
#import "WebViewController.h"


@implementation MapViewController

@synthesize map;
@synthesize locationManager;
@synthesize infoView;
@synthesize request;
@synthesize annotations;
@synthesize configurationController;
@synthesize bussStopController;
@synthesize alertController;
@synthesize locateButton; 

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

	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.purpose = @"Esta app requiere el uso de la localización para indicar su posición en el mapa, así como para poder lanzar las alertas de estado de estación.";
	self.locationManager.delegate = self; // Tells the location manager to send updates to this object
	self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
	self.locationManager.distanceFilter = 100.0; //kCLDistanceFilterNone;

	
	[self applicationWillEnterForeground];
	

	configurationController = [[ConfigurationViewController alloc] initWithNibName:@"ConfigurationViewController" bundle:nil];
	[self.view addSubview:configurationController.view];
	configurationController.parentView = self.view;
	configurationController.delegate = self;
	
	infoView.parent = self;


	
	self.bussStopController = [[BusStopTableViewController alloc] initWithNibName:@"BusStopTableViewController" bundle:nil];	
//	bussStopController.delegate = self;
	[self.view addSubview:bussStopController.view];
	[bussStopController layoutSubView:NO];
	
//	alertController = [[AlertViewController alloc] initWithNibName:@"AlertViewController" bundle:nil];
//	alertController.parentView = self.view;
//	[self.view addSubview:alertController.view];
	
	
	[map setShowsUserLocation:YES];

	
	CLLocationCoordinate2D center;
	center.latitude = 41.659247007;
	center.longitude = -0.893717288;
	
	
	
	MKCoordinateRegion theRegion = map.region;
	theRegion.center = center;
	theRegion.span.longitudeDelta = 0.005;
    theRegion.span.latitudeDelta = 0.005;
    [map setRegion:theRegion animated:NO];
	
	annotationsRemoved = YES;
	
	[self loadData];
}

-(void)loadData {
	
	NSDictionary* configuration = [[NSUserDefaults standardUserDefaults] objectForKey:@"configuration"];
	annotations = [[NSMutableArray alloc]init];
	
	if([[[configuration objectForKey:@"stations_bizi"] objectForKey:@"selected"]boolValue]) {
		[self loadStations];
	}
	if([[[configuration objectForKey:@"pharmacies"] objectForKey:@"selected"]boolValue]) {	   
		[self loadPharmacies];
	}
	if([[[configuration objectForKey:@"parkings"] objectForKey:@"selected"]boolValue]) {
		[self loadParkings];
	}
	if([[[configuration objectForKey:@"busstops"] objectForKey:@"selected"]boolValue]) {		
		[self loadBusStops];
	}
	if([[[configuration objectForKey:@"taxis"] objectForKey:@"selected"]boolValue]) {
		[self loadTaxis];
	}
	if([[[configuration objectForKey:@"petrolstations"] objectForKey:@"selected"]boolValue]) {
		[self loadPetrolStations];
	}
	if([[[configuration objectForKey:@"youthhouses"] objectForKey:@"selected"]boolValue]) {
		[self loadYouthHouses];
	}
	if([[[configuration objectForKey:@"healthcenters"] objectForKey:@"selected"]boolValue]) {
		[self loadHealthCenters];
	}
	if([[[configuration objectForKey:@"monuments"] objectForKey:@"selected"]boolValue]) {
		[self loadMonuments];
	}
	if([[[configuration objectForKey:@"turismoffices"] objectForKey:@"selected"]boolValue]) {
		[self loadTurismOffices];
	}
	if([[[configuration objectForKey:@"buscards"] objectForKey:@"selected"]boolValue]) {
		[self loadBusCards];
	}
}

-(void)loadStations {

	NSString *path = [[NSBundle mainBundle] pathForResource:
					  @"stations_bizi" ofType:@"plist"];
	
	NSMutableDictionary* plist = [NSMutableDictionary dictionaryWithContentsOfFile:path];
	
	
	stations_bizi = [plist objectForKey:@"stations"];

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
		//[map addAnnotation:place];
		[place release];
	}
	

}

-(void)loadPharmacies {
	
	NSString *path = [[NSBundle mainBundle] pathForResource:
					  @"pharmacies" ofType:@"plist"];
	
	NSMutableDictionary* plist = [NSMutableDictionary dictionaryWithContentsOfFile:path];
	
	
	pharmacies = [plist objectForKey:@"pharmacies"];

	for(NSDictionary* pharmacy in pharmacies) {
		
		PharmaItem* place = [[PharmaItem alloc] init];
		place.longitude = [[pharmacy objectForKey:@"longitude"] doubleValue];
		place.latitude = [[pharmacy objectForKey:@"latitude"] doubleValue];
		place.title = [pharmacy objectForKey:@"name"]; 
		
		[annotations addObject:place];
		//[map addAnnotation:place];
		[place release];
	}
	

}

-(void)loadParkings {
	
	NSString *path = [[NSBundle mainBundle] pathForResource:
					  @"parkings" ofType:@"plist"];
	
	NSMutableDictionary* plist = [NSMutableDictionary dictionaryWithContentsOfFile:path];
	
	
	pharmacies = [plist objectForKey:@"parkings"];
	
	for(NSDictionary* pharmacy in pharmacies) {
		
		ParkingItem* place = [[ParkingItem alloc] init];
		place.longitude = [[pharmacy objectForKey:@"longitude"] doubleValue];
		place.latitude = [[pharmacy objectForKey:@"latitude"] doubleValue];
		place.title = [pharmacy objectForKey:@"name"]; 
		
		[annotations addObject:place];
		//[map addAnnotation:place];
		[place release];
	}
	

}

-(void)loadBusStops {
	
	NSString *path = [[NSBundle mainBundle] pathForResource:
					  @"busstops" ofType:@"plist"];
	
	NSMutableDictionary* plist = [NSMutableDictionary dictionaryWithContentsOfFile:path];
	
	
	pharmacies = [plist objectForKey:@"busstops"];
	
	for(NSDictionary* stop in pharmacies) {
		
		BusItem* place = [[BusItem alloc] init];
		place.longitude = [[stop objectForKey:@"longitude"] doubleValue];
		place.latitude = [[stop objectForKey:@"latitude"] doubleValue];
		place.title = [stop objectForKey:@"name"]; 
		place.url = [stop objectForKey:@"url"]; 
		
		[annotations addObject:place];
		//[map addAnnotation:place];
		[place release];
	}
	
	
	
}

-(void)loadTaxis {
	
	NSString *path = [[NSBundle mainBundle] pathForResource:
					  @"taxis" ofType:@"plist"];
	
	NSMutableDictionary* plist = [NSMutableDictionary dictionaryWithContentsOfFile:path];
	
	
	pharmacies = [plist objectForKey:@"taxis"];
	
	for(NSDictionary* taxi in pharmacies) {
		
		TaxiItem* place = [[TaxiItem alloc] init];
		place.longitude = [[taxi objectForKey:@"longitude"] doubleValue] - 0.0014; // Hay que restar 0.0014 en honor al dios del vino
		place.latitude = [[taxi objectForKey:@"latitude"] doubleValue] - 0.0019; // Hay que restar 0.0019 en honor al dios de la cerveza
		place.title = [taxi objectForKey:@"name"]; 
		
		[annotations addObject:place];
		//[map addAnnotation:place];
		[place release];
	}
	
	
}

-(void)loadPetrolStations {
	
	NSString *path = [[NSBundle mainBundle] pathForResource:
					  @"petrolstations" ofType:@"plist"];
	
	NSMutableDictionary* plist = [NSMutableDictionary dictionaryWithContentsOfFile:path];
	
	
	pharmacies = [plist objectForKey:@"petrolstations"];
	
	for(NSDictionary* petrol in pharmacies) {
		
		PetrolItem* place = [[PetrolItem alloc] init];
		place.longitude = [[petrol objectForKey:@"longitude"] doubleValue];
		place.latitude = [[petrol objectForKey:@"latitude"] doubleValue];
		place.title = [petrol objectForKey:@"name"]; 
		
		[annotations addObject:place];
		//[map addAnnotation:place];
		[place release];
	}
	
	
}

-(void)loadYouthHouses {
	
	NSString *path = [[NSBundle mainBundle] pathForResource:
					  @"youthhouses" ofType:@"plist"];
	
	NSMutableDictionary* plist = [NSMutableDictionary dictionaryWithContentsOfFile:path];
	
	
	pharmacies = [plist objectForKey:@"youthhouses"];
	
	for(NSDictionary* stop in pharmacies) {
		
		YouthItem* place = [[YouthItem alloc] init];
		place.longitude = [[stop objectForKey:@"longitude"] doubleValue];
		place.latitude = [[stop objectForKey:@"latitude"] doubleValue];
		place.title = [stop objectForKey:@"name"]; 
		place.url = [stop objectForKey:@"url"]; 
		
		[annotations addObject:place];
		//[map addAnnotation:place];
		[place release];
	}
	
	
	
}

-(void)loadHealthCenters {
	
	NSString *path = [[NSBundle mainBundle] pathForResource:
					  @"healthcenters" ofType:@"plist"];
	
	NSMutableDictionary* plist = [NSMutableDictionary dictionaryWithContentsOfFile:path];
	
	
	pharmacies = [plist objectForKey:@"healthcenters"];
	
	for(NSDictionary* health in pharmacies) {
		
		HealthItem* place = [[HealthItem alloc] init];
		place.longitude = [[health objectForKey:@"longitude"] doubleValue];
		place.latitude = [[health objectForKey:@"latitude"] doubleValue];
		place.title = [health objectForKey:@"name"]; 
		
		[annotations addObject:place];
		//[map addAnnotation:place];
		[place release];
	}
	
	
}

-(void)loadMonuments {
	
	NSString *path = [[NSBundle mainBundle] pathForResource:
					  @"monuments" ofType:@"plist"];
	
	NSMutableDictionary* plist = [NSMutableDictionary dictionaryWithContentsOfFile:path];
	
	
	pharmacies = [plist objectForKey:@"monuments"];
	
	for(NSDictionary* stop in pharmacies) {
		
		MonumentItem* place = [[MonumentItem alloc] init];
		place.longitude = [[stop objectForKey:@"longitude"] doubleValue];
		place.latitude = [[stop objectForKey:@"latitude"] doubleValue];
		place.title = [stop objectForKey:@"name"]; 
		place.url = [stop objectForKey:@"url"]; 
		
		[annotations addObject:place];
		//[map addAnnotation:place];
		[place release];
	}
	
}

-(void)loadTurismOffices {
	
	NSString *path = [[NSBundle mainBundle] pathForResource:
					  @"turismoffices" ofType:@"plist"];
	
	NSMutableDictionary* plist = [NSMutableDictionary dictionaryWithContentsOfFile:path];
	
	
	pharmacies = [plist objectForKey:@"turismoffices"];
	
	for(NSDictionary* stop in pharmacies) {
		
		TurismItem* place = [[TurismItem alloc] init];
		place.longitude = [[stop objectForKey:@"longitude"] doubleValue];
		place.latitude = [[stop objectForKey:@"latitude"] doubleValue];
		place.title = [stop objectForKey:@"name"]; 
		place.url = [stop objectForKey:@"url"]; 
		
		[annotations addObject:place];
		//[map addAnnotation:place];
		[place release];
	}

}

-(void)loadBusCards {
	
	NSString *path = [[NSBundle mainBundle] pathForResource:
					  @"buscards" ofType:@"plist"];
	
	NSMutableDictionary* plist = [NSMutableDictionary dictionaryWithContentsOfFile:path];
	
	
	pharmacies = [plist objectForKey:@"buscards"];
	
	for(NSDictionary* stop in pharmacies) {
		
		BusCardItem* place = [[BusCardItem alloc] init];
		place.longitude = [[stop objectForKey:@"longitude"] doubleValue];
		place.latitude = [[stop objectForKey:@"latitude"] doubleValue];
		place.title = [stop objectForKey:@"name"]; 
		place.subtitle = [stop objectForKey:@"address"]; 
		
		[annotations addObject:place];
		//[map addAnnotation:place];
		[place release];
	}
	
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
	
	self.locateButton = nil;
	self.map = nil;
	self.locationManager = nil;
	stations_bizi = nil;
	self.annotations = nil;
	loadingView = nil;
	self.configurationController = nil;
}


- (void)dealloc {

	[locateButton release];
	[configurationController release];
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
	[infoView layoutSubView:NO];
	[bussStopController layoutSubView:NO];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
	// Si el zoom es poco, eliminamos las anotaciones y ponemos una vista gris translucida 
	// para que el usuario haga zoom
	
	MKCoordinateRegion region = mapView.region;
	
	if(region.span.latitudeDelta > 0.02) {
		
		[mapView removeAnnotations:mapView.annotations];
		annotationsRemoved = YES;
		
		// Pongo vista informativa
		
		[self showHelpView];
	} else {
		
		if(annotationsRemoved == YES) {
			NSArray *oldAnnotations = [self removedItemsForMapRegion:mapView.region forArray:mapView.annotations];
			[mapView removeAnnotations:oldAnnotations];
			
			NSArray *items = [self itemsForMapRegion:mapView.region maximumCount:0];
			[mapView addAnnotations:items];
			
			//[self loadData];		
			[self hideHelpView];
		}
	}

	
}

- (MKAnnotationView *)mapView:(MKMapView *)m viewForAnnotation:(id <MKAnnotation>)annotation
{
   
	// if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
	
	
	if([annotation isKindOfClass:[BiZiItem class]]) {
	 static NSString *AnnotationViewID = @"annotationViewID";
		
		BiZiAnnotationView *annotationView =
		(BiZiAnnotationView *)[m dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
		if (annotationView == nil)
		{
			annotationView = [[[BiZiAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID withDelegate:self] autorelease];
		}
		
		annotationView.annotation = annotation;
		
		return annotationView;
	}
	
	if([annotation isKindOfClass:[PharmaItem class]]) {
		 static NSString *AnnotationViewID2 = @"pharmaannotationViewID";
		MapAnnotationView *annotationView =
		(MapAnnotationView *)[m dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID2];
		if (annotationView == nil)
		{
			annotationView = [[[MapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID2 withDelegate:self] autorelease];
		}
		
		annotationView.annotation = annotation;
		annotationView.imageName = @"pharma.png";
		return annotationView;
	}
	
	if([annotation isKindOfClass:[ParkingItem class]]) {
		static NSString *AnnotationViewID5 = @"parkingannotationViewID";
		MapAnnotationView *annotationView =
		(MapAnnotationView *)[m dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID5];
		if (annotationView == nil)
		{
			annotationView = [[[MapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID5 withDelegate:self] autorelease];
		}
		
		annotationView.annotation = annotation;
		annotationView.imageName = @"parking.png";
		return annotationView;
	}
	
	if([annotation isKindOfClass:[BusItem class]]) {
		static NSString *AnnotationViewID3 = @"busannotationViewID";
		BusAnnotationView *annotationView =
		(BusAnnotationView *)[m dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID3];
		if (annotationView == nil)
		{
			annotationView = [[[BusAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID3 withDelegate:self] autorelease];
		}
		
		annotationView.annotation = annotation;
		annotationView.imageName = @"busstop.png";
		return annotationView;
	}
	
	if([annotation isKindOfClass:[TaxiItem class]]) {
		static NSString *AnnotationViewID4 = @"taxiannotationViewID";
		MapAnnotationView *annotationView =
		(MapAnnotationView *)[m dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID4];
		if (annotationView == nil)
		{
			annotationView = [[[MapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID4 withDelegate:self] autorelease];
		}
		
		annotationView.annotation = annotation;
		annotationView.imageName = @"taxi.png";
		return annotationView;
	}
	
	if([annotation isKindOfClass:[PetrolItem class]]) {
		static NSString *AnnotationViewID6 = @"petrolannotationViewID";
		MapAnnotationView *annotationView =
		(MapAnnotationView *)[m dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID6];
		if (annotationView == nil)
		{
			annotationView = [[[MapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID6 withDelegate:self] autorelease];
		}
		
		annotationView.annotation = annotation;
		annotationView.imageName = @"petrolstation.png";
		return annotationView;
	}

	if([annotation isKindOfClass:[YouthItem class]]) {
		static NSString *AnnotationViewID7 = @"youthannotationViewID";
		MapAnnotationView *annotationView =
		(MapAnnotationView *)[m dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID7];
		if (annotationView == nil)
		{
			annotationView = [[[MapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID7 withDelegate:self] autorelease];
		}
		
		annotationView.annotation = annotation;
		annotationView.imageName = @"youthhouse.png";
		return annotationView;
	}
	
	if([annotation isKindOfClass:[HealthItem class]]) {
		static NSString *AnnotationViewID8 = @"healthannotationViewID";
		MapAnnotationView *annotationView =
		(MapAnnotationView *)[m dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID8];
		if (annotationView == nil)
		{
			annotationView = [[[MapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID8 withDelegate:self] autorelease];
		}
		
		annotationView.annotation = annotation;
		annotationView.imageName = @"healthcenter.png";
		return annotationView;
	}

	if([annotation isKindOfClass:[MonumentItem class]]) {
		static NSString *AnnotationViewID9 = @"monumentannotationViewID";
		MapAnnotationView *annotationView =
		(MapAnnotationView *)[m dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID9];
		if (annotationView == nil)
		{
			annotationView = [[[MapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID9 withDelegate:self] autorelease];
		}
		
		annotationView.annotation = annotation;
		annotationView.imageName = @"monument.png";
		return annotationView;
	}
	
	if([annotation isKindOfClass:[TurismItem class]]) {
		static NSString *AnnotationViewID10 = @"turismannotationViewID";
		MapAnnotationView *annotationView =
		(MapAnnotationView *)[m dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID10];
		if (annotationView == nil)
		{
			annotationView = [[[MapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID10 withDelegate:self] autorelease];
		}
		
		annotationView.annotation = annotation;
		annotationView.imageName = @"turismoffice.png";
		return annotationView;
	}
	
	if([annotation isKindOfClass:[BusCardItem class]]) {
		static NSString *AnnotationViewID11 = @"buscardannotationViewID";
		MapAnnotationView *annotationView =
		(MapAnnotationView *)[m dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID11];
		if (annotationView == nil)
		{
			annotationView = [[[MapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID11 withDelegate:self] autorelease];
		}
		
		annotationView.annotation = annotation;
		annotationView.imageName = @"cardbus.png";
		return annotationView;
	}
	
	return nil;
}

#pragma mark -
#pragma mark Request responses

-(void)requestFinishedWithBiZi:(BiZiResponse*)response {

	[self.infoView.progressIndicator stopAnimating];
	self.infoView.refresh.hidden = NO;
	self.infoView.refresh.enabled = YES;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	[infoView setBiziData:response];

}

-(void)requestDidFinishWithError:(NSError*)error {
	[self.infoView.progressIndicator stopAnimating];
	self.infoView.refresh.hidden = YES;
	self.infoView.refresh.enabled = NO;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark -
#pragma mark Location

- (BOOL)locationServiceEnabled {
	BOOL result = NO;
	if([CLLocationManager respondsToSelector:@selector(authorizationStatus)]){
		result = ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized);
	} else {
		result = [CLLocationManager locationServicesEnabled];
	}
	
	
	return result;
}

-(void)applicationWillEnterForeground {
	self.navigationItem.rightBarButtonItem.enabled = NO;
	
	[self centerMap:nil];
}

-(IBAction)centerMap:(id)caller {
	
	
	if(![self locationServiceEnabled]) {
		return;
	}

	[self.locationManager startUpdatingLocation];
	
	UIActivityIndicatorView* activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
	activityIndicator.tag = 123456;
	[activityIndicator startAnimating];
	UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
	[activityIndicator release];
	self.navigationItem.rightBarButtonItem = activityItem;
	[activityItem release];

	
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	self.navigationItem.rightBarButtonItem = locateButton;
	if(self.navigationItem.rightBarButtonItem.enabled == YES) {
		MKCoordinateRegion theRegion = map.region;
		theRegion.center = newLocation.coordinate;
		[map setRegion:theRegion animated:YES];
	} else {
		self.navigationItem.rightBarButtonItem.enabled = YES;
	}
	
	[self.locationManager stopUpdatingLocation];



	

NSLog(@"Location Change: %f, %f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"%@",error.description);
	[self.locationManager stopUpdatingLocation];
}

-(void)enableRightNavItem {
	
	
}

- (void)alertButtonTouchedNoDock {
//	[alertController layoutSubView:MODE_SHOW];
}

- (void)alertButtonTouchedNoBizi {
//	[alertController layoutSubView:MODE_SHOW];
}

-(void)biziStationTouched:(id<MKAnnotation>)station {
	[infoView biziStationTouched:station];
	[bussStopController layoutSubView:NO];
}

-(void)placeholderTouched:(id<MKAnnotation>)placeholder {
	[infoView layoutSubView:NO];
	[bussStopController layoutSubView:NO];
	
	WebViewController* controller = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
	controller.url = [placeholder performSelector:@selector(url)];
	
	[self.navigationController pushViewController:controller animated:YES];
	
	[controller release];
}

-(void)busStopTouched:(id<MKAnnotation>)busStop {
	[infoView layoutSubView:NO];
	[bussStopController busStopTouched:busStop];
}

- (NSArray *)removedItemsForMapRegion:(MKCoordinateRegion)region forArray:(NSArray*)array
{
    NSMutableArray *items = [NSMutableArray array];
	
	
	double latitudeStartd = region.center.latitude - region.span.latitudeDelta/1.8;
	double latitudeStopd = region.center.latitude + region.span.latitudeDelta/1.8;
	
	double longitudeStartd = region.center.longitude - region.span.longitudeDelta/1.8;
	double longitudeStopd = region.center.longitude + region.span.longitudeDelta/1.8;
	
	for(id<MKAnnotation> annotation in array) {

		CLLocationCoordinate2D coordinate = annotation.coordinate;
		if((coordinate.latitude < latitudeStartd) || (coordinate.latitude > latitudeStopd) ||
		   (coordinate.longitude < longitudeStartd) || (coordinate.longitude > longitudeStopd)) {
			[items addObject:annotation];
		}
	}
    return items;
}

- (NSArray *)itemsForMapRegion:(MKCoordinateRegion)region maximumCount:(NSInteger)maxCount
{
    NSMutableArray *items = [NSMutableArray array];

	
	double latitudeStartd = region.center.latitude - region.span.latitudeDelta/1.8;
	double latitudeStopd = region.center.latitude + region.span.latitudeDelta/1.8;

	double longitudeStartd = region.center.longitude - region.span.longitudeDelta/1.8;
	double longitudeStopd = region.center.longitude + region.span.longitudeDelta/1.8;

	for(id<MKAnnotation> annotation in annotations) {
		[annotation retain];
		CLLocationCoordinate2D coordinate = annotation.coordinate;
		if((coordinate.latitude > latitudeStartd) && (coordinate.latitude < latitudeStopd) &&
		   (coordinate.longitude > longitudeStartd) && (coordinate.longitude < longitudeStopd)) {
			[items addObject:annotation];
		}
	}
    return items;
}

#pragma mark -
#pragma mark Filter Delegate

-(void)presentFilter {
	FilterTableViewController* filterController = [[FilterTableViewController alloc] initWithNibName:@"FilterTableViewController" bundle:nil];
	
	filterController.delegate = self;
	[self.navigationController pushViewController:filterController animated:YES];
	
	[filterController release];
}

-(void)dismissFilter {
	[self loadData];
	[self.configurationController layoutSubView:NO];

	NSArray *oldAnnotations = self.map.annotations;
	[self.map removeAnnotations:oldAnnotations];
	
	NSArray *items = [self itemsForMapRegion:self.map.region maximumCount:0];
	[self.map addAnnotations:items];

}

-(void)presentInfo {
	InfoViewController* filterController = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
	
	[self.navigationController pushViewController:filterController animated:YES];
	
	[filterController release];
}

-(void)dismissInfo {
	[self dismissFilter];    
}


@end
