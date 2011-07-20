//
//  BusStopTableViewController.h
//  ZaragozaMap
//
//  Created by Daniel Vela on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebRequestTuzsa.h"
#import "TableViewCell.h"
#import "BusResponse.h"


@interface BusStopTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, WebRequestXMLDelegateBus> {

	UITableView* tableViewController;
	
	UIView* blackView;
	
	WebRequestTuzsa* request;
	
	TableViewCell *tblCell;
	
	BusResponse* data;
	
	UIActivityIndicatorView* progressIndicator;
	
	id<MKAnnotation> lastStation;
	
	UIButton* favButton;
}

@property (nonatomic, retain) IBOutlet TableViewCell *tblCell;
@property (nonatomic,retain) IBOutlet UITableView* tableViewController;
@property (nonatomic,retain) IBOutlet UIView* blackView;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView* progressIndicator;
@property (nonatomic, retain) WebRequestTuzsa* request;

@property (nonatomic, retain) BusResponse* data;
@property (nonatomic, retain) IBOutlet UIButton* favButton;

- (void)layoutSubView:(BOOL)show;
-(void)busStopTouched:(id<MKAnnotation>)station;

-(IBAction)refreshButtonTouched;
-(IBAction)favButtonTouched;

@end
