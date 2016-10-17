//
//  SecondViewController.m
//  iWoman
//
//  Created by Yulian Simeonov on 5/6/12.
//  Copyright (c) 2012 __YulianMobile__. All rights reserved.
//

#import "SecondViewController.h"

@implementation SecondViewController
@synthesize mTableViewHighlights;
@synthesize mFieldLabels;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Highlights", @"Highlights");
        self.tabBarItem.image = [UIImage imageNamed:@"highlights_ico"];
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
    
    mSectionArray = [[NSArray arrayWithObjects:@"Highlights", nil] retain];
    return [mSectionArray count];
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0) {
        mContentArray = [[NSArray arrayWithObjects:@"Item1", @"Item2", @"Item3", @"Item4", nil] retain]; 
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
            array = [mContentArray retain]; 
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

- (IBAction) goHome:(id)sender {
    // Don't pass current value to the edited object, just pop.
    
}

- (IBAction) goSettings:(id)sender {
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(goHome:)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(goSettings:)];
    [self.navigationItem setRightBarButtonItem:rightButton];
    
    [backButton release];
    [rightButton release];
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

- (void)dealloc {
    [mTableViewHighlights release];
    [super dealloc];
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

@end
