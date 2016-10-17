//
//  MTPopupWindow.h
//  PopupWindowProject
//
//  Created by Marin Todorov on 7/1/11.
//  Copyright 2011 Marin Todorov. MIT license
//  http://www.opensource.org/licenses/mit-license.php
//  

#import <Foundation/Foundation.h>

@protocol MTPopupWindowDelegate;

@interface MTPopupWindow : NSObject
{
    UIView* bgView;
    UIView* bigPanelView;
    id <MTPopupWindowDelegate> delegate;
}

@property (retain, nonatomic) id<MTPopupWindowDelegate> delegate;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *which;

+(void)showWindowWithHTMLFile:(NSString*)fileName insideView:(UIView*)view delegate:(id<MTPopupWindowDelegate>)delegate which:(NSString*)which;
-(void)closePopupWindow;

@end

@protocol MTPopupWindowDelegate

- (void) photoSelectorDidFinish:(MTPopupWindow *)controller;
- (void) photoSizeSelectorDidFinish:(MTPopupWindow *)controller;

@end