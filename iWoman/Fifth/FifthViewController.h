//
//  FifthViewController.h
//  iWoman
//
//  Created by Yulian Simeonov on 5/7/12.
//  Copyright (c) 2012 __YulianMobile__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ChatRoomViewController.h"

#define kLabelTag 4096
#define kLabelFieldTag 4097

@interface FifthViewController : UIViewController {
    
    IBOutlet UITableView *mTableViewContacts;
    NSArray *mContentArray;
    NSArray *mSectionArray;
    NSArray *mFieldLabels;
    ChatRoomViewController *mChatRoomViewController;
}
@property (nonatomic, retain) IBOutlet UITableView *mTableViewContacts;
@property (retain, nonatomic) NSArray *mContentArray;
@property (retain, nonatomic) NSArray *mSectionArray;
@property (retain, nonatomic) NSArray *mFieldLabels;
@property (nonatomic, retain) ChatRoomViewController *mChatRoomViewController;

@end
