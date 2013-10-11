//
//  FinanceToolsGrade2ViewController.h
//  googuu
//
//  Created by Xcode on 13-10-11.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinanceToolsGrade2ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) NSArray *typeNames;
@property (nonatomic,retain) NSArray *types;
@property (nonatomic,retain) NSArray *paramArr;

@property (nonatomic,retain) UITableView *customTabel;

@end
