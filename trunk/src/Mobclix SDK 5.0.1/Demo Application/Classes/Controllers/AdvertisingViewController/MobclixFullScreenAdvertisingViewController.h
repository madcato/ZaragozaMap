//
//  MobclixFullScreenAdvertisingViewController.h
//  MobclixDemo
//
//  Copyright 2011 Mobclix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobclixFullScreenAdViewController.h"

@interface MobclixFullScreenAdvertisingViewController : UIViewController<MobclixFullScreenAdDelegate> {
@private
	MobclixFullScreenAdViewController* fullScreenAdViewController;
}

- (IBAction)requestAd:(UIButton*)button;
- (IBAction)displayAd:(UIButton*)button;

- (IBAction)requestAndDisplayAd:(UIButton*)button;

@property(nonatomic,assign) IBOutlet UIButton* requestAdButton;
@property(nonatomic,assign) IBOutlet UIButton* displayAdButton;
@property(nonatomic,assign) IBOutlet UIButton* requestAndDisplayAdButton;
@end
