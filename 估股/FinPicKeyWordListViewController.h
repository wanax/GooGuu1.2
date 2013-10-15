//
//  FinPicKeyWordListViewController.h
//  googuu
//
//  Created by Xcode on 13-10-14.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinPicKeyWordListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) UITableView *cusTabView;

@property (nonatomic,retain) id keyWordData;
@property (nonatomic,retain) NSArray *keyWordList;

@end
