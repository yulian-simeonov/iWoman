//
//  SecondViewController.h
//  iWoman
//
//  Created by Yulian Simeonov on 5/6/12.
//  Copyright (c) 2012 __YulianMobile__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLabelTag 4096
#define kLabelFieldTag 4097

@interface SecondViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    IBOutlet UITableView *mTableViewHighlights;
    NSArray *mContentArray;
    NSArray *mSectionArray;
    NSArray *mFieldLabels;
}

- (IBAction) goHome:(id)sender;
@property (retain, nonatomic) IBOutlet UITableView *mTableViewHighlights;
@property (retain, nonatomic) NSArray *mFieldLabels;

@end
