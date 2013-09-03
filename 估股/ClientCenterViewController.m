//
//  ClientCenterViewController.m
//  UIDemo
//
//  Created by Xcode on 13-5-29.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ClientCenterViewController.h"
#import "SettingCenterViewController.h"
#import "DBLite.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "UIButton+BGColor.h"
#import "ClientLoginViewController.h"
#import "XYZAppDelegate.h"
#import "UILabel+VerticalAlign.h"




@interface ClientCenterViewController ()


@end

@implementation ClientCenterViewController

@synthesize userIdLabel;
@synthesize favoriteLabel;
@synthesize tradeLabel;
@synthesize regtimeLabel;
@synthesize userNameLabel;
@synthesize occupationalLabel;
@synthesize logoutBt;
@synthesize avatar;

@synthesize eventArr=_eventArr;
@synthesize dateDic=_dateDic;

- (void)dealloc
{
    SAFE_RELEASE(occupationalLabel);
    SAFE_RELEASE(userIdLabel);
    SAFE_RELEASE(favoriteLabel);
    SAFE_RELEASE(tradeLabel);
    SAFE_RELEASE(regtimeLabel);
    SAFE_RELEASE(avatar);
    SAFE_RELEASE(logoutBt);
    SAFE_RELEASE(_dateDic);
    SAFE_RELEASE(_eventArr);
    SAFE_RELEASE(userNameLabel);
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

    if(![Utiles isLogin]){
        ClientLoginViewController *loginViewController = [[ClientLoginViewController alloc] init];
        
        loginViewController.view.frame=CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT);
        XYZAppDelegate *delegate=[[UIApplication sharedApplication] delegate];
        [delegate.window addSubview:loginViewController.view];
        [self addChildViewController:loginViewController];
        [loginViewController release];
        
        CATransition *animation = [CATransition animation];
        animation.duration = 0.5f;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.fillMode = kCAFillModeForwards;
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromTop;
        [loginViewController.view.layer addAnimation:animation forKey:@"animation"];
    }else if([Utiles isLogin]){

        logoutBt.hidden=NO;
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [Utiles getUserToken], @"token",@"googuu",@"from",
                                nil];
        [Utiles postNetInfoWithPath:@"UserInfo" andParams:params besidesBlock:^(id resObj){

           if(![[resObj objectForKey:@"status"] isEqualToString:@"0"]){

               NSDictionary *occupationalList=[Utiles getConfigureInfoFrom:@"OccupationalList" andKey:nil inUserDomain:NO];
               
               id userInfo=[resObj objectForKey:@"data"];
               [userNameLabel setText:[userInfo objectForKey:@"nickname"]];
               [userIdLabel setText:[userInfo objectForKey:@"userid"]];
               
               [self setInfoType:@"trade" label:self.tradeLabel userInfo:userInfo dicName:@"TradeList"];
               [self setInfoType:@"favorite" label:self.favoriteLabel userInfo:userInfo dicName:@"InterestList"];
               
               [self.occupationalLabel setText:occupationalList[userInfo[@"profile"]]];
               NSDateFormatter *date=[[NSDateFormatter alloc] init];
               [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
               NSDate *d=[date dateFromString:[userInfo objectForKey:@"regtime"]];
               [date setDateFormat:@"yyyy-MM-dd"];
               [regtimeLabel setText:[date stringFromDate:d]];

               SAFE_RELEASE(date);
           }else{
               [Utiles ToastNotification:[resObj objectForKey:@"msg"] andView:self.view andLoading:NO andIsBottom:NO andIsHide:YES];
           }
            
            
        }];
        
    }else{
        logoutBt.hidden=YES;
    }
    
}

-(void)setInfoType:(NSString *)type label:(UILabel *)label userInfo:(id)userInfo dicName:(NSString *)name{
    NSDictionary *dic=[Utiles getConfigureInfoFrom:name andKey:nil inUserDomain:NO];
    NSString *str=@"";
    if(![Utiles isBlankString:[userInfo objectForKey:type]]){
        NSArray *tradeArr=[[userInfo objectForKey:type] componentsSeparatedByString:@","];
        
        for(id obj in tradeArr){
            str=[str stringByAppendingFormat:@"%@,",dic[obj]];
        }
        str=[str substringToIndex:([str length]-1)];
        [label setText:str];
        [label alignTop];        
    }else{
       [label setText:@""];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"个人中心"];
    
    self.view.backgroundColor=[Utiles colorWithHexString:@"#F3EFE1"];
    [self.logoutBt setBackgroundColorString:@"#C96125" forState:UIControlStateNormal];

    UIBarButtonItem *setting=[[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleBordered target:self action:@selector(setting:)];
    self.navigationItem.rightBarButtonItem=setting;
    favoriteLabel.numberOfLines = 10;
    tradeLabel.numberOfLines = 10;
    
    [setting release];
  
}



-(void)logoutBtClick:(id)sender{
    
    NSString *token= [Utiles getUserToken];
    if(token){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserToken"];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                token, @"token",@"googuu",@"from",
                                nil];
        [Utiles postNetInfoWithPath:@"LogOut" andParams:params besidesBlock:^(id info){
           
            if([[info objectForKey:@"status"] isEqualToString:@"1"]){
                NSLog(@"logout success");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LogOut" object:nil];
                logoutBt.hidden=YES;
                userNameLabel.text=@"";
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserToken"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserInfo"];
                [self viewDidAppear:YES];
            }else if([[info objectForKey:@"status"] isEqualToString:@"0"]){
                NSLog(@"logout failed:%@",[info objectForKey:@"msg"]);
            }
            
        }];
        
    }else{
        NSLog(@"logout failed");
    }
    

}


-(void)setting:(id)sender{
    
    SettingCenterViewController *setingViewController=[[SettingCenterViewController alloc] init];
    setingViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setingViewController animated:YES];
    [setingViewController release];
    
}

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        //NSLog(@"Reachable");
    }
    else
    {
        //NSLog(@"NReachable");
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(BOOL)shouldAutorotate{
    return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


















@end
