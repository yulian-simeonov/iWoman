//
//  ShopDetailsViewController.h
//  iWoman
//
//  Created by Yulian Simeonov on 5/15/12.
//  Copyright (c) 2012 __YulianMobile__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTPopupWindow.h"
#import "CheckoutViewController.h"
#import "AppDelegate.h"

@interface ShopDetailsViewController : UIViewController <MTPopupWindowDelegate> {
    
    IBOutlet UIImageView *mUIImageViewItem;
    IBOutlet UIButton *mButtonColor;
    IBOutlet UIButton *mButtonSize;
    IBOutlet UIButton *mButtonSelect;
    IBOutlet UIButton *mButtonBack;
    NSString *mImgUrl;
    NSString *mColor;
    NSString *mSize;
    NSString *mProdName;
    IBOutlet UIActivityIndicatorView *mActiveIndicator;
}

@property (nonatomic, retain) IBOutlet UIImageView *mUIImageViewItem;
@property (nonatomic, retain) IBOutlet UIButton *mButtonColor;
@property (nonatomic, retain) IBOutlet UIButton *mButtonSize;
@property (nonatomic, retain) IBOutlet UIButton *mButtonBack;
@property (nonatomic, retain) IBOutlet UIButton *mButtonSelect;

@property (nonatomic, retain) NSString *mColor;
@property (nonatomic, retain) NSString *mSize;
@property (nonatomic, retain) NSString *mImgUrl;
@property (nonatomic, retain) NSString *mProdName;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *mActiveIndicator;

-(IBAction)openColorPopup:(id)sender;
-(IBAction)openSizePopup:(id)sender;
-(IBAction)onClickSelect:(id)sender;
-(IBAction)onClickBack:(id)sender;

@end
