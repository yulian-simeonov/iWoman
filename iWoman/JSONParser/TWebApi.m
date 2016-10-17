//
//  TWebApi.m
//  barton_wyatt_clone
//
//  Created by Zhao Ling on 11/3/11.
//  Copyright 2011 __YulianMobile__. All rights reserved.
//

#import "TWebApi.h"


@implementation TWebApi

-(TWebApi *) initWithFullApiName:(NSString *)fullApiName andAlias:(NSString *)apiAlias {
	NSString *_apiAlias;
	NSString *_fullApiName;
	
	//nil safe
	if (apiAlias) _apiAlias = apiAlias;
	else _apiAlias = [NSString stringWithString:@""];
	
	if (fullApiName) _fullApiName = fullApiName;
	else _fullApiName = [NSString stringWithString:@""];
	
	m_apiAlias = [[NSString alloc] initWithString:_apiAlias];
	m_fullApiName = [[NSString alloc] initWithString:_fullApiName];
	return self;
}

-(void)runApiSuccessCallback:(SEL)successSelector FailCallback:(SEL)failSelector inDelegate:delegateObj {
	NSLog(@"WEBAPI: Running web api: %@", m_fullApiName);
	if (m_data) {
		[m_data release]; m_data = nil;
	}
	
	NSURL *_url = [NSURL URLWithString:m_fullApiName];
	NSURLRequest *_request = [NSURLRequest requestWithURL:_url];

	m_con = [[NSURLConnection alloc] initWithRequest:_request delegate:self];
	m_data = [[NSMutableData alloc] init];
	m_delegate = delegateObj;
	m_successCallback = successSelector;
	m_failCallback = failSelector;
}

-(void) alloc {
	m_con = nil;
	m_successCallback = nil;
	m_failCallback = nil;
	m_apiAlias = nil;
	m_fullApiName = nil;
	m_delegate = nil;
	m_data = nil;
}

-(void) dealloc {
	if (m_con) [m_con release];
	if (m_apiAlias) [m_apiAlias release];
	if (m_fullApiName) [m_fullApiName release];
	if (m_data) [m_data release];
	[super dealloc];
}

- (void)connection:(NSURLConnection *)theConnection	didReceiveData:(NSData *)incrementalData {
	NSLog(@"WEBAPI: Received data.");
    [m_data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {	
    NSLog(@"WEBAPI: Finished data loading.");
	if (!m_successCallback || !m_delegate) return;
	NSLog(@"WEBAPI: Calling success callback.");
	[m_delegate performSelector:m_successCallback withObject:m_apiAlias withObject:m_data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"WEBAPI: Error occured. Errorcode:%@", [error localizedDescription]);
	if (!m_failCallback || !m_delegate) return;
	[m_delegate performSelector:m_failCallback withObject:m_apiAlias withObject:error];
}
@end
