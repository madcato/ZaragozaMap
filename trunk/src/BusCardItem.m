//
//  BusCardItem.m
//  ZaragozaMap
//
//  Created by Daniel Vela on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BusCardItem.h"


@implementation BusCardItem

@synthesize longitude, latitude;
@synthesize name;
@synthesize address;

- (CLLocationCoordinate2D)coordinate
{
    coordinate.latitude = self.latitude;
    coordinate.longitude = self.longitude;
    return coordinate;
}

@end
