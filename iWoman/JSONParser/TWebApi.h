//
//  TWebApi.h
//  barton_wyatt_clone
//
//  Created by Zhao Ling on 11/3/11.
//  Copyright 2011 __YulianMobile__. All rights reserved.
//

//call back style
// webApiSuccessWithAlias:(NSString *)alias andData:(NSData *)data
// webApiFailWithAlias:(NSString *)alias andError:(NSError *)err
#import <Foundation/Foundation.h>

@interface TWebApi : NSObject {
	NSURLConnection *m_con;
	NSMutableData *m_data;
	
	NSString *m_apiAlias;
	NSString *m_fullApiName;
	NSObject *m_delegate;
	SEL m_successCallback;
	SEL m_failCallback;
}

-(TWebApi *) initWithFullApiName:(NSString *)fullApiName andAlias:(NSString *)apiAlias;
-(void)runApiSuccessCallback:(SEL)successSelector FailCallback:(SEL)failSelector inDelegate:delegateObj;
@end
