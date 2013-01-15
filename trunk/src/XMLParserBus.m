//
//  XMLParserBus.m
//  zgzbus
//
//  Created by Daniel Vela on 6/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "XMLParserBus.h"
#import "BusEntry.h"


// appDelegate -> RootViewController

@implementation XMLParserBus

@synthesize response;

-(void) dealloc {
	
	[response release];
	[super dealloc];
}

- (XMLParserBus *) initXMLParserBus:(id<WebRequestXMLDelegateBus>)object {
	
	[super init];
	
	tables = 0;
	
	delegate = object;

	response = [[BusResponse alloc] init];
	response.busEntries = [[NSMutableArray alloc]init];
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	
	if([elementName isEqualToString:@"table"]) {
		tables++;
	}
	
	if(tables != 2) return;
//NSLog(@"Processing Element: %@", elementName);
	
	
	if([elementName isEqualToString:@"tr"]){
		busEntry = [[BusEntry alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if(string == nil) {
        string = @"";
    }
    
    if(!currentElementValue){
        
		currentElementValue = [[NSMutableString alloc] initWithString:string];
    } else {
        [currentElementValue appendString:string];
    }
	
	if(tables != 2) return;
//NSLog(@"Processing Value: %@", currentElementValue);
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {

	NSString* elementValue = [currentElementValue copy];
	[elementValue autorelease];
	
    if(elementValue ==nil) elementValue = @"";
	[currentElementValue release];
	currentElementValue = nil;
	
	if(tables != 2) return;
	
	if([elementName isEqualToString:@"table"]) {
		tables++;
	}
	
	if([elementName isEqualToString:@"td"]) {
		if(busEntry.busNumber == nil) {
			busEntry.busNumber = [NSString stringWithString:elementValue];
		} else {
			if(busEntry.busDestination == nil) {
				busEntry.busDestination = [NSString stringWithString:elementValue];
			} else if(busEntry.busWaitTime == nil) {
				busEntry.busWaitTime = [NSString stringWithString:elementValue];
			}
		}
	}
	
	if([elementName isEqualToString:@"tr"]){
		[response.busEntries addObject:busEntry];
		
		[busEntry release];
		busEntry = nil;
	}
	
	//NSLog(@"Processing end Element: %@ - %i", elementName, tables);
	
	
}
@end
