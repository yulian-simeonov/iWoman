//
//  FirstViewController.h
//  iWoman
//
//  Created by Yulian Simeonov on 5/6/12.
//  Copyright (c) 2012 __YulianMobile__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TSearchInfo.h"
#import "TWebApi.h"
#import "JSON.h"
#import "ShopDetailsViewController.h"
#import "AppDelegate.h"

#define kLabelTag 4096
#define kLabelAlertTag 4098
#define kLabelFieldTag 4097
#define TOTAL @"total"
#define GROUPS @"groups"
#define FAMILIES @"families"

@interface FirstViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *mTableViewShop;
    NSMutableArray *mContentArray;
    NSMutableArray *mSectionArray;
    NSMutableArray *mFieldLabels;
    NSMutableDictionary *JSONResult;
    IBOutlet UIActivityIndicatorView *mActivityIndicator;
}

@property (retain, nonatomic) IBOutlet UITableView *mTableViewShop;
@property (retain, nonatomic) NSMutableArray *mFieldLabels;
@property (retain, nonatomic) NSMutableDictionary *JSONResult;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *mActivityIndicator;
@property (nonatomic, strong) AppDelegate* appDelegate;

- (IBAction) goHome:(id)sender;
- (void) doLoading;
@end
