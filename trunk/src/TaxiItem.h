//
//  TaxiItem.h
//  ZaragozaMap
//
//  Created by Daniel Vela on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TaxiItem : NSObject <MKAnnotation> {
	double latitude;
    double longitude;
	NSString* title;
	
	CLLocationCoordinate2D coordinate;
}

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, copy) NSString* title;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end
