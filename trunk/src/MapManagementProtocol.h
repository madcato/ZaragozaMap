//
//  MapManagementProtocol.h
//  ZaragozaMap
//
//  Created by Daniel Vela on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BiZiItem.h"

@protocol MapManagementProtocol

-(void)biziStationTouched:(id<MKAnnotation>)station;
-(void)placeholderTouched:(id<MKAnnotation>)placeholder;
-(void)busStopTouched:(id<MKAnnotation>)busStop;

@end
