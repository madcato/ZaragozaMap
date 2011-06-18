//
//  XMLParser.h
//  zgzbus
//
//  Created by Daniel Vela on 6/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BiZiResponse.h"
#import "WebRequestXML.h"


@interface XMLParser : NSObject <NSXMLParserDelegate> {
	
	NSMutableString *currentElementValue;
	
	id<WebRequestXMLDelegate> delegate;
	BiZiResponse* response;
	int tables;

}

@property (nonatomic, retain) BiZiResponse* response;

- (XMLParser *) initXMLParser:(id<WebRequestXMLDelegate>)object;	



@end
