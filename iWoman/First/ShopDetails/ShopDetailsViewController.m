//
//  ShopDetailsViewController.m
//  iWoman
//
//  Created by Yulian Simeonov on 5/15/12.
//  Copyright (c) 2012 __YulianMobile__. All rights reserved.
//

#import "ShopDetailsViewController.h"

@implementation ShopDetailsViewController

@synthesize mButtonBack;
@synthesize mButtonColor;
@synthesize mButtonSize;
@synthesize mButtonSelect;

@synthesize mUIImageViewItem;
@synthesize mColor;
@synthesize mImgUrl;
@synthesize mSize;
@synthesize mProdName;

@synthesize mActiveIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Shop Details", @"Shop Details");
        
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
    UIImage *imageButtonBg = [UIImage imageNamed:@"select_box"];
    UIImage *imageButtonBg1 = [UIImage imageNamed:@"button_blue_bg"];
    
    [mButtonBack setBackgroundImage:imageButtonBg1 forState:UIControlStateNormal];
    [mButtonColor setBackgroundImage:imageButtonBg forState:UIControlStateNormal];
    [mButtonSize setBackgroundImage:imageButtonBg forState:UIControlStateNormal];
    [mButtonSelect setBackgroundImage:imageButtonBg1 forState:UIControlStateNormal];
    
    [imageButtonBg release];
    [imageButtonBg1 release];
    
    [mActiveIndicator startAnimating];
    if(mImgUrl != nil) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:mImgUrl]];
    
        UIImage *imgBanner = [UIImage imageWithData:data];
        [mUIImageViewItem setImage:imgBanner];
        [mActiveIndicator stopAnimating];
        [mActiveIndicator setHidden:YES];
    }
}

- (void) photoSelectorDidFinish:(MTPopupWindow *)controller
{
    if (controller != nil) {
        self.mColor = controller.color;
        [AppDelegate sharedAppDelegate].curProdColor = controller.color;
        [mButtonColor setTitle:self.mColor forState:UIControlStateNormal];
        [controller closePopupWindow];
    }
}

- (void) photoSizeSelectorDidFinish:(MTPopupWindow *)controller
{
    if (controller != nil) {
        self.mSize = controller.size;
        [AppDelegate sharedAppDelegate].curProdSize = controller.size;
        [mButtonSize setTitle:self.mSize forState:UIControlStateNormal];
        [controller closePopupWindow];
    }
}

- (IBAction)openColorPopup:(id)sender
{
    [MTPopupWindow showWindowWithHTMLFile:@"testContent.html" insideView:self.view delegate:self which:@"color"];
}

- (IBAction)openSizePopup:(id)sender
{
    [MTPopupWindow showWindowWithHTMLFile:@"testContent.html" insideView:self.view delegate:self which:@"size"];
}

- (IBAction)onClickSelect:(id)sender {
    // Don't pass current value to the edited object, just pop.
    CheckoutViewController *checkViewController = [[[CheckoutViewController alloc] initWithNibName:@"CheckoutViewController_iPhone" bundle:nil] autorelease];
    checkViewController.prodNameColor = [NSString stringWithFormat:@"%@ %@", self.mProdName, self.mColor];
    checkViewController.prodSize = [NSString stringWithFormat:@"Size : %@", self.mSize];
    [self.navigationController pushViewController:checkViewController animated:YES];
}

- (IBAction)onClickBack:(id)sender {
    // Don't pass current value to the edited object, just pop.
    [self.navigationController popViewControllerAnimated:YES];
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
    [mUIImageViewItem release];
    [mButtonColor release];
    [mButtonSize release];
    [mButtonSelect release];
    [mButtonBack release];
    [mColor release];
    [mImgUrl release];
    [mActiveIndicator release];
    [mSize release];
    [super dealloc];
}
@end
