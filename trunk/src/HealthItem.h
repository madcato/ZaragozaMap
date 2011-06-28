//
//  HealthItem.h
//  ZaragozaMap
//
//  Created by Daniel Vela on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HealthItem : NSObject <MKAnnotation> {
	double latitude;
    double longitude;
	NSString* name;
	
	CLLocationCoordinate2D coordinate;
}

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, retain) NSString* name;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end