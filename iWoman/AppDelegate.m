//
//  AppDelegate.m
//  iWoman
//
//  Created by Yulian Simeonov on 5/6/12.
//  Copyright (c) 2012 __YulianMobile__. All rights reserved.
//

#import "AppDelegate.h"

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "ForthViewController.h"
#import "FifthViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize mSplashImageView;
@synthesize database = _database;
@synthesize homeView;

@synthesize curProdID = _curProdID;
@synthesize curProdIco = _curProdIco;
@synthesize curProdName = _curProdName;
@synthesize curProdColor = _curProdColor;
@synthesize curProdSize = _curProdSize;
@synthesize myIndicator = _myIndicator;
@synthesize jSONResult = _jSONResult;

#define HeightSegmControl 40.0
#define TextHeight 30.0
#define LeftMargin 10.0
#define RightMargin 10.0
#define TweenMargin 0.0

+ (AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *) [UIApplication sharedApplication].delegate;
}

- (void)dealloc
{
    [_database release];
    [_window release];
    [_tabBarController release];
    
    [homeView release];
    
    [_curProdName release];
    [_curProdID release];
    [_curProdIco release];
    [_curProdColor release];
    [_curProdSize release];
    [_myIndicator release];
    [_jSONResult release];
    
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    [self createEditableCopyOfDatabaseIfNeeded];
    [self writePlist:FILENAME];
    
    self.myIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.window addSubview:self.myIndicator];
	self.myIndicator.center = CGPointMake(160, 240);
    [self.myIndicator startAnimating];
    [self.window makeKeyAndVisible];
    [self getImageFromJSON];
    
    return YES;
}

- (void) setContent {

    UIViewController *viewControllerShop, *viewControllerHighlights, *viewControllerFind, *viewControllerContacts, *viewControllerChat;
    UINavigationController *naviControllerShop, *naviControllerHighlights, *naviControllerFind, *naviControllerContacts, *naviControllerChat;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        viewControllerShop = [[[FirstViewController alloc] initWithNibName:@"FirstViewController_iPhone" bundle:nil] autorelease];
        naviControllerShop = [[UINavigationController alloc] initWithRootViewController:viewControllerShop];
        
        viewControllerHighlights = [[[SecondViewController alloc] initWithNibName:@"SecondViewController_iPhone" bundle:nil] autorelease];
        naviControllerHighlights = [[UINavigationController alloc] initWithRootViewController:viewControllerHighlights];
        
        viewControllerFind = [[[ThirdViewController alloc] initWithNibName:@"ThirdViewController_iPhone" bundle:nil] autorelease];
        naviControllerFind = [[UINavigationController alloc] initWithRootViewController:viewControllerFind];
        
        viewControllerContacts = [[[ForthViewController alloc] initWithNibName:@"ForthViewController_iPhone" bundle:nil] autorelease];
        naviControllerContacts = [[UINavigationController alloc] initWithRootViewController:viewControllerContacts];
        
        viewControllerChat = [[[FifthViewController alloc] initWithNibName:@"FifthViewController_iPhone" bundle:nil] autorelease];
        naviControllerChat = [[UINavigationController alloc] initWithRootViewController:viewControllerChat];
        
    } else {
        viewControllerShop = [[[FirstViewController alloc] initWithNibName:@"FirstViewController_iPad" bundle:nil] autorelease];
        viewControllerHighlights = [[[SecondViewController alloc] initWithNibName:@"SecondViewController_iPad" bundle:nil] autorelease];
    }
    
    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:naviControllerShop, naviControllerHighlights, naviControllerFind, naviControllerContacts, naviControllerChat, nil];
    self.tabBarController.delegate = self;
    [self.window addSubview:self.tabBarController.view];
    
   
    NSMutableDictionary* configInfo = [[AppDelegate sharedAppDelegate].database objectForKey:@"home"];
    NSLog(@"%@", [configInfo objectForKey:@"image"]);
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[configInfo objectForKey:@"image"]]) {
        NSLog(@"exist");
    }
    //UIImage *img = [UIImage imageWithContentsOfFile:[configInfo objectForKey:@"image"]];
    UIImage* img = [UIImage imageNamed:@"home_bg.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 32.0, 320.0, 367.0)];
    [imgView setImage:img];
    homeView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 32.0, 320.0, 367.0)];
    [homeView addSubview:imgView];
    [self.window addSubview:homeView];
    [self SegmentControl];
    [imgView release];
    
    mSplashImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)];
    configInfo = [[AppDelegate sharedAppDelegate].database objectForKey:@"splash"];
    img = [UIImage imageWithContentsOfFile:[configInfo objectForKey:@"image"]];
    [mSplashImageView setImage:img];
    [self.window addSubview:mSplashImageView];
	[self.window bringSubviewToFront:mSplashImageView];	
    [NSTimer scheduledTimerWithTimeInterval:1.0
									 target:self
								   selector:@selector(timeOut:)
								   userInfo:nil
									repeats:NO];
}

- (void)timeOut:(id)_sender
{
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration: 2.0f];
    [UIView setAnimationDelegate: self];
    [UIView setAnimationDidStopSelector:@selector(animationEnded:)];
    mSplashImageView.alpha = 0.0;
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
		[mSplashImageView setFrame: CGRectMake(-320.0, -480.0, 1408.0, 1984.0)];
	}else{
		[mSplashImageView setFrame: CGRectMake(-160.0, -240.0, 640.0, 960.0)];
	}
	
	[UIView commitAnimations];
}	

- (void) getImageFromJSON {
    
    TSearchInfo *registerAPI = [[TSearchInfo alloc] initWithWebAPIName:@"http://srv.prooxima.com/appConfig.class.php?check=updates&lang=EN"];
    NSString *registerAPIName = [registerAPI generateAsUrlParam];
    TWebApi *registerWebAPI = [[[TWebApi alloc] initWithFullApiName:registerAPIName andAlias:@"STREAM"] autorelease];
    
    [registerWebAPI runApiSuccessCallback:@selector(webApiSuccessWithAlias:andData:) FailCallback:@selector(webApiFailWithAlias:) inDelegate:self];
    
    [self.myIndicator release];
}

- (NSString*) saveImageToBundle:(UIImage*)image imgName:(NSString*)imgName {
    
    NSData* imageData = UIImageJPEGRepresentation(image, 90);
//    UIImagePNGRepresentation(image);
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* directory = [paths objectAtIndex:0];
    BOOL isCreated = [fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@/%@", directory, @"iWoman"] withIntermediateDirectories:NO attributes:nil error:NULL];
    if (isCreated) {
        NSLog(@"AlbumDirectory Created!");
    } else {
        NSLog(@"AlbumDirectory Not Created!");
    }
    NSString* dir = [NSString stringWithFormat:@"%@/iWoman/", directory];
    NSString* fullPath = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", imgName]];
    NSLog(@"%@", fullPath);
    [fileManager createFileAtPath:fullPath contents:imageData attributes:nil];
    if ([fileManager fileExistsAtPath:fullPath]) {
        NSLog(@"exist");
    }
    return fullPath;
}

-(void) webApiSuccessWithAlias:(NSString *)alias andData:
(NSData *)data {
    
    self.jSONResult = [[NSMutableDictionary alloc] init];
	if ([alias isEqualToString:@"STREAM"]) {
		if (data) {
			char *cache = calloc(1, [data length]);
			memcpy(cache, [data bytes], [data length]);
			NSString *rawData = [NSString stringWithCString:cache encoding:NSUTF8StringEncoding];
            free (cache);
            
            self.jSONResult = [rawData JSONValue];
            
            NSDictionary* splashDict = [self.jSONResult objectForKey:@"splash"];
            NSDictionary* splashDictOrg = [[[AppDelegate sharedAppDelegate].database objectForKey:@"splash"] mutableCopy];
            NSString* idOrg = [splashDictOrg objectForKey:@"id"];
            if (idOrg == nil) {
                if (splashDict != nil) {
                    NSData* imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[splashDict objectForKey:@"image"]]];
                    UIImage* image = [UIImage imageWithData:imgData];
                    NSString* imgPath = [self saveImageToBundle:image imgName:@"splash"];
                    NSDictionary* newDict = [[NSDictionary alloc] initWithObjectsAndKeys:[splashDict objectForKey:@"id"], @"id", imgPath, @"image", nil];
                    [[AppDelegate sharedAppDelegate].database setObject:newDict forKey:@"splash"];
                    [newDict release];
                    NSLog(@"Splash Image Newly Created!");
                } else {
                    NSLog(@"Splash Image Not Found!");
                }
            } else {
                if ([idOrg intValue] < [[splashDict objectForKey:@"id"] intValue]) {
                    NSData* imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[splashDict objectForKey:@"image"]]];
                    UIImage* image = [UIImage imageWithData:imgData];
                    NSString* imgPath = [self saveImageToBundle:image imgName:@"splash"];
                    NSDictionary* newDict = [[NSDictionary alloc] initWithObjectsAndKeys:[splashDict objectForKey:@"id"], @"id", imgPath, @"image", nil];
                    [[AppDelegate sharedAppDelegate].database setObject:newDict forKey:@"splash"];
                    NSLog(@"Splash Image Updated With New Version!");
                } else {
                    NSLog(@"Splash Image Not Updated");
                }
            }
            
            NSDictionary* homeDict = [self.jSONResult objectForKey:@"home"];
            NSDictionary* homeDictOrg = [[[AppDelegate sharedAppDelegate].database objectForKey:@"home"] mutableCopy];
            idOrg = [homeDictOrg objectForKey:@"id"];
            if (idOrg == nil) {
                if (homeDict != nil) {
                    NSData* imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[homeDict objectForKey:@"image"]]];
                    UIImage* image = [UIImage imageWithData:imgData];
                    NSString* imgPath = [self saveImageToBundle:image imgName:@"home"];
                    NSDictionary* newDict = [[NSDictionary alloc] initWithObjectsAndKeys:[homeDict objectForKey:@"id"], @"id", imgPath, @"image", nil];
                    [[AppDelegate sharedAppDelegate].database setObject:newDict forKey:@"home"];
                    [newDict release];
                    NSLog(@"Home Image Newly Created!");
                } else {
                    NSLog(@"Home Image Not Found!");
                }
            } else {
                if ([idOrg intValue] < [[homeDict objectForKey:@"id"] intValue]) {
                    NSData* imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[homeDict objectForKey:@"image"]]];
                    UIImage* image = [UIImage imageWithData:imgData];
                    NSString* imgPath = [self saveImageToBundle:image imgName:@"home"];
                    NSDictionary* newDict = [[NSDictionary alloc] initWithObjectsAndKeys:[homeDict objectForKey:@"id"], @"id", imgPath, @"image", nil];
                    [[AppDelegate sharedAppDelegate].database setObject:newDict forKey:@"home"];
                    [newDict release];
                    NSLog(@"Home Image Updated With New Version!");
                } else {
                    NSLog(@"Home Image Not Updated");
                }
            }
            [[AppDelegate sharedAppDelegate] writePlist:FILENAME];
        }
    }
    [self setContent];
}

-(void) webApiFailWithAlias:(NSString *)alias {
    
    NSLog(@"%@", alias);
    [[[[UIAlertView alloc] initWithTitle:@"Button Tapped"
                                 message:[NSString stringWithFormat:@"Webservice is not available.Please contact later.", index]
                                delegate:nil
                       cancelButtonTitle:@"OK"
                       otherButtonTitles:nil] autorelease] show];

}

- (void) SegmentControl
{

    NSArray *text = [NSArray arrayWithObjects: @" Pocholo", @"Wi-Fi HTML", nil];
    CGFloat yPlacement = (TweenMargin * 3.0) + HeightSegmControl;
    
    UIImageView *blueImagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, yPlacement-10, 320, 60)]; //create ImageView 
    
    blueImagView.image = [UIImage imageNamed:@"blue_bar.png"];
    [self.homeView addSubview:blueImagView];

    CGRect frame=CGRectMake(LeftMargin, yPlacement, self.homeView.bounds.size.width-(RightMargin *
                                                                                 3.0),TextHeight);
    UISegmentedControl *control= [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects: nil]];
    control = [[UISegmentedControl alloc] initWithItems:text];
    control.frame = frame;
    //control.selectedSegmentIndex = 0;
    [self.homeView addSubview:control];
    [control release];
    // label
    //yPlacement += (mTweenMargin * 3.0) + mSegmentedControlHeight;
    control = [[UISegmentedControl alloc] initWithItems:text];
    frame = CGRectMake(LeftMargin,yPlacement,self.homeView.bounds.size.width-(RightMargin *
                                                                          2.0),HeightSegmControl);
    control.frame = frame;
    control.segmentedControlStyle = UISegmentedControlStyleBar;
    //control.tintColor = [UIColor colorWithRed:0.80 green:0.171 blue:0.5 alpha:1.0];
    control.selectedSegmentIndex = 1;
    [self.homeView addSubview:control];
    [control release];
}

- (void)segmentAction:(id)sender
{

}


- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

- (void)writePlist:(NSString *)fileName {
    
    NSString *documentDirectory = [self applicationDocumentsDirectory];
	NSString *notePath = [documentDirectory stringByAppendingPathComponent:fileName];
    [self.database writeToFile:notePath atomically:YES];
}

- (void)createEditableCopyOfDatabaseIfNeeded {
	// First, test for existence - we don't want to wipe out a user's DB
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *documentDirectory = [self applicationDocumentsDirectory];
	NSString *notePath = [documentDirectory stringByAppendingPathComponent:@"data.plist"];
	
	BOOL dbexits = [fileManager fileExistsAtPath:notePath];
	if (!dbexits) {
        self.database = [NSMutableDictionary dictionaryWithCapacity:20];
    }
    else {
        self.database = [NSMutableDictionary dictionaryWithContentsOfFile:notePath];
    }
}

- (void)animationEnded:(id)_sender
{
    [mSplashImageView removeFromSuperview];
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [homeView setHidden:YES];
}


/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
