//
//  WebRequestXML.m
//  
//
//  Created by Daniel Vela on 4/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WebRequestXML.h"
#import "XMLParser.h"

@implementation WebRequestXML

@synthesize receiver;
@synthesize m_connection;

-(void)downloadXML:(NSString*)url forStation:(NSString*)idStation withAddressNew:(NSString*)addressNew withDelegate:(id<WebRequestXMLDelegate>)delegate
{
	NSString *scaped_url = [url stringByAddingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding];// NSUTF8StringEncoding];
//NSLog(@"Escaped URL %@",scaped_url);	
	receiver = delegate;

	responseData = [[NSMutableData data] retain];
	
//NSLog(@"station:%@ addressnew:%@",idStation,addressNew);
	NSString* param = [[NSString alloc]initWithFormat:@"idStation=%@&addressnew=%@&s_id_idioma=es",idStation,addressNew];
	
	
	NSData* buffer;
	buffer = [param dataUsingEncoding: NSISOLatin1StringEncoding];
	
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:scaped_url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0] autorelease];
	[request setHTTPMethod:@"POST"];
    [request setHTTPBody:buffer];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[buffer length]] forHTTPHeaderField:@"Content-Length"];
	
	m_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	
}

-(void)dealloc {
    [self cancelRequest];
    [m_connection release];
    [super dealloc];
}
-(void)cancelRequest {
	[m_connection cancel];
}
/*
- (void) checkOut:(NSObject*)rec {
	
	mode = 1;
	receiver = rec;
	
	
	
	NSString *url = [NSString stringWithFormat:@"http://listacompra.veladan.org/articles/checkout"];
	responseData = [[NSMutableData data] retain];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	

}
*/

/*
-(void)checkIn:(NSDictionary*)data withDelegate:(NSObject*)delegate {
	mode = 2;
	
	
	NSError* error;
	SBJSON *parser = [[SBJSON new] init];
	
	NSString *object = [parser stringWithObject:data error:&error];
	
	NSString* param = [[NSString alloc]initWithFormat:@"checkin=%@",object];
	
	
	receiver = delegate;
	
	NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://listacompra.veladan.org/articles/checkin"]] ;
	responseData = [[NSMutableData data] retain];
	//	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	
	
	
	
	NSData* buffer;
	buffer = [param dataUsingEncoding: NSUTF8StringEncoding];
	
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0] autorelease];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:buffer];
	//	[request setHTTPBody: [[[NSString alloc] initWithString: @"text=yourValueGoesHere"] dataUsingEncoding: NSASCIIStringEncoding]];
    [request setValue:[NSString stringWithFormat:@"%d", [buffer length]] forHTTPHeaderField:@"Content-Length"];
	
	
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

*/
-(BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	NSString* authMethod = [protectionSpace authenticationMethod];
	
	if(authMethod == NSURLAuthenticationMethodHTTPDigest) {
		return YES;
	}
	
	return NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	
	if([challenge previousFailureCount] > 0){
		[[challenge sender] cancelAuthenticationChallenge:challenge];
	}

    NSString *user = @"catastro";
    NSString *pass = @"Cf4TgH";
    
	
    NSURLCredential *creds = [NSURLCredential credentialWithUser:user password:pass persistence:NSURLCredentialPersistenceForSession];
    [[challenge sender] useCredential:creds forAuthenticationChallenge:challenge];

}




- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	//	signText.text = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
	errorDescription = [NSString stringWithFormat:@"Connection failed: %@", [error localizedDescription]];
	[self handleError:error];
	
	[receiver requestDidFinishWithError:error];

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
		
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSISOLatin1StringEncoding];
	[responseData release];
//	NSLog(@"RESPONSE::::%@:::",responseString);	
	/*responseString = [responseString stringByReplacingOccurrencesOfString:@".css\">" withString:@".css\"></link>"];
	responseString = [responseString stringByReplacingOccurrencesOfString:@"</HTML>" withString:@"</html>"];
	*/
	
	responseString = [responseString stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
	responseString = [responseString stringByReplacingOccurrencesOfString:@"<br />" withString:@""];

	
	responseString = [NSString stringWithFormat:@"<XML>%@</XML>",responseString];
	
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]]; //NSISOLatin1StringEncoding]];
	
	//Initialize the delegate.
	XMLParser *parser = [[XMLParser alloc] initXMLParser:receiver];
	
	//Set delegate
	[xmlParser setDelegate:parser];
	
	//Start parsing the XML file.

	BOOL success = [xmlParser parse];
	
	if(success) {
		
//NSLog(@"No XML Errors");

		[receiver requestFinishedWithBiZi:parser.response];
	}
	else
		[self handleError:[NSError errorWithDomain:@"Se ha producido un error al procesar los resultados." code:0 userInfo:nil]];
	
	

	
	
	
	
/*	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSISOLatin1StringEncoding];
	[responseData release];
	
	
	if((responseString == nil) || ([responseString isEqualToString:@""])) {
		[receiver requestFinishedWithArray:[NSArray array]];
		return;
	}
	// if responseString == nil check the encoding of the response it can be UT8 instead Latin1.
//NSLog(@"Response:%@--",responseString );
	if([[responseString substringToIndex:8] compare:@"notFound"] == NSOrderedSame) {
		[receiver requestFinishedWithArray:[NSArray array]];
		 return;
	}
	NSError* error;
	SBJSON *parser = [[SBJSON new] init];
		
	NSObject *object = [parser objectWithString:responseString error:&error];
		
		
	if (object == nil) 
	{
		errorDescription = [NSString stringWithFormat:@"JSON parsing failed: %@", [error localizedDescription]];
		[self handleError:error];
		[receiver requestDidFinishWithError:error];
	} 
	else 
	{
		NSDictionary* dict = (NSDictionary*)object;
		dict = [dict objectForKey:@"response"];
		dict = [dict objectForKey:@"data"];
		
		if([dict isKindOfClass:[NSDictionary class]] ) 
		{
			NSDictionary* dictionary = (NSDictionary*)dict;
			[receiver requestFinishedWithDictionary:dictionary];
		} 
		else if([dict isKindOfClass:[NSArray class]]) 
		{
			NSArray* array = (NSArray*)dict;
			[receiver requestFinishedWithArray:array];
		} else {
			NSError* error = [NSError errorWithDomain:@"WebRequestXML: invalid JSON data type" code:0 userInfo:nil];
			[self handleError:error];
			[receiver requestDidFinishWithError:error];
		}
	}*/
}


// -------------------------------------------------------------------------------
//	handleError:error
// -------------------------------------------------------------------------------
- (void)handleError:(NSError *)error
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ZgZmap"
														message:errorMessage
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}


@end
