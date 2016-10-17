//
//  ForthViewController.h
//  iWoman
//
//  Created by Yulian Simeonov on 5/7/12.
//  Copyright (c) 2012 __YulianMobile__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLabelTag 4096
#define kLabelFieldTag 4097

@interface ForthViewController : UIViewController {

    IBOutlet UITableView *mTableViewContacts;
    NSArray *mContentArray;
    NSArray *mSectionArray;
    NSArray *mFieldLabels;
}

@property (retain, nonatomic) IBOutlet UITableView *mTableViewContacts;
@property (retain, nonatomic) NSArray *mContentArray;
@property (retain, nonatomic) NSArray *mSectionArray;
@property (retain, nonatomic) NSArray *mFieldLabels;

@end
