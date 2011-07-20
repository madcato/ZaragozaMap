//
//  AlertViewController.h
//  ZaragozaMap
//
//  Created by Daniel Vela on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MODE_HIDE 0
#define MODE_SHOW 1
#define MODE_BUTTON 2

@interface AlertViewController : UIViewController {
	UIView* blackView;
	UIView* parentView;
	
	BOOL viewActive;
}

@property (nonatomic, retain) IBOutlet UIView* blackView;
@property (nonatomic, assign) UIView* parentView;

-(IBAction)hornButtonTouched;

- (void)layoutSubView:(int)mode;

@end
