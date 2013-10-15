//
//  CounterBankViewController.h
//  googuu
//
//  Created by Xcode on 13-10-14.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CounterBankViewController : UIViewController<UITextFieldDelegate>{
    NSInteger selectedTextFieldTag;
    NSInteger selectedBtTag;
    CGPoint standard;
}

@property FinancalToolsType toolType;

@property (nonatomic,retain) NSDictionary *params;
@property (nonatomic,retain) NSArray *floatParams;

@end
