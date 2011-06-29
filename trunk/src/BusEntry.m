//
//  BusEntry.m
//  zgzbus
//
//  Created by Daniel Vela on 6/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BusEntry.h"


@implementation BusEntry

@synthesize busNumber, busDestination, busWaitTime;

- (id) init {
	self = [super init];
	
	self.busNumber = nil;
	self.busDestination = nil;
	self.busWaitTime = nil;
	
	return self;
}

- (void) dealloc {
	
	[busNumber release];
	[busDestination release];
	[busWaitTime release];
	[super dealloc];
}


@end
