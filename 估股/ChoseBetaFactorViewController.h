//
//  ChoseBetaFactorViewController.h
//  googuu
//
//  Created by Xcode on 13-10-10.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChoseBetaVCDelegate <NSObject>
@optional
-(void)choseBetaVCDismiss:(NSString *)betaFactor;
@end

@class BetaFactorCountViewController;

@interface ChoseBetaFactorViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,retain) id benchMark;
@property (nonatomic,retain) NSArray *index;
@property (nonatomic,retain) NSArray *floatSource;
@property (nonatomic,retain) NSArray *returnFloat;
@property (nonatomic,retain) NSArray *component2Source;
@property (nonatomic,retain) NSNumberFormatter *numberFormatter;

@property (nonatomic,retain) id<ChoseBetaVCDelegate> delegate;

@property (nonatomic,retain) IBOutlet UIPickerView *betaPicker;
@property (nonatomic,retain) IBOutlet UIButton *sureBt;
@property (nonatomic,retain) IBOutlet UIButton *cancelBt;

@end
