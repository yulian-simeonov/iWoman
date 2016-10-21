//
//  FifthViewController.m
//  iWoman
//
//  Created by Yulian Simeonov on 5/7/12.
//  Copyright (c) 2012 __YulianMobile__. All rights reserved.
//

#import "FifthViewController.h"

@implementation FifthViewController

@synthesize mTableViewContacts;
@synthesize mContentArray;
@synthesize mSectionArray;
@synthesize mFieldLabels;
@synthesize mChatRoomViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Chat", @"Chat");
        self.tabBarItem.image = [UIImage imageNamed:@"chat_ico"];
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
	self.mChatRoomViewController = [[[ChatRoomViewController alloc] initWithNibName:@"ChatRoomViewController_iPhone" bundle:nil] autorelease];
    [self.navigationController pushViewController:mChatRoomViewController animated:YES];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
    
    mSectionArray = [[NSArray arrayWithObjects:@"Local Chat<GroupName>", @"Saturday", @"Friday", nil] retain];
    
    return [mSectionArray count];
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0) {
        mContentArray = [[NSArray arrayWithObjects:@"Local Chat<GroupName>", nil] retain]; 
    }
    if(section == 1) {
        mContentArray = [[NSArray arrayWithObjects:@"James", @"Angela", nil] retain]; 
    }
    if(section == 2) {
        mContentArray = [[NSArray arrayWithObjects:@"Marie", @"Group name+avatar", nil] retain]; 
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
            array = [[NSArray arrayWithObjects:@"Explanation", nil] retain]; 
            self.mFieldLabels = array;
            break;
        case 1:
            array = [[NSArray arrayWithObjects:@"James", @"Angela", nil] retain]; 
            self.mFieldLabels = array;
            break;
        case 2:
            array = [[NSArray arrayWithObjects:@"Marie", @"Group name+avatar", nil] retain]; 
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
    [mTableViewContacts release];
    mTableViewContacts = nil;
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
    [mChatRoomViewController release];
    [super dealloc];
}
@end
