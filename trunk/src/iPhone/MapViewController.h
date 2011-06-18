//
//  MapViewController.h
//  ZaragozaMap
//
//  Created by Daniel Vela on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapManagementProtocol.h"
#import "WebRequestXML.h"

@interface MapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, MapManagementProtocol, WebRequestXMLDelegate> {
	MKMapView* map;
	CLLocationManager *locationManager;
	NSArray* stations_bizi;
	NSMutableArray* annotations;
	BOOL annotationsRemoved;
	UIView* loadingView;
	UIView* infoView;
	
	WebRequestXML* request;
	
	UILabel* address;
	UILabel* timedate;
	UILabel* bizi;
	UILabel* nobizi;
	UIActivityIndicatorView* progressIndicator;
	UIButton* refresh;

	id<MKAnnotation> lastStation;
}

@property (nonatomic,retain) IBOutlet MKMapView* map;
@property (nonatomic,retain) IBOutlet UIView* infoView;
@property (nonatomic,retain) CLLocationManager* locationManager;
@property (nonatomic,retain) WebRequestXML* request;

@property (nonatomic,retain) IBOutlet UILabel* address;
@property (nonatomic,retain) IBOutlet UILabel* timedate;
@property (nonatomic,retain) IBOutlet UILabel* bizi;
@property (nonatomic,retain) IBOutlet UILabel* nobizi;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView* progressIndicator;
@property (nonatomic,retain) IBOutlet UIButton* refresh;

- (void)showHelpView;
- (void)hideHelpView;
-(void)loadStations;
-(IBAction)centerMap:(id)caller;

-(IBAction)runRefresh;
@end
