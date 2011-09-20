//
//  ConfigurationViewController.h
//  ZaragozaMap
//
//  Created by Daniel Vela on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigurationDelegate.h"


@interface ConfigurationViewController : UIViewController {
	UIView* parentView;
	
	UIView* blackView;
	
	BOOL viewActive;
	
	id<ConfigurationDelegate> delegate;
    UIButton *marcadoresButton;
    UIButton *informacionButton;
}
@property (nonatomic, retain) IBOutlet UIButton *marcadoresButton;
@property (nonatomic, retain) IBOutlet UIButton *informacionButton;

@property (nonatomic, assign) UIView* parentView;
@property (nonatomic, retain) IBOutlet UIView* blackView;
@property (nonatomic, assign) id<ConfigurationDelegate> delegate;

- (void)layoutSubView:(BOOL)show;

- (IBAction)confButtonTouched;
- (IBAction)filterButtonTouched;
- (IBAction)infoButtonTouched:(id)sender;

@end
