//
//  GooGuuArticleViewController.m
//  UIDemo
//
//  Created by Xcode on 13-7-10.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "GooGuuArticleViewController.h"
#import "MHTabBarController.h"
#import "MHTabBarController.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+Addition.h"
#import "GGFullscreenImageViewController.h"
#import "CXPhotoBrowser.h"
#import "DemoPhoto.h"
#import "UIButton+BGColor.h"
#import "AddCommentViewController.h"
#import "XYZAppDelegate.h"
#import "ComFieldViewController.h"


@interface GooGuuArticleViewController ()

#define BROWSER_TITLE_LBL_TAG 12731
#define BROWSER_DESCRIP_LBL_TAG 178273
#define BROWSER_LIKE_BTN_TAG 12821

@end

@implementation GooGuuArticleViewController

@synthesize articleTitle;
@synthesize articleId;
@synthesize articleWeb;
@synthesize imageUrlList;
@synthesize imageTitleLabel;
@synthesize browser;
@synthesize photoDataSource;
@synthesize comInfo;

- (void)dealloc
{
    SAFE_RELEASE(comInfo);
    SAFE_RELEASE(imageTitleLabel);
    SAFE_RELEASE(imageUrlList);
    SAFE_RELEASE(browser);
    SAFE_RELEASE(photoDataSource);
    SAFE_RELEASE(articleTitle);
    [articleWeb release];
    [articleId release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.photoDataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
}

-(void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
    CATransition *transition=[CATransition animation];
    transition.duration=0.4f;
    transition.fillMode=kCAFillModeRemoved;
    transition.type=kCATruncationMiddle;
    transition.subtype=kCATransitionFromRight;
    [self.parentViewController.navigationController.navigationBar.layer addAnimation:transition forKey:@"animation"];
    self.parentViewController.navigationItem.rightBarButtonItem=nil;
}
-(void)addComponents{
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,40)];
    [titleLabel setBackgroundColor:[Utiles colorWithHexString:@"#FDFBE4"]];
    [titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:16.0]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:articleTitle];
    [self.view addSubview:titleLabel];
    SAFE_RELEASE(titleLabel);
    
    UIButton *comeIntoComBt=[UIButton buttonWithType:UIButtonTypeCustom];
    [comeIntoComBt setFrame:CGRectMake(0,350, 160, 35)];
    [comeIntoComBt.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:15.0]];
    [comeIntoComBt setBackgroundColorString:@"#9C6C1E" forState:UIControlStateNormal];
    [comeIntoComBt setTitle:@"进入公司" forState:UIControlStateNormal];
    [comeIntoComBt addTarget:self action:@selector(comeIntoComBtClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:comeIntoComBt];
    
    UIButton *addCommentBt=[UIButton buttonWithType:UIButtonTypeCustom];
    [addCommentBt setFrame:CGRectMake(160,350, 160, 35)];
    [addCommentBt.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:15.0]];
    [addCommentBt setBackgroundColorString:@"#9C6C1E" forState:UIControlStateNormal];
    [addCommentBt setTitle:@"添加评论" forState:UIControlStateNormal];
    [addCommentBt addTarget:self action:@selector(addCommentBtClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addCommentBt];
    
}
#pragma mark -
#pragma mark Buttons Clicks
-(void)addCommentBtClicked{
    if ([Utiles isLogin]) {
        AddCommentViewController *addCommentViewController=[[AddCommentViewController alloc] init];
        addCommentViewController.type=ArticleType;
        addCommentViewController.articleId=articleId;
        [self presentViewController:addCommentViewController animated:YES completion:nil];
    } else {
        [Utiles showToastView:self.view withTitle:nil andContent:@"请先登录" duration:1.5];
    }
}
-(void)comeIntoComBtClicked{
    ComFieldViewController *com=[[ComFieldViewController alloc] init];
    com.browseType=SearchStockList;
    com.view.frame=CGRectMake(0,20,SCREEN_WIDTH,SCREEN_HEIGHT);
    [self presentViewController:com animated:YES completion:nil];
}


-(void)initWebView{
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:articleId,@"articleid", nil];
    [Utiles getNetInfoWithPath:@"ArticleURL" andParams:params besidesBlock:^(id article){
        
        articleWeb=[[UIWebView alloc] initWithFrame:CGRectMake(0,40,self.view.bounds.size.width, self.view.bounds.size.height-75)];
        articleWeb.delegate=self;
        [articleWeb loadHTMLString:[article objectForKey:@"content"] baseURL:nil];
        
        [self addTapOnWebView];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view addSubview:articleWeb];
        [articleWeb release];
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[Utiles colorWithHexString:@"#9C6C1E"];
    self.parentViewController.title=@"公司简报";
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    self.browser = [[CXPhotoBrowser alloc] initWithDataSource:self delegate:self];
    self.browser.wantsFullScreenLayout = NO;
    XYZAppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    self.comInfo=delegate.comInfo;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self initWebView];
    
    [self addComponents];

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
    NSString *urlStr=[articleWeb stringByEvaluatingJavaScriptFromString:@"var str=\"\";\
                   function imgUrl(){\
                   var temp = document.getElementsByTagName(\"img\");\
                   for (var i = 0; i < temp.length; i ++) {\
                       str+=temp[i].src+\"|\";\
                   }\
                   return str;\
                   }\
                   imgUrl();"];
    NSMutableArray *tempArr=[[NSMutableArray alloc] initWithArray:[urlStr componentsSeparatedByString:@"|"]];
    [tempArr removeLastObject];
    self.imageUrlList=tempArr;
    for (id obj in self.imageUrlList) {
        DemoPhoto *photo = nil;        
        photo = [[DemoPhoto alloc] initWithURL:[NSURL URLWithString:obj]];
        [self.photoDataSource addObject:photo];
    }
    [articleWeb stringByEvaluatingJavaScriptFromString:botySise];
    [articleWeb stringByEvaluatingJavaScriptFromString:imgSize];
    SAFE_RELEASE(botySise);
    SAFE_RELEASE(imgSize);
    SAFE_RELEASE(tempArr);
}



-(void)addTapOnWebView
{
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.articleWeb addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
}

#pragma mark- TapGestureRecognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    CGPoint pt = [sender locationInView:self.articleWeb];
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
    NSString *urlToSave = [self.articleWeb stringByEvaluatingJavaScriptFromString:imgURL];

    if (urlToSave.length > 0) {   
        [self presentViewController:self.browser animated:YES completion:^{
            
        }];
    }
}
#pragma mark -
#pragma mark CXPhotoBrowserDelegate

- (void)photoBrowser:(CXPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index{
    [imageTitleLabel setText:[NSString stringWithFormat:@"%d/%d",(index+1),[self.imageUrlList count]]];
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

- (CXBrowserNavBarView *)browserNavigationBarViewOfOfPhotoBrowser:(CXPhotoBrowser *)photoBrowser withSize:(CGSize)size
{
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = size;
    if (!navBarView)
    {
        navBarView = [[CXBrowserNavBarView alloc] initWithFrame:frame];
        
        [navBarView setBackgroundColor:[UIColor clearColor]];
        
        UIView *bkgView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, size.width, size.height)];
        [bkgView setBackgroundColor:[UIColor blackColor]];
        bkgView.alpha = 0.2;
        bkgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [navBarView addSubview:bkgView];
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.]];
        [doneButton setTitle:NSLocalizedString(@"返回",@"Dismiss button title") forState:UIControlStateNormal];
        [doneButton setFrame:CGRectMake(size.width - 60, 10, 50, 30)];
        [doneButton addTarget:self action:@selector(photoBrowserDidTapDoneButton:) forControlEvents:UIControlEventTouchUpInside];
        [doneButton.layer setMasksToBounds:YES];
        [doneButton.layer setCornerRadius:4.0];
        [doneButton.layer setBorderWidth:1.0];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1, 1, 1 });
        [doneButton.layer setBorderColor:colorref];
        doneButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [navBarView addSubview:doneButton];
        
        imageTitleLabel = [[UILabel alloc] init];
        [imageTitleLabel setFrame:CGRectMake((size.width - 60)/2, 10, 60, 40)];
        [imageTitleLabel setCenter:navBarView.center];
        [imageTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [imageTitleLabel setFont:[UIFont boldSystemFontOfSize:20.]];
        [imageTitleLabel setTextColor:[UIColor whiteColor]];
        [imageTitleLabel setBackgroundColor:[UIColor clearColor]];
        [imageTitleLabel setText:@""];
        imageTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [imageTitleLabel setTag:BROWSER_TITLE_LBL_TAG];
        [navBarView addSubview:imageTitleLabel];
    }
    
    return navBarView;
}

#pragma mark - PhotBrower Actions
- (void)photoBrowserDidTapDoneButton:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
