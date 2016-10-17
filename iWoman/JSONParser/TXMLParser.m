//
//  TXMLParser.m
//  barton_wyatt_clone
//
//  Created by Zhao Ling on 11/4/11.
//  Copyright 2011 __YulianMobile__. All rights reserved.
//

#import "TXMLParser.h"


@implementation TXMLParser

-(TXMLParser *)initWithAlias:(NSString *)xmlAlias {
	NSString *_xmlAlias;
	//nil safe
	if (xmlAlias) _xmlAlias = xmlAlias;
	else _xmlAlias = [NSString stringWithString:@""];
	
	m_xmlAlias = [[NSString alloc] initWithString:_xmlAlias];
	return self;
}

-(void) alloc {
	m_parser = nil;
	m_parsedDict = nil;
	m_xmlAlias = nil;
	m_currentPosition = nil;
	m_currentString = nil;
}

-(void) dealloc {
	if (m_parser) [m_parser release];
	if (m_parsedDict) [m_parsedDict release];
	if (m_xmlAlias) [m_xmlAlias release];
	if (m_currentPosition) [m_currentPosition release];
	if (m_currentString) [m_currentString release];
	[super dealloc];
}

-(void)parse:(NSData *)data successCallback:(SEL)successSelector failCallback:(SEL)failSelector inDelegate:(NSObject *)delegateObj {
	NSLog(@"XMLParser: Parsing started.");
	if (m_parsedDict) {
		[m_parsedDict release]; m_parsedDict = nil;
	}
	if (m_parser) {
		[m_parser release]; m_parser = nil;
	}
	if (m_currentPosition) {
		[m_currentPosition release]; m_currentPosition = nil;
	}
	if (m_currentString) {
		[m_currentString release]; m_currentString = nil;
	}
	m_delegate = delegateObj;
	m_successCallback = successSelector;
	m_failCallback = failSelector;
	m_parser = [[NSXMLParser alloc] initWithData:data];
	[m_parser setDelegate:self];
	[m_parser parse];
	
}


- (void)parserDidStartDocument:(NSXMLParser *)parser {
	m_currentPosition = [[NSMutableArray alloc] init];
	m_parsedDict = [[NSMutableDictionary alloc] init];
	[m_currentPosition addObject:m_parsedDict];
	m_currentString = [[NSMutableString alloc] initWithString:@""];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	NSLog(@"XMLParser:Finished Parsing");
	[m_parsedDict writeToFile:@"1.plist" atomically:YES];
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	NSMutableDictionary *lastPosition = [m_currentPosition lastObject];
	if (!lastPosition) return;
	
	NSMutableDictionary *newElement = [[NSMutableDictionary alloc] init];
	[newElement setObject:attributeDict forKey:@"attr"];
	[newElement setObject:elementName forKey:@"name"];

	if (!m_currentString) m_currentString = [[NSMutableString alloc] initWithString:@""];
	
	NSMutableArray *childDict = [lastPosition objectForKey:@"child"];
	
	if (!childDict) {
		NSMutableArray *child = [[NSMutableArray alloc] init];
		[lastPosition setObject:child forKey:@"child"];
		childDict = child;
		[child release];
	}
	
	[childDict addObject:newElement];
	[m_currentPosition addObject:newElement];
	[newElement release];
	NSLog(@"element start:%@", elementName);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	[m_currentString appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	NSMutableDictionary *lastPosition = [m_currentPosition lastObject];
	if (!lastPosition) return;
	
	[lastPosition setObject:[m_currentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"data"];
	NSLog(@"data:%@", m_currentString);
	[m_currentString release];
	m_currentString = [[NSMutableString alloc] initWithString:@""];
	
	[m_currentPosition removeLastObject];
	NSLog(@"element end:%@", elementName);
}
@end
