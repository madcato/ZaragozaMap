//
//  WebRequestTuzsa.h
//  zgzbus
//
//  Created by Daniel Vela on 6/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BusResponse.h"

@protocol WebRequestXMLDelegateBus
@optional -(void)requestDidFinishWithError:(NSError*)error;
@optional -(void)requestFinishedWithBus:(BusResponse*)response;
@end

@interface WebRequestTuzsa : NSObject {
	NSMutableData *responseData;
	NSString *errorDescription;
	id<WebRequestXMLDelegateBus> delegate;
}

-(void)checkOut:(NSString*)url withDelegate:(id<WebRequestXMLDelegateBus>)delegate;
-(void)handleError:(NSError *)error;
@end
