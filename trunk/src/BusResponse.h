//
//  BusResponse.h
//  ZaragozaMap
//
//  Created by Daniel Vela on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BusEntry.h"

@interface BusResponse : NSObject {

	NSMutableArray* busEntries;
}

@property (nonatomic, retain) NSMutableArray* busEntries;
@end
