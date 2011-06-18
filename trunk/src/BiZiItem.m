//
//  BiZiItem.m
//  ZaragozaMap
//
//  Created by Daniel Vela on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BiZiItem.h"


@implementation BiZiItem

@synthesize longitude, latitude;
@synthesize idStation;
@synthesize addressNew;

- (CLLocationCoordinate2D)coordinate
{
    coordinate.latitude = self.latitude;
    coordinate.longitude = self.longitude;
    return coordinate;
}

@end
