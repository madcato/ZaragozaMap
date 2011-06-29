//
//  TaxiItem.m
//  ZaragozaMap
//
//  Created by Daniel Vela on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TaxiItem.h"


@implementation TaxiItem

@synthesize longitude, latitude;
@synthesize title;

- (CLLocationCoordinate2D)coordinate
{
    coordinate.latitude = self.latitude;
    coordinate.longitude = self.longitude;
    return coordinate;
}

@end
