//
//  MonumentItem.m
//  ZaragozaMap
//
//  Created by Daniel Vela on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MonumentItem.h"


@implementation MonumentItem

@synthesize longitude, latitude;
@synthesize name;
@synthesize url;

- (CLLocationCoordinate2D)coordinate
{
    coordinate.latitude = self.latitude;
    coordinate.longitude = self.longitude;
    return coordinate;
}

@end
