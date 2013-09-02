//
//  GooGuuArticleViewController.m
//  UIDemo
//
//  Created by Xcode on 13-7-10.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "GooGuuArticleViewController.h"
#import "MHTabBarController.h"
#import "MBProgressHUD.h"
#import "MHTabBarController.h"


@interface GooGuuArticleViewController ()

@end

@implementation GooGuuArticleViewController

@synthesize articleTitle;
@synthesize articleId;
@synthesize articleWeb;

- (void)dealloc
{
    SAFE_RELEASE(articleTitle);
    [articleWeb release];
    [articleId release];
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

    CATransition *transition=[CATransition animation];
    transition.duration=0.4f;
    transition.fillMode=kCAFillModeRemoved;
    transition.type=kCATruncationMiddle;
    transition.subtype=kCATransitionFromRight;
    [self.parentViewController.navigationController.navigationBar.layer addAnimation:transition forKey:@"animation"];
    self.parentViewController.navigationItem.rightBarButtonItem=nil;
    //[[(UITabBarController *)(self.parentViewController.parentViewController.parentViewController) tabBar] setHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.parentViewController.title=@"公司简报";
    
    MBProgressHUD *hud=[[MBProgressHUD alloc] initWithView:self.view];
    [Utiles showHUD:@"Loading..." andView:self.view andHUD:hud];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,40)];
    [titleLabel setBackgroundColor:[Utiles colorWithHexString:@"#FDFBE4"]];
    [titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:16.0]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:articleTitle];
    [self.view addSubview:titleLabel];
    SAFE_RELEASE(titleLabel);
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:articleId,@"articleid", nil];
    [Utiles getNetInfoWithPath:@"ArticleURL" andParams:params besidesBlock:^(id article){

        articleWeb=[[UIWebView alloc] initWithFrame:CGRectMake(0,40,self.view.bounds.size.width, self.view.bounds.size.height-35)];
        articleWeb.delegate=self;
        [articleWeb loadHTMLString:[article objectForKey:@"content"] baseURL:nil];
        //articleWeb.scalesPageToFit=YES;
        [hud hide:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        [self.view addSubview:articleWeb];
        [articleWeb release];
        
    }];
  
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.view addGestureRecognizer:pan];
    [pan release];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{

    //文章文字大小
    NSString *botySise=[[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.fontSize='%dpx'",12];
    NSString *imgSize=[[NSString alloc] initWithFormat:@"var temp = document.getElementsByTagName(\"img\");\
                       for (var i = 0; i < temp.length; i ++) {\
                           temp[i].style.width = '300px';\
                           temp[i].style.height = '200px';\
                       }"];
    [articleWeb stringByEvaluatingJavaScriptFromString:botySise];
    [articleWeb stringByEvaluatingJavaScriptFromString:imgSize];
    SAFE_RELEASE(botySise);
    SAFE_RELEASE(imgSize);
}

-(void)panView:(UIPanGestureRecognizer *)tap{
    CGPoint change=[tap translationInView:self.view];
    
    if(change.x<-FINGERCHANGEDISTANCE){
        [(MHTabBarController *)self.parentViewController setSelectedIndex:1 animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations{

    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotate{
    return NO;
}




















@end
