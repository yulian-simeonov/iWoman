//
//  CheckoutViewController.m
//  iWoman
//
//  Created by Yulian Simeonov on 5/16/12.
//  Copyright (c) 2012 __YulianMobile__. All rights reserved.
//

#import "CheckoutViewController.h"

@implementation CheckoutViewController

@synthesize mUIButtonCheckout;
@synthesize mUILabelSize;
@synthesize mUILabelColor;
@synthesize prodNameColor = _prodNameColor;
@synthesize prodSize = _prodSize;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Checkout", @"Checkout");
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
    UIImage *imageButtonBg = [UIImage imageNamed:@"button_checkout"];
    [mUIButtonCheckout setBackgroundImage:imageButtonBg forState:UIControlStateNormal];
    [imageButtonBg release];
    [mUILabelColor setText:self.prodNameColor];
    [mUILabelSize setText:self.prodSize];
}

- (IBAction) onClickCheckout:(id)sender {
    
    NSString* pId = [AppDelegate sharedAppDelegate].curProdID;
    NSString* name = [AppDelegate sharedAppDelegate].curProdName;
    NSString* color = [AppDelegate sharedAppDelegate].curProdColor;
    NSString* size = [AppDelegate sharedAppDelegate].curProdSize;
    int cost = 0;
    NSString* jSonStr = [NSString stringWithFormat:@"{'id':'%@','name':'%@','color':'%@','size':'%@','totalCost':'%d'}", pId, name, color, size, cost];
    NSLog(@"%@", jSonStr);
}

- (void)viewDidUnload
{
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
    [mUIButtonCheckout release];
    [mUILabelColor release];
    [mUILabelSize release];
    [_prodNameColor release];
    [_prodSize release];
    [super dealloc];
}
@end
