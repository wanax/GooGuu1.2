//
//  XYZAppDelegate.m
//  welcom_demo_1
//
//  Created by chaoxiao zhuang on 13-1-10.
//  Copyright (c) 2013年 Pony Finance. All rights reserved.
//

#import "XYZAppDelegate.h"
#import "tipViewController.h"
#import "ConcernedViewController.h"
#import "ClientCenterViewController.h"
#import "DBLite.h"
#import "ConcernedViewController.h"
#import "GooNewsViewController.h"
#import "MyGooguuViewController.h"
#import "FinanceToolsViewController.h"
#import "UniverseViewController.h"
#import "ChartViewController.h"
#import "Company.h"
#import "PrettyNavigationController.h"
#import "PrettyTabBarViewController.h"
#import "Reachability.h"
#import "ChartViewController.h"
#import "CommonlyMacros.h"
#import <Crashlytics/Crashlytics.h>
#import "SettingCenterViewController.h"
#import "AgreementViewController.h"
#import "ProAlertView.h"
#import "PonyDebugger.h"


@implementation XYZAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize scrollView;
@synthesize pageControl;
@synthesize loginTimer;
@synthesize comInfo;
@synthesize popoverController;

- (void)dealloc
{
    [popoverController release];
    [loginTimer release];
    [comInfo release];
    [scrollView release];
    [tabBarController release];
    [pageControl release];
    [window release];
    [super dealloc];
}

-(void)setPonyDebugger{
    PDDebugger *debugger = [PDDebugger defaultInstance];
    [debugger enableNetworkTrafficDebugging];
    [debugger forwardAllNetworkTraffic];
    
    [debugger enableViewHierarchyDebugging];
    [debugger setDisplayedViewAttributeKeyPaths:@[@"frame", @"hidden", @"alpha", @"opaque"]];
    
    [debugger enableRemoteLogging];
    [debugger connectToURL:[NSURL URLWithString:@"ws://localhost:9000/device"]];
}

-(void)beginStatistics{
    
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.enableExceptionLog = YES;
    //statTracker.logStrategy = BaiduMobStatLogStrategyCustom;
    //statTracker.logSendInterval=1;
    statTracker.logSendWifiOnly = YES;
    [statTracker startWithAppId:@"0737a8b0ff"];
    
}
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1)
    {
        NSString *iTunesLink = @"itms-apps://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=703282718&mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]]; 
    }
}
-(void)checkUpdate{
    AFHTTPClient *getAction=[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://itunes.apple.com"]];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:@"703282718",@"id",nil];
    
    [getAction getPath:@"/lookup" parameters:params success:^(AFHTTPRequestOperation *operation,id responseObject){

        NSString *version = @"";      
        NSArray *configData = [[operation.responseString objectFromJSONString] valueForKey:@"results"];
        
        for (id config in configData)
        {
            version = [config valueForKey:@"version"];
        }
        //Check your version with the version in app store
        if (![version isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"version"]])
        {
            ProAlertView *createUserResponseAlert = [[ProAlertView alloc] initWithTitle:@"新版本" message: @"下载新的版本" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"下载", nil];
            [createUserResponseAlert show];
            [createUserResponseAlert release];  
        }
        
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        
    }];

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //[self setPonyDebugger];
    
    [Utiles setConfigureInfoTo:@"userconfigure" forKey:@"stockColorSetting" andContent:[NSString stringWithFormat:@"%d",0]];

    [[NSUserDefaults standardUserDefaults] setObject:@"1.0.1" forKey:@"version"];

    [self beginStatistics];
    
    
    [Crashlytics startWithAPIKey:@"c59317990c405b2f42582cacbe9f4fa9abe1fefb"];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"firstLaunch"]==nil) {
        //用户初次使用进入使用引导界面
        [Utiles setConfigureInfoTo:@"userconfigure" forKey:@"checkUpdate" andContent:@"0"];
        tipViewController * startView = [[tipViewController alloc]init];
        self.window.rootViewController = startView;
        [startView release];
    }else if([[NSUserDefaults standardUserDefaults] objectForKey:@"agreement"]==nil){
        
        AgreementViewController * agreement = [[AgreementViewController alloc]init];
        self.window.rootViewController = agreement;
        [agreement release];
        
    }else {
        if([Utiles getConfigureInfoFrom:@"userconfigure" andKey:@"checkUpdate" inUserDomain:YES]){
            BOOL isOn=[Utiles stringToBool:[Utiles getConfigureInfoFrom:@"userconfigure" andKey:@"checkUpdate" inUserDomain:YES]];
            if(isOn){
                [self checkUpdate];
            }
        }
        
        UITabBarItem *barItem=[[UITabBarItem alloc] initWithTitle:@"最新简报" image:[UIImage imageNamed:@"googuuNewsBar"] tag:1];
        UITabBarItem *barItem2=[[UITabBarItem alloc] initWithTitle:@"我的估股" image:[UIImage imageNamed:@"myGooGuuBar"] tag:2];
        UITabBarItem *barItem3=[[UITabBarItem alloc] initWithTitle:@"金融工具" image:[UIImage imageNamed:@"hammer.png"] tag:3];
        UITabBarItem *barItem4=[[UITabBarItem alloc] initWithTitle:@"功能设置" image:[UIImage imageNamed:@"moreAboutBar"] tag:4];
        UITabBarItem *barItem5=[[UITabBarItem alloc] initWithTitle:@"估值模型" image:[UIImage imageNamed:@"companyListBar"] tag:5];
        
        //股票关注
        MyGooguuViewController *myGooGuu=[[MyGooguuViewController alloc] init];
        myGooGuu.tabBarItem=barItem2;
        UINavigationController *myGooGuuNavController=nil;
        
        
        //客户设置
        SettingCenterViewController *settingView=[[SettingCenterViewController alloc] init];
        settingView.tabBarItem=barItem4;
        UINavigationController *clientCenterNav=nil;
        
        
        //估股新闻
        GooNewsViewController *gooNewsViewController=[[GooNewsViewController alloc] init];
        gooNewsViewController.tabBarItem=barItem;
        UINavigationController *gooNewsNavController=nil;
        
        
        //股票列表
        UniverseViewController *universeViewController=[[UniverseViewController alloc] init];
        universeViewController.tabBarItem=barItem5;
        UINavigationController *universeNav=nil;
        
        if (IOS7_OR_LATER) {
            
            myGooGuuNavController=[[UINavigationController alloc] initWithRootViewController:myGooGuu];
            clientCenterNav=[[UINavigationController alloc] initWithRootViewController:settingView];
            gooNewsNavController=[[UINavigationController alloc] initWithRootViewController:gooNewsViewController];
            universeNav=[[UINavigationController alloc] initWithRootViewController:universeViewController];

            self.tabBarController = [[UITabBarController alloc] init];
        } else {
            myGooGuuNavController=[[PrettyNavigationController alloc] initWithRootViewController:myGooGuu];
            clientCenterNav=[[PrettyNavigationController alloc] initWithRootViewController:settingView];
            gooNewsNavController=[[PrettyNavigationController alloc] initWithRootViewController:gooNewsViewController];
            universeNav=[[PrettyNavigationController alloc] initWithRootViewController:universeViewController];
            self.tabBarController = [[PrettyTabBarViewController alloc] init];
        }
        
        
        self.tabBarController.viewControllers = [NSArray arrayWithObjects:gooNewsNavController,universeNav,myGooGuuNavController, clientCenterNav ,nil];
        
        self.window.backgroundColor=[UIColor clearColor];
        self.window.rootViewController = self.tabBarController;
        
        
        SAFE_RELEASE(barItem);
        SAFE_RELEASE(barItem2);
        SAFE_RELEASE(barItem3);
        SAFE_RELEASE(barItem4);
        SAFE_RELEASE(barItem5);
        
        SAFE_RELEASE(myGooGuu);
        SAFE_RELEASE(settingView);
        SAFE_RELEASE(gooNewsNavController);
        SAFE_RELEASE(universeViewController);
        
        SAFE_RELEASE(myGooGuuNavController);
        SAFE_RELEASE(clientCenterNav);
        SAFE_RELEASE(gooNewsNavController);
        SAFE_RELEASE(universeNav);
        
    }
    
    if([Utiles isLogin]){
        
        [self handleTimer:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginKeeping" object:nil];
        loginTimer = [NSTimer scheduledTimerWithTimeInterval: 7000// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                                      target: self
                                                    selector: @selector(handleTimer:)
                                                    userInfo: nil
                                                     repeats: YES];
    }
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    reach.reachableOnWWAN = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    [reach startNotifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginKeeping:) name:@"LoginKeeping" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelLoginKeeping:) name:@"LogOut" object:nil];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable]){
        NSLog(@"Reachable");
        self.isReachable=YES;
    }else{
        NSLog(@"NReachable");
        self.isReachable=NO;
    }
}

-(void)loginKeeping:(NSNotification*)notification{
    
    loginTimer = [NSTimer scheduledTimerWithTimeInterval: 7000// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                                  target: self
                                                selector: @selector(handleTimer:)
                                                userInfo: nil
                                                 repeats: YES];
}
-(void)cancelLoginKeeping:(NSNotification*)notification{
    [loginTimer invalidate];
}


- (void) handleTimer: (NSTimer *) timer{
    
    NSUserDefaults *userDeaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[[[userDeaults objectForKey:@"UserInfo"] objectForKey:@"username"] lowercaseString],@"username",[Utiles md5:[[userDeaults objectForKey:@"UserInfo"] objectForKey:@"password"]],@"password",@"googuu",@"from", nil];
    [Utiles getNetInfoWithPath:@"Login" andParams:params besidesBlock:^(id resObj){
        
        if([[resObj objectForKey:@"status"] isEqualToString:@"1"]){
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:@"UserToke"];
            [userDefaults setObject:[resObj objectForKey:@"token"] forKey:@"UserToken"];
            
            NSLog(@"%@",[resObj objectForKey:@"token"]);
            
        }else {
            NSLog(@"%@",[resObj objectForKey:@"msg"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}




@end