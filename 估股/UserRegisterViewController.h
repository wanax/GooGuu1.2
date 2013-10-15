//
//  UserRegisterViewController.h
//  googuu
//
//  Created by Xcode on 13-10-15.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UserRegisterViewController :UIViewController<UITextFieldDelegate>{
    NSInteger selectedTextFieldTag;
}

@property UserActionType actionType;

@end
