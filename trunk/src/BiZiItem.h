//
//  BiZiItem.h
//  ZaragozaMap
//
//  Created by Daniel Vela on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BiZiItem : NSObject <MKAnnotation> {
	double latitude;
    double longitude;
	NSString* idStation;
	NSString* addressNew;
    NSString* availableBikes;
    NSString* freeSlots;
    NSDate* timedate;
	
	CLLocationCoordinate2D coordinate;
}

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, retain) NSString* idStation;
@property (nonatomic, retain) NSString* addressNew;
@property (nonatomic, retain) NSString* availableBikes;
@property (nonatomic, retain) NSString* freeSlots;
@property (nonatomic, retain) NSDate *timedate;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end
