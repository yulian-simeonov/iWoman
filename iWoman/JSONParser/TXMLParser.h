//
//  TXMLParser.h
//  barton_wyatt_clone
//
//  Created by Zhao Ling on 11/4/11.
//  Copyright 2011 __YulianMobile__. All rights reserved.
//

//call back style
// parseSuccessWithAlias:(NSString *)alias andResult:(NSDictionary *)result
// parseFailWithAlias:(NSString *)alias andError:(NSError *)err
#import <Foundation/Foundation.h>

@interface TXMLParser : NSObject <NSXMLParserDelegate>{
	NSString *m_xmlAlias;
	NSXMLParser *m_parser;
	NSMutableDictionary *m_parsedDict;
	
	NSObject *m_delegate;
	SEL m_successCallback;
	SEL m_failCallback;
	
	NSMutableString *m_currentString;

	NSMutableArray *m_currentPosition;
}

-(TXMLParser *)initWithAlias:(NSString *)xmlAlias;
-(void)parse:(NSData *)data successCallback:(SEL)successSelector failCallback:(SEL)failSelector inDelegate:(NSObject *)delegateObj;

@end
