//
//  ForthViewController.m
//  iWoman
//
//  Created by Yulian Simeonov on 5/7/12.
//  Copyright (c) 2012 __YulianMobile__. All rights reserved.
//

#import "ForthViewController.h"

@implementation ForthViewController
@synthesize mTableViewContacts;
@synthesize mContentArray;
@synthesize mSectionArray;
@synthesize mFieldLabels;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Contacts", @"Contacts");
        self.tabBarItem.image = [UIImage imageNamed:@"contacts_ico"];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(goHome:)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(goSettings:)];
    [self.navigationItem setRightBarButtonItem:rightButton];
    
    [backButton release];
    [rightButton release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSUInteger row = [indexPath row];
	
	// get the element that is represented by the selected row.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
    
    mSectionArray = [[NSArray arrayWithObjects:@"Contacts", @"", nil] retain];
    return [mSectionArray count];
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0) {
        mContentArray = [[NSArray arrayWithObjects:@"All", nil] retain]; 
    }
    if(section == 1) {
        mContentArray = [[NSArray arrayWithObjects:@"Favorites", @"Online", @"Blocked", nil] retain]; 
    }
    return [mContentArray count];
}


- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [mSectionArray objectAtIndex:section];
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MainCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *array = [[NSArray alloc] init];
    switch (indexPath.section) {
        case 0:
            array = [[NSArray arrayWithObjects:@"All", nil] retain]; 
            self.mFieldLabels = array;
            break;
        case 1:
            array = [[NSArray arrayWithObjects:@"Favorites", @"Online", @"Blocked", nil] retain]; 
            self.mFieldLabels = array;
            break;
        default:
            break;
    }
    [array release];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 25)];
		label.tag = kLabelTag;
		label.font = [UIFont boldSystemFontOfSize:16];
		label.textColor =  [UIColor colorWithRed:77.0f/255.0f green:109.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
		label.backgroundColor = [UIColor clearColor];
		[cell.contentView addSubview:label];
		[label release];
    }
    NSUInteger row = [indexPath row];
	UILabel *label = (UILabel *)[cell viewWithTag:kLabelTag];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    label.text = [mFieldLabels objectAtIndex:row];
    return cell;
}  

- (void)viewDidUnload
{
    [self setMTableViewContacts:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)dealloc {
    [mTableViewContacts release];
    [super dealloc];
}
@end
