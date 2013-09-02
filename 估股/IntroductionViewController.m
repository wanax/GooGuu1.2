//
//  IntroductionViewController.m
//  UIDemo
//
//  Created by Xcode on 13-5-8.
//  Copyright (c) 2013年 Pony Finance. All rights reserved.
//
//  Vision History
//  2013-05-08 | Wanax | 股票详细页-股票介绍

#import "IntroductionViewController.h"
#import "UIImageView+AFNetworking.h"
#import "XYZAppDelegate.h"
#import "MHTabBarController.h"
#import "UIImageView+Addition.h"

@interface IntroductionViewController ()

@end

@implementation IntroductionViewController

@synthesize photos;
@synthesize imageView;

- (void)dealloc
{
    SAFE_RELEASE(photos);
    SAFE_RELEASE(imageView);
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    

    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    imageView.frame=CGRectMake(0,0,SCREEN_WIDTH,2400);
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    XYZAppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    id comInfo=delegate.comInfo;
    NSString *url=[NSString stringWithFormat:@"%@",[comInfo objectForKey:@"companypicurl"]];
    
    [self.view setBackgroundColor:[Utiles colorWithHexString:@"#E2DCC7"]];
   
    MWPhoto *photo;
    photo = [MWPhoto photoWithURL:[NSURL URLWithString:url]];

    NSMutableArray *tempPhotos = [[NSMutableArray alloc] init];
    [tempPhotos addObject:photo];
    self.photos=tempPhotos;
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.view.frame=CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    browser.displayActionButton = YES;
    
    [self.view insertSubview:browser.view atIndex:1];
    
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.view addGestureRecognizer:pan];
    [pan release];
    SAFE_RELEASE(tempPhotos);
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}

-(void)panView:(UIPanGestureRecognizer *)tap{
    CGPoint change=[tap translationInView:self.view];
    if(change.x<-100){
        [(MHTabBarController *)self.parentViewController setSelectedIndex:2 animated:YES];
    }else if(change.x>100){
        [(MHTabBarController *)self.parentViewController setSelectedIndex:0 animated:YES];
    }
}

-(void)move:(UIPanGestureRecognizer *)tapGr{
    
    CGPoint change=[tapGr translationInView:self.view];

    if(tapGr.state==UIGestureRecognizerStateChanged){
        
        imageView.frame=CGRectMake(0,MAX(MIN(standard.y+change.y,0),-2300),SCREEN_WIDTH,2600);

    }else if(tapGr.state==UIGestureRecognizerStateEnded){
        standard=imageView.frame.origin;
    }
    
    //手指向左滑动，向右切换scrollView视图
    if(change.x<-FINGERCHANGEDISTANCE&&change.y<5){

        [(MHTabBarController *)self.parentViewController setSelectedIndex:1 animated:YES];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer

{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate{
    return NO;
}


















@end
