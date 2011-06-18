//
//  XMLParser.m
//  zgzbus
//
//  Created by Daniel Vela on 6/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "XMLParser.h"

// appDelegate -> RootViewController

@implementation XMLParser

@synthesize response;

-(void) dealloc {
	
	[response release];
	[super dealloc];
}

- (XMLParser *) initXMLParser:(id<WebRequestXMLDelegate>)object {
	
	[super init];
	
	tables = 0;
	
	delegate = object;
	
	
	
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	
	if([elementName isEqualToString:@"div"]) {
		tables++;
	}
	

//NSLog(@"Processing Element: %@", elementName);
	
	
	if(tables == 1){
		response = [[BiZiResponse alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	
	if(!currentElementValue)
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
	

//NSLog(@"Processing Value: %@", currentElementValue);
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {

	NSString* elementValue = [currentElementValue copy];
	[elementValue autorelease];
	
	
	if([elementName isEqualToString:@"div"]) {
		if(tables == 2) {
			response.address = currentElementValue;
		} else if (tables == 3) {
			response.bizi = currentElementValue; //PArse
			NSArray* array = [currentElementValue componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \n\r\tç"]];
			int i = 0;
/*			for(NSString* data in array ) {
				NSLog(@"%d %@",i,data);
				i++;
			}
*/			
			if([array count] == 12) {
				response.bizi = [array objectAtIndex:4];
				response.nobizi = [array objectAtIndex:8];
			} else {
				// FIX ME error
			}

		}else if (tables == 4) {
			if(response.timedate == nil) {
				response.timedate = currentElementValue;
			}
		}
	}
	
	[currentElementValue release];
	currentElementValue = nil;


//NSLog(@"Processing end Element: %@ - %i", elementName, tables);
	
	
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSLog(@"Error processing XML: %@",parseError.description);
}
@end
