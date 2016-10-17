//
//  FirstViewController.m
//  iWoman
//
//  Created by Yulian Simeonov on 5/6/12.
//  Copyright (c) 2012 __YulianMobile__. All rights reserved.
//

#import "FirstViewController.h"
#import "AppDelegate.h"

@implementation FirstViewController
@synthesize mTableViewShop;
@synthesize mFieldLabels;
@synthesize JSONResult;
@synthesize mActivityIndicator;
@synthesize appDelegate = _appDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Shop", @"Shop");
        self.tabBarItem.image = [UIImage imageNamed:@"shop_ico"];
        
                
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(goHome:)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(goSettings:)];
    [self.navigationItem setRightBarButtonItem:rightButton];
    
    [self.mActivityIndicator startAnimating];
    
    TSearchInfo *registerAPI = [[TSearchInfo alloc] initWithWebAPIName:@"http://srvc.prooxima.com:80/shopHub.class.php?step=0&lang=EN"];
    NSString *registerAPIName = [registerAPI generateAsUrlParam];
    TWebApi *registerWebAPI = [[[TWebApi alloc] initWithFullApiName:registerAPIName andAlias:@"STREAM"] autorelease];
    
    [registerWebAPI runApiSuccessCallback:@selector(webApiSuccessWithAlias:andData:) FailCallback:@selector(webApiFailWithAlias:andError:) inDelegate:self];
    
    
    
    mSectionArray = [[NSMutableArray alloc] init];
    mContentArray = [[NSMutableArray alloc] init];

    
    [backButton release];
    [rightButton release];
    
    
}

-(void) webApiSuccessWithAlias:(NSString *)alias andData:
(NSData *)data {
    self.JSONResult = [[NSMutableDictionary alloc] init];
	if ([alias isEqualToString:@"STREAM"]) {
		if (data) {
			char *cache = calloc(1, [data length]);
			memcpy(cache, [data bytes], [data length]);
			NSString *rawData = [NSString stringWithCString:cache encoding:NSUTF8StringEncoding];
            free (cache);
            
            self.JSONResult = [rawData JSONValue];
            
            [mTableViewShop reloadData];
            
            int count = 0;
            NSArray *nsArrayKey = [[NSArray alloc] initWithArray:[self.JSONResult allKeys]];
            count = [nsArrayKey count] - 1;  
            NSArray* groupArray = [self.JSONResult objectForKey:GROUPS];
            for(int i=0; i<groupArray.count; i++) {
                
                [mSectionArray addObject:[[groupArray objectAtIndex:i] objectForKey:@"name"]];
                NSArray* contentArray = [[groupArray objectAtIndex:i] objectForKey:FAMILIES];
                NSMutableArray *content1 = [[NSMutableArray alloc] init];
                for(int j=0; j<contentArray.count; j++) {
                    
                    [content1 addObject:[contentArray objectAtIndex:j]];
                }
                [mContentArray addObject:content1];
                [content1 release];
            }
            [nsArrayKey release];
            [mTableViewShop reloadData];
        }
    }
    [self.mActivityIndicator stopAnimating];
    [self.mActivityIndicator setHidden:YES];
}

-(void) webApiFailWithAlias:(NSString *)alias {
    
    NSLog(@"%@", alias);
}

- (void) doLoading {
    [mTableViewShop reloadData];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (IBAction) goHome:(id)sender {
    // Don't pass current value to the edited object, just pop.
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(self.appDelegate.homeView.isHidden) {
        [self.appDelegate.homeView setHidden:NO];
    }

}

- (IBAction) goSettings:(id)sender {

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    ShopDetailsViewController *shopDetailsView = [[[ShopDetailsViewController alloc] initWithNibName:@"ShopDetailsViewController_iPhone" bundle:nil] autorelease];
    
    NSDictionary *dict = [[mContentArray objectAtIndex:section] objectAtIndex:row];
    
    NSLog(@"%@", [dict objectForKey:@"ico"]);
    
    shopDetailsView.mImgUrl = [dict objectForKey:@"ico"];
    shopDetailsView.mProdName = [mSectionArray objectAtIndex:row];
    
    [AppDelegate sharedAppDelegate].curProdName = shopDetailsView.mProdName;
    [AppDelegate sharedAppDelegate].curProdIco = shopDetailsView.mImgUrl;
    [AppDelegate sharedAppDelegate].curProdID = [dict objectForKey:@"id"];
    
    [self.navigationController pushViewController:shopDetailsView animated:YES];
	// get the element that is represented by the selected row.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {

    return mSectionArray.count;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section {
    
    int count = 0;
    if ([mContentArray count] != 0)
        count = [[mContentArray objectAtIndex:section] count];
    return count;
}


- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(mSectionArray != nil) {
        if(mSectionArray.count != 0) {
            return [mSectionArray objectAtIndex:section];
        }
    }
    return @"test";
}
- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"MainCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 160, 25)];
        label.tag = kLabelTag;
        label.font = [UIFont boldSystemFontOfSize:16];
        label.textColor =  [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
        label.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:label];
        [label release];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(200, 10, 70, 25)];
        label1.tag = kLabelAlertTag;
        label1.font = [UIFont boldSystemFontOfSize:16];
        label1.textColor =  [UIColor colorWithRed:77.0f/255.0f green:109.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
        label1.backgroundColor = [UIColor clearColor];
        label1.textAlignment = UITextAlignmentRight;
        [cell.contentView addSubview:label1];
        [label1 release];
    }
   
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
	UILabel *label = (UILabel *)[cell viewWithTag:kLabelTag];
	UILabel *labelAlert = (UILabel *)[cell viewWithTag:kLabelAlertTag];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSDictionary *dict = [[mContentArray objectAtIndex:section] objectAtIndex:row];
    NSLog(@"%@", [dict objectForKey:@"name"]);
    label.text = [dict objectForKey:@"name"];
    NSLog(@"%@", [dict objectForKey:@"alert"]);
    id value = [dict objectForKey:@"alert"];
    if (![value isMemberOfClass:[NSNull class]]) {
        labelAlert.text = [dict objectForKey:@"alert"];   
    }
    return cell;
}    

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)dealloc {
    [mSectionArray release];
    [mContentArray release];
    [mTableViewShop release];
    [mFieldLabels release];
    [JSONResult release];
    [mActivityIndicator release];
    [_appDelegate release];
    [super dealloc];
}
@end
