//
//  BiZiResponse.h
//  ZaragozaMap
//
//  Created by Daniel Vela on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BiZiResponse : NSObject {

	NSString* bizi;
	NSString* nobizi;
	NSString* timedate;
	NSString* address;
	
}

@property (nonatomic, retain) NSString* bizi;
@property (nonatomic, retain) NSString* nobizi;
@property (nonatomic, retain) NSString* timedate;
@property (nonatomic, retain) NSString* address;

@end
