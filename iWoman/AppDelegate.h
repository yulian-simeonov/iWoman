//
//  AppDelegate.h
//  iWoman
//
//  Created by Yulian Simeonov on 5/6/12.
//  Copyright (c) 2012 __YulianMobile__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FILENAME @"data.plist"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate> {

    UIImageView *mSplashImageView;
    UIView* homeView;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSMutableDictionary* database;
@property (strong, nonatomic) UITabBarController *tabBarController;

@property (nonatomic, retain)     UIImageView *mSplashImageView;

@property (nonatomic,retain) UIView* homeView;
@property (nonatomic, strong) NSString* curProdName;
@property (nonatomic, strong) NSString* curProdID;
@property (nonatomic, strong) NSString* curProdIco;
@property (nonatomic, strong) NSString* curProdColor;
@property (nonatomic, strong) NSString* curProdSize;
@property (nonatomic, strong) UIActivityIndicatorView *myIndicator;
@property (nonatomic, strong) NSMutableDictionary* jSONResult;

- (NSString *)applicationDocumentsDirectory;
- (void) createEditableCopyOfDatabaseIfNeeded;
- (void) writePlist:(NSString *)fileName;
- (void) SegmentControl;
- (void) getImageFromJSON;
- (void) setContent;
- (NSString*) saveImageToBundle:(UIImage*)image imgName:(NSString*)imgName;
+ (AppDelegate*) sharedAppDelegate;
-(void) webApiFailWithAlias:(NSString *)alias;

@end
