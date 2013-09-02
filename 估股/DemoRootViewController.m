//
//  DemoRootViewController.m
//  CXPhotoBrowserDemo
//
//  Created by ChrisXu on 13/4/23.
//  Copyright (c) 2013年 ChrisXu. All rights reserved.
//

#import "DemoRootViewController.h"
#import "CXPhotoBrowser.h"
#import "DemoPhoto.h"
#import "SDImageCache.h"
#import <QuartzCore/QuartzCore.h>
@interface DemoRootViewController ()
<CXPhotoBrowserDataSource, CXPhotoBrowserDelegate>

#define BROWSER_TITLE_LBL_TAG 12731
#define BROWSER_DESCRIP_LBL_TAG 178273
#define BROWSER_LIKE_BTN_TAG 12821

@property (nonatomic, strong) CXPhotoBrowser *browser;
@property (nonatomic, strong) NSMutableArray *photoDataSource;
- (IBAction)showBrowserWithPresent:(id)sender;
- (IBAction)showBrowserWithPush:(id)sender;

@end

@implementation DemoRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.photoDataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    self.browser = [[CXPhotoBrowser alloc] initWithDataSource:self delegate:self];
    self.browser.wantsFullScreenLayout = NO;

    DemoPhoto *photo = [[DemoPhoto alloc] initWithURL:[NSURL URLWithString:@"http://ui4app.qiniudn.com/photo/app/52049e2b6803fa303b000001.jpg"]];
    
    [self.photoDataSource addObject:photo];
    [self.navigationController pushViewController:self.browser animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions
- (IBAction)showBrowserWithPresent:(id)sender
{
    [self presentViewController:self.browser animated:YES completion:^{
        
    }];
}

- (IBAction)showBrowserWithPush:(id)sender
{
    
}

#pragma mark - CXPhotoBrowserDataSource
- (NSUInteger)numberOfPhotosInPhotoBrowser:(CXPhotoBrowser *)photoBrowser
{
    return [self.photoDataSource count];
}
- (id <CXPhotoProtocol>)photoBrowser:(CXPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.photoDataSource.count)
        return [self.photoDataSource objectAtIndex:index];
    return nil;
}





- (BOOL)supportReload
{
    return YES;
}


@end
