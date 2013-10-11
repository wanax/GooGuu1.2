//
//  CounterViewController.h
//  googuu
//
//  Created by Xcode on 13-10-9.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BetaFactorCountViewController.h"

@interface CounterViewController : UIViewController<UITextFieldDelegate,BetaFactorVCDelegate>{
    NSInteger selectedTextFieldTag;
}

@property (nonatomic,retain) NSDictionary *params;

@end
