//
//  WebViewController.h
//  ZaragozaMap
//
//  Created by Daniel Vela on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate> {
	UIWebView* web;
	NSString* url;
}

@property (nonatomic, retain) IBOutlet UIWebView* web;
@property (nonatomic,retain) NSString* url;
@end
