//
//  WebRequestTuzsa.m
//  zgzbus
//
//  Created by Daniel Vela on 6/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WebRequestTuzsa.h"
#import "XMLParserBus.h"


@implementation WebRequestTuzsa

-(void)checkOut:(NSString*)url withDelegate:(id<WebRequestXMLDelegateBus>)object {
	
	delegate = object;
	

//NSLog(@"URL: %@",url);
	responseData = [[NSMutableData data] retain];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	//	signText.text = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
	errorDescription = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
	[self handleError:error];
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSISOLatin1StringEncoding];
	[responseData release];

	responseString = [responseString stringByReplacingOccurrencesOfString:@".css\">" withString:@".css\"></link>"];
	responseString = [responseString stringByReplacingOccurrencesOfString:@"</HTML>" withString:@"</html>"];
	
	
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[responseString dataUsingEncoding:NSISOLatin1StringEncoding]];
	
	//Initialize the delegate.
	XMLParserBus *parser = [[XMLParserBus alloc] initXMLParserBus:delegate];
	
	//Set delegate
	[xmlParser setDelegate:parser];
	
	//Start parsing the XML file.
	BOOL success = [xmlParser parse];
	
	if(success)
		[delegate requestFinishedWithBus:parser.response];
	else
		[self handleError:[NSError errorWithDomain:@"Se ha producido un error al procesar los resultados." code:0 userInfo:nil]];


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
