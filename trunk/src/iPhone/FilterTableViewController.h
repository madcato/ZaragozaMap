//
//  FilterTableViewController.h
//  ZaragozaMap
//
//  Created by Daniel Vela on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigurationDelegate.h"


@interface FilterTableViewController : UITableViewController {
	NSMutableDictionary* configuration;
	
	id<ConfigurationDelegate> delegate;
}

@property (nonatomic, retain) NSMutableDictionary* configuration;

@property (nonatomic, assign) id<ConfigurationDelegate> delegate;
@end
