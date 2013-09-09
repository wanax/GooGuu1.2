//
//  GooNewsViewController.m
//  UIDemo
//
//  Created by Xcode on 13-6-14.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "GooNewsViewController.h"
#import "CustomTableView.h"
#import "GooNewsCell.h"
#import "EGORefreshTableHeaderView.h"
#import "WebKitAvailability.h"
#import "UIImageView+AFNetworking.h"
#import "GooGuuArticleViewController.h"
#import "MHTabBarController.h"
#import "ArticleCommentViewController.h"
#import "DailyStockCell.h"
#import "UIImageView+AFNetworking.h"
#import "SVPullToRefresh.h"
#import "ComFieldViewController.h"
#import "HelpViewController.h"
#import "Reachability.h"
#import "Toast+UIView.h"



@interface GooNewsViewController ()

@end

@implementation GooNewsViewController


@synthesize customTableView;
@synthesize arrList;
@synthesize imageUrl;
@synthesize companyInfo;
@synthesize readingMarksDic;
@synthesize container;
@synthesize hud;

- (void)dealloc
{
    SAFE_RELEASE(container);
    [readingMarksDic release];readingMarksDic=nil;
    [companyInfo release];companyInfo=nil;
    [hud release];hud=nil;
    [customTableView release];customTableView=nil;
    [arrList release];arrList=nil;
    [imageUrl release];imageUrl=nil;
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

-(void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
}

-(void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
    [self.customTableView reloadData];
}
-(void)helpAction:(id)sender{
    
    HelpViewController *help=[[HelpViewController alloc] init];
    help.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:help animated:YES];
    SAFE_RELEASE(help);
    
}
-(void)addHelpBt{
    
    UIButton *wanSay= [[UIButton alloc] initWithFrame:CGRectMake(200, 10.0, 30, 30)];
    [wanSay setImage:[UIImage imageNamed:@"helpBt"] forState:UIControlStateNormal];
    [wanSay addTarget:self action:@selector(helpAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *nextStepBarBtn = [[UIBarButtonItem alloc] initWithCustomView:wanSay];
    [self.navigationItem setRightBarButtonItem:nextStepBarBtn animated:YES];
  
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self addHelpBt];
    
    self.navigationController.navigationBar.tintColor=[Utiles colorWithHexString:@"#C86125"];
    self.title=@"最新简报";
    self.readingMarksDic=[Utiles getConfigureInfoFrom:@"readingmarks" andKey:nil inUserDomain:YES];
    
   	
    [self addTable];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getGooGuuNews];    
    [self addTableAction];
    
}

-(void)addTable{
    
    customTableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,370)];
    [self.customTableView setBackgroundColor:[Utiles colorWithHexString:[Utiles getConfigureInfoFrom:@"colorconfigure" andKey:@"NormalCellColor" inUserDomain:NO]]];
    customTableView.dataSource=self;
    customTableView.delegate=self;
    [self.view addSubview:customTableView];
    
}

-(void)addTableAction{
    
    [self.customTableView addInfiniteScrollingWithActionHandler:^{
        [self addGooGuuNews];
    }];    
    if(_refreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.customTableView.bounds.size.height, self.view.frame.size.width, self.customTableView.bounds.size.height)];
        
        view.delegate = self;
        [self.customTableView addSubview:view];
        _refreshHeaderView = view;
        [view release];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
}



#pragma mark -
#pragma mark Net Get JSON Data

-(void)addGooGuuNews{
    
    NSString *arId=[[self.arrList lastObject] objectForKey:@"articleid"];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:arId,@"articleid", nil];
    [Utiles getNetInfoWithPath:@"NewesAnalysereportURL" andParams:params besidesBlock:^(id resObj){

        NSMutableArray *exNews=[resObj objectForKey:@"data"];
        NSMutableArray *temp=[NSMutableArray arrayWithArray:self.arrList];
        for(id obj in exNews){
            [temp addObject:obj];
        }
        self.arrList=temp;
        [self.customTableView reloadData];
        [self.customTableView.infiniteScrollingView stopAnimating];
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
    
}

//网络获取数据
- (void)getGooGuuNews{
 
    [Utiles getNetInfoWithPath:@"NewesAnalysereportURL" andParams:nil besidesBlock:^(id news){
        
        self.arrList=[news objectForKey:@"data"];
        [self.customTableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.customTableView];
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"%@",error.localizedDescription);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
    
    [Utiles getNetInfoWithPath:@"DailyStock" andParams:nil besidesBlock:^(id obj){
        
        self.imageUrl=[NSString stringWithFormat:@"%@",[obj objectForKey:@"comanylogourl"]];
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[obj objectForKey:@"stockcode"],@"stockcode", nil];
        [Utiles getNetInfoWithPath:@"QueryCompany" andParams:params besidesBlock:^(id resObj){
            
            self.companyInfo=resObj;
            [self.customTableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            NSLog(@"%@",error.localizedDescription);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        [self.customTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"%@",error.localizedDescription);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.customTableView];
    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table Data Source Methods

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        return 86.0;
    }else{
        return 71.0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section==0){
        return 1;
    }else if(section==1){
        return [self.arrList count];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int section=indexPath.section;
    
    if(section==0){
        
        static NSString *DailyStockCellIdentifier = @"DailyStockCellIdentifier";
        DailyStockCell *cell = (DailyStockCell*)[tableView dequeueReusableCellWithIdentifier:DailyStockCellIdentifier];//复用cell
        
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"DailyStockCell" owner:self options:nil];//加载自定义cell的xib文件
            cell = [array objectAtIndex:0];
        }
        if(self.imageUrl){
            [cell.dailyStockImg setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.imageUrl]]
                  placeholderImage:[UIImage imageNamed:@"defaultIcon"]
                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                               if(image){
                                   cell.dailyStockImg.image=image;
                               }           
                           }
                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                               
                           }];
        }
        static NSNumberFormatter *formatter;
        if(formatter==nil){
            formatter=[[NSNumberFormatter alloc] init];
            [formatter setPositiveFormat:@"##0.##"];
        }
        
        NSNumber *marketPrice=[self.companyInfo objectForKey:@"marketprice"];
        NSNumber *ggPrice=[self.companyInfo objectForKey:@"googuuprice"];
        float outLook=([ggPrice floatValue]-[marketPrice floatValue])/[marketPrice floatValue];
        cell.marketPriceLabel.text=[NSString stringWithFormat:@"%@",[formatter stringFromNumber:marketPrice]];
        cell.companyNameLabel.text=[NSString stringWithFormat:@"%@\n(%@.%@)",[self.companyInfo objectForKey:@"companyname"],[self.companyInfo objectForKey:@"stockcode"],[self.companyInfo objectForKey:@"marketname"]];
        cell.gooGuuPriceLabel.text=[NSString stringWithFormat:@"%@",[formatter stringFromNumber:ggPrice]];
        cell.tradeLabel.text=[self.companyInfo objectForKey:@"trade"];
        cell.outLookLabel.text=[NSString stringWithFormat:@"%.2f%%",outLook*100];
        
        NSString *riseColorStr=[NSString stringWithFormat:@"RiseColor%@",[Utiles getConfigureInfoFrom:@"userconfigure" andKey:@"stockColorSetting" inUserDomain:YES]];
        NSString *fallColorStr=[NSString stringWithFormat:@"FallColor%@",[Utiles getConfigureInfoFrom:@"userconfigure" andKey:@"stockColorSetting" inUserDomain:YES]];
        NSString *riseColor=[Utiles getConfigureInfoFrom:@"colorconfigure" andKey:riseColorStr inUserDomain:NO];
        NSString *fallColor=[Utiles getConfigureInfoFrom:@"colorconfigure" andKey:fallColorStr inUserDomain:NO];
        
        if(outLook>0){
            [cell.outLookLabel setTextColor:[Utiles colorWithHexString:riseColor]];
            [cell.arrowImg setImage:[UIImage imageNamed:@"riseArrow"]];
        }else if(outLook==0){
            [cell.outLookLabel setTextColor:[UIColor whiteColor]];
        }else if(outLook<0){
            [cell.outLookLabel setTextColor:[Utiles colorWithHexString:fallColor]];
            [cell.arrowImg setImage:[UIImage imageNamed:@"fallArrow"]];
        }
        
        UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,86)];
        backView.backgroundColor=[Utiles colorWithHexString:[Utiles getConfigureInfoFrom:@"colorconfigure" andKey:@"DailyStockCellBackGroundColor" inUserDomain:NO]];
        [cell setBackgroundView:backView];
        [backView release];backView=nil;
        SAFE_RELEASE(formatter);
        return cell;
        
    }else if(section==1){
        static NSString *GooNewsCellIdentifier = @"GooNewsCellIdentifier";
        static BOOL nibsRegistered = NO;
        if (!nibsRegistered) {
            UINib *nib = [UINib nibWithNibName:@"GooNewsCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:GooNewsCellIdentifier];
            nibsRegistered = YES;
        }
        
        GooNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:GooNewsCellIdentifier];
        if (cell == nil) {
            cell = [[[GooNewsCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier: GooNewsCellIdentifier] autorelease];
        }
        
        int row=[indexPath row];
        id model=[arrList objectAtIndex:row];
        
        cell.title=[model objectForKey:@"title"];
        [self setReadingMark:cell andTitle:[model objectForKey:@"title"]];
        cell.contentLabel.text=[model objectForKey:@"concise"];
        cell.timeDiferLabel.text=[Utiles intervalSinceNow:[model objectForKey:@"updatetime"]];
        
        UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,71)];
        [bgImgView setImage:[UIImage imageNamed:@"newscellbackground.png"]];
        
        [cell setBackgroundView:bgImgView];
        [bgImgView release];bgImgView=nil;
        
        [cell setBackgroundColor:[Utiles colorWithHexString:@"#FEF8F8"]];
        
        
        return cell;
    }
    
    return nil;

}

#pragma mark -
#pragma mark General Methods

-(void)setReadingMark:(GooNewsCell *)cell andTitle:(NSString *)title{
    
    if(readingMarksDic){
        if ([[readingMarksDic allKeys] containsObject:title]) {
            cell.readMarkImg.image=[UIImage imageNamed:@"readed"];
        }else{
            cell.readMarkImg.image=[UIImage imageNamed:@"unread"];
        }
    }else{
        cell.readMarkImg.image=[UIImage imageNamed:@"unread"];
    }
    
}



#pragma mark -
#pragma mark Table Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        XYZAppDelegate *delegate=[[UIApplication sharedApplication] delegate];
        delegate.comInfo=self.companyInfo;
        ComFieldViewController *com=[[ComFieldViewController alloc] init];
        com.browseType=ValuationModelType;
        com.view.frame=CGRectMake(0,20,SCREEN_WIDTH,SCREEN_HEIGHT);
        [self presentViewController:com animated:YES completion:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }else if(indexPath.section==1){
        XYZAppDelegate *delegate=[[UIApplication sharedApplication] delegate];
        delegate.comInfo=[self.arrList objectAtIndex:indexPath.row];
        NSString *artId=[NSString stringWithFormat:@"%@",[[self.arrList objectAtIndex:indexPath.row] objectForKey:@"articleid"]];
        GooGuuArticleViewController *articleViewController=[[GooGuuArticleViewController alloc] init];
        articleViewController.articleTitle=[[arrList objectAtIndex:indexPath.row] objectForKey:@"title"];
        articleViewController.articleId=artId;
        articleViewController.title=@"研究报告";
        ArticleCommentViewController *articleCommentViewController=[[ArticleCommentViewController alloc] init];
        articleCommentViewController.articleId=artId;
        articleCommentViewController.title=@"评论";
        articleCommentViewController.type=News;
        container=[[MHTabBarController alloc] init];
        NSArray *controllers=[NSArray arrayWithObjects:articleViewController,articleCommentViewController, nil];
        container.viewControllers=controllers;
        
        [Utiles setConfigureInfoTo:@"readingmarks" forKey:[[self.arrList objectAtIndex:indexPath.row] objectForKey:@"title"] andContent:@"1"];
        self.readingMarksDic=[Utiles getConfigureInfoFrom:@"readingmarks" andKey:nil inUserDomain:YES];
        container.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:container animated:YES];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        SAFE_RELEASE(articleViewController);
        SAFE_RELEASE(articleCommentViewController);
    }
    
}



#pragma mark -
#pragma mark - Table Header View Methods


- (void)doneLoadingTableViewData{
    
    [self getGooGuuNews];  
    _reloading = NO;
    
}


#pragma mark –
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark –
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [_activityIndicatorView startAnimating];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
  
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    
    return _reloading; // should return if data source model is reloading
    
}
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}

-(NSUInteger)supportedInterfaceOrientations{

    return UIInterfaceOrientationMaskPortrait;
}


-(BOOL)shouldAutorotate{
    return NO;
}














@end
