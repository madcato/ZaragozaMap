//
//  WebRequestJSON.h
//  
//
//  Created by Daniel Vela on 4/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BiziResponse.h"

@protocol WebRequestXMLDelegate
@optional -(void)requestFinishedWithDictionary:(NSDictionary*)dictionary;
@optional -(void)requestFinishedWithArray:(NSArray*)array;
@optional -(void)requestDidFinishWithError:(NSError*)error;
@optional -(void)requestFinishedWithBiZi:(BiZiResponse*)response;
@end


@interface WebRequestXML : NSObject {

	NSMutableData *responseData;
	NSString *errorDescription;
	id<WebRequestXMLDelegate> receiver;
    
    NSURLConnection* m_connection;
};

@property (nonatomic, retain) id<WebRequestXMLDelegate> receiver;
@property (nonatomic, retain) NSURLConnection* m_connection;

-(void)cancelRequest;
-(void)downloadXML:(NSString*)url forStation:(NSString*)idStation withAddressNew:(NSString*)addressNew withDelegate:(id<WebRequestXMLDelegate>)delegate;
-(void)handleError:(NSError *)error;

@end
