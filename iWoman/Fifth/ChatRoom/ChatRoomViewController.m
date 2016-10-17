//
//  ChatRoomViewController.m
//  iWoman
//
//  Created by Yulian Simeonov on 5/11/12.
//  Copyright (c) 2012 __YulianMobile__. All rights reserved.
//

#import "ChatRoomViewController.h"

@implementation ChatRoomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    
    //For Keyboard Automatically Move
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

//#prboard

- (void) keyboardWillShow: (NSNotification *)notification {    UIViewAnimationCurve animationCurve = [[[notification userInfo] valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    NSTimeInterval animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:@"showKeyboardAnimation" context: nil];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
   self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 170, self.view.frame.size.width, self.view.frame.size.height);
   bPopupKeyboard = TRUE;
    [UIView commitAnimations];
}

- (void)keyboardWillHide: (NSNotification *)notification {
    UIViewAnimationCurve animationCurve = [[[notification userInfo] valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    NSTimeInterval animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:@"hideKeyboardAnimation" context: nil];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 170, self.view.frame.size.width, self.view.frame.size.height );
    bPopupKeyboard = FALSE;
    [UIView commitAnimations];
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

@end
