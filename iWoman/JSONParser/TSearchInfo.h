//
//  TSearchInfo.h
//  barton_wyatt_clone
//
//  Created by Zhao Ling on 11/3/11.
//  Copyright 2011 __YulianMobile__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSearchInfo : NSObject {
	NSMutableDictionary *m_paramMap;
	NSString *m_webApiName;
}

-(TSearchInfo *) initWithWebAPIName:(NSString *)apiName;
-(void) pushSearchField:(NSString *)field andValue:(NSString *)value;
-(NSString *) generateAsUrlParam;
@end
