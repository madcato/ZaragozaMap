//
//  FavouritesConfiguration.m
//  ZaragozaMap
//
//  Created by Daniel Vela on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FavouritesConfiguration.h"

static FavouritesConfiguration *sharedInstance = nil;

@implementation FavouritesConfiguration

-(NSMutableArray*)listFavourites {
	
	NSMutableArray* favs = [self loadCustomObjectWithKey:@"favourites"];
	
	if(favs == nil) {
		favs = [NSMutableArray arrayWithCapacity:0];
		[self saveCustomObject:favs forKey:@"favourites"];
	}
	
	return favs;	
}

-(void)add:(NSString*)data withType:(int)type {
	
	NSMutableArray* favs = [self listFavourites];
	
	[favs addObject:[NSDictionary dictionaryWithObjectsAndKeys:data, @"data", [NSNumber numberWithInt:type], @"type", nil]];
	
	[self saveCustomObject:favs forKey:@"favourites"];	
}

-(void)remove:(NSString*)data withType:(int)type {
	
	NSMutableArray* favs = [self listFavourites];
	
	[favs removeObject:[NSDictionary dictionaryWithObjectsAndKeys:data, @"data", [NSNumber numberWithInt:type], @"type", nil]];
	
	[self saveCustomObject:favs forKey:@"favourites"];	
}

-(BOOL)included:(NSString*)data withType:(int)type {
	
	NSMutableArray* favs = [self listFavourites];
	
	return [favs containsObject:[NSDictionary dictionaryWithObjectsAndKeys:data, @"data", [NSNumber numberWithInt:type], @"type", nil]];
}


-(void)saveCustomObject:(NSMutableArray*)object forKey:(NSString*)key
{ 
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    [prefs setObject:myEncodedObject forKey:key];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSMutableArray*)loadCustomObjectWithKey:(NSString*)key
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [prefs objectForKey:key ];
    NSMutableArray *obj = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    return obj;
}


#pragma mark -
#pragma mark Singleton methods

+ (FavouritesConfiguration*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
        {
			sharedInstance = [[FavouritesConfiguration alloc] init];
			
            // Some extra initialization can be done here
        }
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

@end
