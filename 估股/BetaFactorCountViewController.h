//
//  BetaFactorCountViewController.h
//  googuu
//
//  Created by Xcode on 13-10-10.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoseBetaFactorViewController.h"

@class CounterViewController;

@protocol BetaFactorVCDelegate <NSObject>
@optional
-(void)gotBeta:(NSString *)betaFactor;
@end

@interface BetaFactorCountViewController : UIViewController<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,ChoseBetaVCDelegate>

@property (nonatomic,retain) NSArray *typeArr;

@property (nonatomic,retain) id<BetaFactorVCDelegate> delegate;

@property (nonatomic,retain) IBOutlet UITextField *stockCodeInput;
@property (nonatomic,retain) IBOutlet UIPickerView *expPicker;
@property (nonatomic,retain) IBOutlet UIButton *getBetaFactorBt;

@end
