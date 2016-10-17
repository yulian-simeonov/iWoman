//
//  CheckoutViewController.h
//  iWoman
//
//  Created by Yulian Simeonov on 5/16/12.
//  Copyright (c) 2012 __YulianMobile__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShopDetailsViewController.h"

@interface CheckoutViewController : UIViewController {

    IBOutlet UIButton *mUIButtonCheckout;
    IBOutlet UILabel *mUILabelColor;
    IBOutlet UILabel *mUILabelSize;
}
@property (nonatomic, retain) IBOutlet UIButton *mUIButtonCheckout;
@property (nonatomic, retain) IBOutlet UILabel *mUILabelColor;
@property (nonatomic, retain) IBOutlet UILabel *mUILabelSize;
@property (nonatomic, strong) NSString* prodNameColor;
@property (nonatomic, strong) NSString* prodSize;

- (IBAction) onClickCheckout:(id)sender;

@end
