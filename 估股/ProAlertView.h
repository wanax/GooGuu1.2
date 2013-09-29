//
//  ProAlertView.h
//  googuu
//
//  Created by Xcode on 13-9-10.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProAlertView : UIAlertView
{
    
	int canIndex;
	BOOL disableDismiss;
    BOOL canVirate;
}

-(void) setBackgroundColor:(UIColor *) background
           withStrokeColor:(UIColor *) stroke;

- (void)disableDismissForIndex:(int)index_;
- (void)dismissAlert;
- (void)vibrateAlert:(float)seconds;

- (void)moveRight;
- (void)moveLeft;

- (void)hideAfter:(float)seconds;

- (void)stopVibration;


@end