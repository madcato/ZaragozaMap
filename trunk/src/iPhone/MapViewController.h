//
//  MapViewController.h
//  ZaragozaMap
//
//  Created by Daniel Vela on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebRequestXML.h"
#import "BiZiViewController.h"
#import "ConfigurationViewController.h"
#import "BusStopTableViewController.h"


@interface MapViewController : UIViewController <CLLocationManagerDelegate, MapManagementProtocol, MKMapViewDelegate, WebRequestXMLDelegate, ConfigurationDelegate> {
	MKMapView* map;
	CLLocationManager *locationManager;

	NSArray* stations_bizi;
	NSArray* pharmacies;
	
	NSMutableArray* annotations;
	BOOL annotationsRemoved;
	UIView* loadingView;
	BiZiViewController* infoView;
	
	WebRequestXML* request;
	

	ConfigurationViewController* configurationController;
	BusStopTableViewController* bussStopController;

}

@property (nonatomic,retain) NSMutableArray* annotations;
@property (nonatomic,retain) IBOutlet MKMapView* map;
@property (nonatomic,retain) IBOutlet BiZiViewController* infoView;
@property (nonatomic,retain) CLLocationManager* locationManager;
@property (nonatomic,retain) WebRequestXML* request;
@property (nonatomic,retain) ConfigurationViewController* configurationController;
@property (nonatomic,retain) BusStopTableViewController* bussStopController;

- (void)showHelpView;
- (void)hideHelpView;

-(void)loadStations;
-(void)loadPharmacies;
-(void)loadParkings;
-(void)loadBusStops;
-(void)loadTaxis;
-(void)loadPetrolStations;
-(void)loadYouthHouses;
-(void)loadHealthCenters;
-(void)loadMonuments;
-(void)loadTurismOffices;
-(void)loadBusCards;

-(IBAction)centerMap:(id)caller;

-(void)applicationWillEnterForeground;
- (BOOL)locationServiceEnabled;
-(void)loadData;

- (NSArray *)itemsForMapRegion:(MKCoordinateRegion)region maximumCount:(NSInteger)maxCount;
- (NSArray *)removedItemsForMapRegion:(MKCoordinateRegion)region forArray:(NSArray*)array;

@end
