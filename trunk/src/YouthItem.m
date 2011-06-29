//
//  YouthItem.m
//  ZaragozaMap
//
//  Created by Daniel Vela on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YouthItem.h"


@implementation YouthItem

@synthesize longitude, latitude;
@synthesize title;
@synthesize url;

- (CLLocationCoordinate2D)coordinate
{
    coordinate.latitude = self.latitude;
    coordinate.longitude = self.longitude;
    return coordinate;
}

@end
