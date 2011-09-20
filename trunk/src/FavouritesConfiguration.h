//
//  FavouritesConfiguration.h
//  ZaragozaMap
//
//  Created by Daniel Vela on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TYPE_BUS 1
#define TYPE_BIZI 2

@interface FavouritesConfiguration : NSObject {

}

+ (FavouritesConfiguration*)sharedInstance;

-(NSMutableArray*)listFavourites;
-(NSMutableDictionary*)listFavouritesAds;
-(void)add:(NSString*)data withType:(int)type;
-(void)remove:(NSString*)data withType:(int)type;
-(BOOL)included:(NSString*)data withType:(int)type;


-(void)saveCustomObject:(NSMutableArray*)object forKey:(NSString*)key;
-(NSMutableArray*)loadCustomObjectWithKey:(NSString*)key;
-(void)saveCustomObject2:(NSMutableDictionary*)object forKey:(NSString*)key;
-(NSMutableDictionary*)loadCustomObjectWithKey2:(NSString*)key;

@end
