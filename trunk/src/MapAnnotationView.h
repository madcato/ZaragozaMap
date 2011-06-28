//
//  MapAnnotationView.h
//  ZaragozaMap
//
//  Created by Daniel Vela on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapManagementProtocol.h"
#import "BiZiItem.h"

@interface MapAnnotationView : MKAnnotationView <UIGestureRecognizerDelegate> {
	long num_bizis;
	long nun_huecos;
	
	id<MapManagementProtocol> delegate;

	NSString* imageName;
}


@property (nonatomic, assign) long num_bizis;
@property (nonatomic, assign) long num_huecos;
@property (nonatomic, retain) NSString* imageName;

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier  withDelegate:(id<MapManagementProtocol>) dele;

@end
