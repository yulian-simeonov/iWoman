//
//  MTPopupWindow.m
//  PopupWindowProject
//
//  Created by Marin Todorov on 7/1/11.
//  Copyright 2011 Marin Todorov. MIT license
//  http://www.opensource.org/licenses/mit-license.php
//

#import "MTPopupWindow.h"

#define kShadeViewTag 1000

@interface MTPopupWindow(Private)
- (id)initWithSuperview:(UIView*)sview andFile:(NSString*)fName;
@end

@implementation MTPopupWindow

@synthesize delegate;
@synthesize color = _color;
@synthesize size = _size;
@synthesize which = _which;

/**
 * This is the only public method, it opens a popup window and loads the given content
 * @param NSString* fileName provide a file name to load a file from the app resources, or a URL to load a web page
 * @param UIView* view provide a UIViewController's view here (or other view)
 */
+(void)showWindowWithHTMLFile:(NSString*)fileName insideView:(UIView*)view delegate:(id<MTPopupWindowDelegate>)delegate which:(NSString*)which
{
    MTPopupWindow * view1 = [[MTPopupWindow alloc] initWithSuperview:view andFile:fileName];
    view1.delegate = delegate;
    view1.which = which;
    
}

/**
 * Initializes the class instance, gets a view where the window will pop up in
 * and a file name/ URL
 */
- (id)initWithSuperview:(UIView*)sview andFile:(NSString*)fName
{
    self = [super init];
    if (self) {
        // Initialization code here.
        bgView = [[[UIView alloc] initWithFrame: sview.bounds] autorelease];
        [sview addSubview: bgView];
        
        // proceed with animation after the bgView was added
        [self performSelector:@selector(doTransitionWithContentFile:) withObject:fName afterDelay:0.1];
    }
    
    return self;
}

/**
 * Afrer the window background is added to the UI the window can animate in
 * and load the UIWebView
 */
-(void)doTransitionWithContentFile:(NSString*)fName
{
    //faux view
    UIView* fauxView = [[[UIView alloc] initWithFrame: CGRectMake(10, 10, 200, 200)] autorelease];
    [bgView addSubview: fauxView];

    //the new panel
    bigPanelView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height)] autorelease];
    bigPanelView.center = CGPointMake( bgView.frame.size.width/2, bgView.frame.size.height/2);
    
    //add the window background
    UIImageView* background = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popupWindowBack.png"]] autorelease];
    background.center = CGPointMake(bigPanelView.frame.size.width/2, bigPanelView.frame.size.height/2);
    [bigPanelView addSubview: background];
    
    //add the close button
    int closeBtnOffset = 10;
    UIImage* closeBtnImg = [UIImage imageNamed:@"popupCloseBtn.png"];
    UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:closeBtnImg forState:UIControlStateNormal];
    [closeBtn setFrame:CGRectMake( background.frame.origin.x + background.frame.size.width - closeBtnImg.size.width - closeBtnOffset, 
                                   background.frame.origin.y ,
                                   closeBtnImg.size.width + closeBtnOffset, 
                                   closeBtnImg.size.height + closeBtnOffset)];
    [closeBtn addTarget:self action:@selector(closeWindow) forControlEvents:UIControlEventTouchUpInside];
    [bigPanelView addSubview: closeBtn];
    
    if ([self.which isEqualToString:@"color"]) {
    //add the red color button
    UIImage* redColorBtnImg = [UIImage imageNamed:@"color_button.png"];
    
    UIButton* redColorBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [redColorBtn1 setImage:redColorBtnImg forState:UIControlStateNormal];
    [redColorBtn1 setFrame:CGRectMake(45, 
                                  background.frame.origin.y+33 ,
                                  redColorBtnImg.size.width, 
                                  redColorBtnImg.size.height)];
    [redColorBtn1 addTarget:self action:@selector(onClickColorButton1) forControlEvents:UIControlEventTouchUpInside];
    [redColorBtn1 setTitle:@"Red" forState:UIControlStateNormal];
    [bigPanelView addSubview: redColorBtn1];
    
    UIButton* redColorBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [redColorBtn2 setImage:redColorBtnImg forState:UIControlStateNormal];
    [redColorBtn2 setFrame:CGRectMake(45, 
                                     background.frame.origin.y+70 ,
                                     redColorBtnImg.size.width, 
                                     redColorBtnImg.size.height)];
    [redColorBtn2 addTarget:self action:@selector(onClickColorButton2) forControlEvents:UIControlEventTouchUpInside];
    [redColorBtn2 setTitle:@"Green" forState:UIControlStateNormal];
    [bigPanelView addSubview: redColorBtn2];
    
    UIButton* redColorBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [redColorBtn3 setImage:redColorBtnImg forState:UIControlStateNormal];
    [redColorBtn3 setFrame:CGRectMake(45, 
                                     background.frame.origin.y+110 ,
                                     redColorBtnImg.size.width, 
                                     redColorBtnImg.size.height)];
    [redColorBtn3 addTarget:self action:@selector(onClickColorButton3) forControlEvents:UIControlEventTouchUpInside];
    [redColorBtn3 setTitle:@"Blue" forState:UIControlStateNormal];
    [bigPanelView addSubview: redColorBtn3];
        
    } else {
    
        UIImage* redColorBtnImg = [UIImage imageNamed:@"color_button.png"];
        
        UIButton* redColorBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [redColorBtn1 setImage:redColorBtnImg forState:UIControlStateNormal];
        [redColorBtn1 setFrame:CGRectMake(45, 
                                          background.frame.origin.y+33 ,
                                          redColorBtnImg.size.width, 
                                          redColorBtnImg.size.height)];
        [redColorBtn1 addTarget:self action:@selector(onClickSizeButton1) forControlEvents:UIControlEventTouchUpInside];
        [redColorBtn1 setTitle:@"Red" forState:UIControlStateNormal];
        [bigPanelView addSubview: redColorBtn1];
        
        UIButton* redColorBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [redColorBtn2 setImage:redColorBtnImg forState:UIControlStateNormal];
        [redColorBtn2 setFrame:CGRectMake(45, 
                                          background.frame.origin.y+70 ,
                                          redColorBtnImg.size.width, 
                                          redColorBtnImg.size.height)];
        [redColorBtn2 addTarget:self action:@selector(onClickSizeButton2) forControlEvents:UIControlEventTouchUpInside];
        [redColorBtn2 setTitle:@"Green" forState:UIControlStateNormal];
        [bigPanelView addSubview: redColorBtn2];
        
        UIButton* redColorBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [redColorBtn3 setImage:redColorBtnImg forState:UIControlStateNormal];
        [redColorBtn3 setFrame:CGRectMake(45, 
                                          background.frame.origin.y+110 ,
                                          redColorBtnImg.size.width, 
                                          redColorBtnImg.size.height)];
        [redColorBtn3 addTarget:self action:@selector(onClickSizeButton3) forControlEvents:UIControlEventTouchUpInside];
        [redColorBtn3 setTitle:@"Blue" forState:UIControlStateNormal];
        [bigPanelView addSubview: redColorBtn3];

    }
    //animation options
    UIViewAnimationOptions options = UIViewAnimationOptionTransitionFlipFromRight |
                                        UIViewAnimationOptionAllowUserInteraction    |
                                        UIViewAnimationOptionBeginFromCurrentState;
    
    //run the animation
    [UIView transitionFromView:fauxView toView:bigPanelView duration:0.5 options:options completion: ^(BOOL finished) {
        
        //dim the contents behind the popup window
        UIView* shadeView = [[[UIView alloc] initWithFrame:bigPanelView.frame] autorelease];
        shadeView.backgroundColor = [UIColor blackColor];
        shadeView.alpha = 0.3;
        shadeView.tag = kShadeViewTag;
        [bigPanelView addSubview: shadeView];
        [bigPanelView sendSubviewToBack: shadeView];
    }];
}

/**
 * Removes the window background and calls the animation of the window
 */
-(void)closeWindow
{
    
    [self closePopupWindow];
    //remove the shade
//    [[bigPanelView viewWithTag: kShadeViewTag] removeFromSuperview];    
//    [self performSelector:@selector(closePopupWindowAnimate) withObject:nil afterDelay:0.1];
    
}

-(void) onClickColorButton1
{
    self.color = @"Red";    
    if (delegate)
        [delegate photoSelectorDidFinish:self];
    //remove the shade
    //    [[bigPanelView viewWithTag: kShadeViewTag] removeFromSuperview];    
    //    [self performSelector:@selector(closePopupWindowAnimate) withObject:nil afterDelay:0.1];
    
}

-(void) onClickColorButton2
{
    self.color = @"Green";    
    if (delegate)
        [delegate photoSelectorDidFinish:self];
    //remove the shade
    //    [[bigPanelView viewWithTag: kShadeViewTag] removeFromSuperview];    
    //    [self performSelector:@selector(closePopupWindowAnimate) withObject:nil afterDelay:0.1];
    
}

-(void) onClickColorButton3
{
    self.color = @"Blue";
    if (delegate)
        [delegate photoSelectorDidFinish:self];
    //remove the shade
    //    [[bigPanelView viewWithTag: kShadeViewTag] removeFromSuperview];    
    //    [self performSelector:@selector(closePopupWindowAnimate) withObject:nil afterDelay:0.1];
    
}

-(void) onClickSizeButton1
{
    self.size = @"Size1";    
    if (delegate)
        [delegate photoSizeSelectorDidFinish:self];
    //remove the shade
    //    [[bigPanelView viewWithTag: kShadeViewTag] removeFromSuperview];    
    //    [self performSelector:@selector(closePopupWindowAnimate) withObject:nil afterDelay:0.1];
    
}

-(void) onClickSizeButton2
{
    self.size = @"Size2";    
    if (delegate)
        [delegate photoSizeSelectorDidFinish:self];
    //remove the shade
    //    [[bigPanelView viewWithTag: kShadeViewTag] removeFromSuperview];    
    //    [self performSelector:@selector(closePopupWindowAnimate) withObject:nil afterDelay:0.1];
    
}

-(void) onClickSizeButton3
{
    self.size = @"Size3";
    if (delegate)
        [delegate photoSizeSelectorDidFinish:self];
    //remove the shade
    //    [[bigPanelView viewWithTag: kShadeViewTag] removeFromSuperview];    
    //    [self performSelector:@selector(closePopupWindowAnimate) withObject:nil afterDelay:0.1];
    
}

-(void)closePopupWindow
{
    
    //remove the shade
        [[bigPanelView viewWithTag: kShadeViewTag] removeFromSuperview];    
        [self performSelector:@selector(closePopupWindowAnimate) withObject:nil afterDelay:0.1];
//    [delegate release];
    [_size release];
    [_color release];
    [_which release];
    
}

/**
 * Animates the window and when done removes all views from the view hierarchy
 * since they are all only retained by their superview this also deallocates them
 * finally deallocate the class instance
 */
-(void)closePopupWindowAnimate
{
    
    //faux view
    __block UIView* fauxView = [[UIView alloc] initWithFrame: CGRectMake(10, 10, 200, 200)];
    [bgView addSubview: fauxView];

    //run the animation
    UIViewAnimationOptions options = UIViewAnimationOptionTransitionFlipFromLeft |
    UIViewAnimationOptionAllowUserInteraction    |
    UIViewAnimationOptionBeginFromCurrentState;
    
    //hold to the bigPanelView, because it'll be removed during the animation
    [bigPanelView retain];
    
    [UIView transitionFromView:bigPanelView toView:fauxView duration:0.5 options:options completion:^(BOOL finished) {

        //when popup is closed, remove all the views
        for (UIView* child in bigPanelView.subviews) {
            [child removeFromSuperview];
        }
        for (UIView* child in bgView.subviews) {
            [child removeFromSuperview];
        }
        [bigPanelView release];
        [bgView removeFromSuperview];
        
        [self release];
    }];
}

@end