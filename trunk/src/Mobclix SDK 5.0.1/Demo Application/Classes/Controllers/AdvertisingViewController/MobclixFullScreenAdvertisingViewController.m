//
//  MobclixFullScreenAdvertisingViewController.m
//  MobclixDemo
//
//  Copyright 2011 Mobclix. All rights reserved.
//

#import "MobclixFullScreenAdvertisingViewController.h"


@implementation MobclixFullScreenAdvertisingViewController
@synthesize requestAdButton, displayAdButton, requestAndDisplayAdButton;

- (id)init {
	if((self = [super initWithNibName:@"MobclixFullScreenAdvertisingView" bundle:nil])) {
		fullScreenAdViewController = [[MobclixFullScreenAdViewController alloc] init];
		fullScreenAdViewController.delegate = self;
		self.title = @"Full Screen Ads";
	}

	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.displayAdButton.enabled = NO;
}
 
- (IBAction)requestAd:(UIButton*)button {
	self.requestAdButton.enabled = NO;
	self.displayAdButton.enabled = NO;
	self.requestAndDisplayAdButton.enabled = NO;
	[fullScreenAdViewController requestAd];
}

- (IBAction)displayAd:(UIButton*)button {
	[fullScreenAdViewController displayRequestedAdFromViewController:self];
	self.displayAdButton.enabled = NO;
	self.requestAdButton.enabled = YES;
	self.requestAndDisplayAdButton.enabled = YES;
}

- (IBAction)requestAndDisplayAd:(UIButton*)button {
	[fullScreenAdViewController requestAndDisplayAdFromViewController:self];
	self.displayAdButton.enabled = NO;
	self.requestAdButton.enabled = NO;
	self.requestAndDisplayAdButton.enabled = NO;
}

- (void)fullScreenAdViewControllerDidFinishLoad:(MobclixFullScreenAdViewController*)fullScreenAdViewController {
	NSLog(@"Full screen ad was loaded");

	self.displayAdButton.enabled = YES;
	self.requestAdButton.enabled = NO;
	self.requestAndDisplayAdButton.enabled = NO;
}

- (void)fullScreenAdViewController:(MobclixFullScreenAdViewController*)fullScreenAdViewController didFailToLoadWithError:(NSError*)error {
	NSLog(@"Failed to load full screen ad");

	self.requestAdButton.enabled = YES;
	self.displayAdButton.enabled = NO;
	self.requestAndDisplayAdButton.enabled = YES;
	
	UIAlertView* alertView = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to load a full screen ad.  Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alertView show];
}

- (void)fullScreenAdViewControllerWillPresentAd:(MobclixFullScreenAdViewController*)fullScreenAdViewController {
	NSLog(@"Full screen ad will be presented");
}

- (void)fullScreenAdViewControllerDidDismissAd:(MobclixFullScreenAdViewController*)fullScreenAdViewController {
	NSLog(@"Full screen ad was dismissed");
	self.displayAdButton.enabled = NO;
	self.requestAdButton.enabled = YES;
	self.requestAndDisplayAdButton.enabled = YES;
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.requestAdButton = nil;
	self.displayAdButton = nil;
}


- (void)dealloc {
	fullScreenAdViewController.delegate = nil;
	[fullScreenAdViewController release];
	
    [super dealloc];
}


@end
