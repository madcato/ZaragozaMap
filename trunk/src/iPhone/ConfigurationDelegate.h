//
//  ConfigurationDelegate.h
//  ZaragozaMap
//
//  Created by Daniel Vela on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ConfigurationDelegate

-(void)presentFilter;
-(void)dismissFilter;

-(void)presentInfo;
-(void)dismissInfo;

@end
