//
//  CounterViewController.m
//  googuu
//
//  Created by Xcode on 13-10-9.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "CounterViewController.h"
#import "BetaFactorCountViewController.h"
#import "IQKeyBoardManager.h"

@interface CounterViewController ()

@end

@implementation CounterViewController

-(void)gotBeta:(NSString *)betaFactor{
    [(UITextField*)[self.view viewWithTag:100] setText:betaFactor];
}

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

	[self.view setBackgroundColor:[Utiles colorWithHexString:@"#FDFBE4"]];
    [self initComponents];
   
    UITapGestureRecognizer *backTap=[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTap:)] autorelease];
    [self.view addGestureRecognizer:backTap];
}

-(void)backTap:(UITapGestureRecognizer *)tap{
    for(int i=0;i<[[[self.params objectForKey:@"pName"] componentsSeparatedByString:@","] count];i++){
        [(UITextField*)[self.view viewWithTag:100+i] resignFirstResponder];
    }
}


-(void)initComponents{
    
    [IQKeyBoardManager installKeyboardManager];
    [IQKeyBoardManager enableKeyboardManger];

    //添加参数名和参数输入input
    NSArray *pNames=[[self.params objectForKey:@"pName"] componentsSeparatedByString:@","];
    NSArray *pUnits=[[self.params objectForKey:@"pUnit"] componentsSeparatedByString:@","];
    int n=50,m=50,i=0,j=0;
    for(NSString *name in pNames){
        [self addLabel:name frame:CGRectMake(10,n+=30,150,25) inputFrame:CGRectMake(160,m+=30,100,25) unit:[pUnits objectAtIndex:i++] index:j++ enable:YES];
    }
    
    //添加计算button
    UIButton *calBt=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [calBt setTitle:@"计算" forState:UIControlStateNormal];
    [calBt setBackgroundColor:[UIColor grayColor]];
    [calBt setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [calBt setFrame:CGRectMake(10,m+40,SCREEN_WIDTH-20,30)];
    [calBt.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:14.0]];
    [calBt addTarget:self action:@selector(calBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:calBt];
    
    //添加结果名和结果显示label
    NSArray *rNames=[[self.params objectForKey:@"rName"] componentsSeparatedByString:@","];
    NSArray *rUnits=[[self.params objectForKey:@"rUnit"] componentsSeparatedByString:@","];
    n+=50,m+=50,i=0,j=0;
    for(NSString *name in rNames){
        [self addLabel:name frame:CGRectMake(10,n+=30,150,25) inputFrame:CGRectMake(160,m+=30,100,25) unit:[rUnits objectAtIndex:i++] index:j++ enable:NO];
    }
    
}


-(void)calBtClicked:(UIButton *)bt{
    NSLog(@"calie");
}

-(void)getBetaFactor:(UIButton *)bt{
    
    BetaFactorCountViewController *betaVC=[[[BetaFactorCountViewController alloc] init] autorelease];
    [betaVC setTitle:@"获取Beta系数"];
    betaVC.delegate=self;
    betaVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:betaVC animated:YES];
    
}

-(void)addLabel:(NSString *)name frame:(CGRect)rect inputFrame:(CGRect)rect2 unit:(NSString *)unit index:(NSInteger)index enable:(BOOL)flag{
    
    UILabel *label=[[[UILabel alloc] initWithFrame:rect] autorelease];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [label setText:name];
    [self.view addSubview:label];

    UITextField *textField=[[UITextField alloc] initWithFrame:rect2];
    textField.delegate=self;
    textField.keyboardType=UIKeyboardTypeDecimalPad;
    [textField setBackgroundColor:[UIColor whiteColor]];
    textField.placeholder = unit;
    [textField setEnabled:flag];
    [textField placeholderRectForBounds:CGRectMake(20,5,80,20)];
    textField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    textField.borderStyle=UITextBorderStyleRoundedRect;
    textField.clearButtonMode=UITextFieldViewModeUnlessEditing;
    textField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    if (flag) {
        textField.tag=100+index;
    } else {
        textField.tag=200+index;
    }
    [textField addPreviousNextDoneOnKeyboardWithTarget:self previousAction:@selector(previousClicked:) nextAction:@selector(nextClicked:) doneAction:@selector(doneClicked:)];
    [self.view addSubview:textField];
    
    if([unit isEqualToString:@"0"]){
        UIButton *getBetaBt=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [getBetaBt setTitle:@"获取Beta值" forState:UIControlStateNormal];
        [getBetaBt setFrame:CGRectMake(rect2.origin.x+rect2.size.width-15,rect2.origin.y-3,70,30)];
        [getBetaBt.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:12.0]];
        [getBetaBt addTarget:self action:@selector(getBetaFactor:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:getBetaBt];
        [textField setFrame:CGRectMake(rect2.origin.x-20,rect2.origin.y,rect2.size.width,rect2.size.height)];
    }

}
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    //return CGRectInset(bounds, 20, 0);
    CGRect inset = CGRectMake(bounds.origin.x+100, bounds.origin.y, bounds.size.width -10, bounds.size.height);
    return inset;
}

-(void)enableKeyboardManger:(UIBarButtonItem*)barButton
{
    [IQKeyBoardManager enableKeyboardManger];
}

-(void)disableKeyboardManager:(UIBarButtonItem*)barButton
{
    [IQKeyBoardManager disableKeyboardManager];
}


-(void)previousClicked:(UISegmentedControl*)segmentedControl
{
    [(UITextField*)[self.view viewWithTag:selectedTextFieldTag-1] becomeFirstResponder];
}

-(void)nextClicked:(UISegmentedControl*)segmentedControl
{
    [(UITextField*)[self.view viewWithTag:selectedTextFieldTag+1] becomeFirstResponder];
}

-(void)doneClicked:(UIBarButtonItem*)barButton
{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    selectedTextFieldTag = textField.tag;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
