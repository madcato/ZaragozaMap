//
//  BiZiViewController.h
//  ZaragozaMap
//
//  Created by Daniel Vela on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BiZiResponse.h"
#import "WebRequestXML.h"
#import "MapManagementProtocol.h"


#define BIZI_URL @"http://www.bizizaragoza.com/callwebservice/StationBussinesStatus.php"

@interface BiZiViewController : UIViewController <CLLocationManagerDelegate, WebRequestXMLDelegate> {

	UILabel* address;
	UILabel* timedate;
	UILabel* bizi;
	UILabel* nobizi;
	UIActivityIndicatorView* progressIndicator;
	UIButton* refresh;
	UIView* blackView;
	UIButton* favButton;
	
	BOOL alertEmpty;
	BOOL alertFull;
	
	CLLocationManager *locationManager;
	WebRequestXML* request;
	
	id<MKAnnotation> lastStation;
	
	id<MKAnnotation> alertStation;
	
	id<WebRequestXMLDelegate> parent;	
}

@property (nonatomic,assign) id<WebRequestXMLDelegate> parent;
@property (nonatomic,assign) id<MKAnnotation> lastStation;

@property (nonatomic,retain) IBOutlet UILabel* address;
@property (nonatomic,retain) IBOutlet UILabel* timedate;
@property (nonatomic,retain) IBOutlet UILabel* bizi;
@property (nonatomic,retain) IBOutlet UILabel* nobizi;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView* progressIndicator;
@property (nonatomic,retain) IBOutlet UIButton* refresh;
@property (nonatomic,retain) IBOutlet UIView* blackView;
@property (nonatomic, retain) IBOutlet UIButton* favButton;

@property (nonatomic,retain) CLLocationManager* locationManager;
@property (nonatomic,retain) WebRequestXML* request;

- (void)layoutSubView:(BOOL)show;

-(void) setBiziData:(BiZiResponse*)response;

-(IBAction)alertNoBiziButton;
-(IBAction)alertNoDockButton;
-(IBAction)favButtonTouched;

-(void) generateNotificationNow:(NSString*)text;

-(IBAction)runRefresh;

-(void)biziStationTouched:(id<MKAnnotation>)station;

@end
