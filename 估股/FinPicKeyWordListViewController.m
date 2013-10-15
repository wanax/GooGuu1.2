//
//  FinPicKeyWordListViewController.m
//  googuu
//
//  Created by Xcode on 13-10-14.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "FinPicKeyWordListViewController.h"
#import "FinancePicViewController.h"

@interface FinPicKeyWordListViewController ()

@end

@implementation FinPicKeyWordListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"金融图汇";
    
    self.cusTabView=[[UITableView alloc] init];
    self.cusTabView.frame=CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-44);
    self.cusTabView.delegate=self;
    self.cusTabView.dataSource=self;
    [self.view addSubview:self.cusTabView];
    
    [self getKeyWordList];

}

-(void)getKeyWordList{
    [Utiles getNetInfoWithPath:@"FchartKeyWord" andParams:nil besidesBlock:^(id obj) {
        
        self.keyWordData=obj;
        NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
        for (id obj in self.keyWordData) {
            [temp addObject:[obj objectForKey:@"keyword"]];
        }
        self.keyWordList=temp;
        [self.cusTabView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.keyWordList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *KeyWordCellIdentifier = @"KeyWordCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KeyWordCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:KeyWordCellIdentifier];
    }
    
    [cell.textLabel setText:[self.keyWordList objectAtIndex:indexPath.row]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Heiti SC" size:14.0]];
    
    return cell;
    
}

#pragma mark -
#pragma Table Delegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FinancePicViewController *picVC=[[[FinancePicViewController alloc] init] autorelease];
    picVC.keyWord=[self.keyWordList objectAtIndex:indexPath.row];
    picVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:picVC animated:YES];
    
}











- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
