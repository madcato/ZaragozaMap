//
//  BusEntry.h
//  zgzbus
//
//  Created by Daniel Vela on 6/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BusEntry : NSObject {
	NSString *busNumber; 
	NSString *busDestination;
	NSString *busWaitTime;
}

@property (nonatomic, retain) NSString *busNumber;
@property (nonatomic, retain) NSString *busDestination;
@property (nonatomic, retain) NSString *busWaitTime;

@end
