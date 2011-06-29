//
//  XMLParserBus.h
//  zgzbus
//
//  Created by Daniel Vela on 6/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebRequestTuzsa.h"
#import "BusResponse.h"

@class BusEntry;

@interface XMLParserBus : NSObject <NSXMLParserDelegate> {
	
	NSMutableString *currentElementValue;
	
	id<WebRequestXMLDelegateBus> delegate;
	BusEntry* busEntry;
	int tables;
	BusResponse* response;

}

@property (nonatomic, retain) BusResponse* response;
- (XMLParserBus *) initXMLParserBus:(id<WebRequestXMLDelegateBus>)object;	

@end
