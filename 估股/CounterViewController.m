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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[self.view setBackgroundColor:[Utiles colorWithHexString:@"#FDFBE4"]];
    [self.view setFrame:CGRectMake(0,0,320,676)];
    [self initComponents];
   
    UITapGestureRecognizer *backTap=[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTap:)] autorelease];
    [self.view addGestureRecognizer:backTap];
    
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.view addGestureRecognizer:pan];
    [pan release];
}

-(void)panView:(UIPanGestureRecognizer *)tap{
    CGPoint change=[tap translationInView:self.view];
    if(tap.state==UIGestureRecognizerStateChanged){
        self.view.frame=CGRectMake(0,MAX(MIN(standard.y+change.y,0),-100),SCREEN_WIDTH,678);
    }else if(tap.state==UIGestureRecognizerStateEnded){
        standard=self.view.frame.origin;
    }
    
}

-(void)backTap:(UITapGestureRecognizer *)tap{
    [self dismissText];
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
        [self addLabel:name frame:CGRectMake(10,n+=30,150,25) inputFrame:CGRectMake(160,m+=30,150,25) unit:[rUnits objectAtIndex:i++] index:j++ enable:NO];
    }
    
}


-(void)calBtClicked:(UIButton *)bt{

    self.floatParams=[self getParams];
    [self calTool];
}

-(void)dismissText{
    for(int i=0;i<[[[self.params objectForKey:@"pName"] componentsSeparatedByString:@","] count];i++){
        [(UITextField*)[self.view viewWithTag:100+i] resignFirstResponder];
    }
}

-(float)getText:(NSInteger)tag{
    return [[(UITextField*)[self.view viewWithTag:tag] text] floatValue];
}
-(void)setText:(NSString *)str tag:(NSInteger)tag{
    UITextField *field=(UITextField*)[self.view viewWithTag:tag];
    [field setText:[NSString stringWithFormat:@"%@",str]];
}

-(float)getParam:(NSInteger)n{
    return [[self.floatParams objectAtIndex:n] floatValue];
}

-(NSArray *)getParams{
    NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
    for(int i=0;i<[[[self.params objectForKey:@"pName"] componentsSeparatedByString:@","] count];i++){
        [temp addObject:[NSNumber numberWithFloat:[self getText:100+i]]];
    }
    return temp;
}

-(void)getBetaFactor:(UIButton *)bt{
    
    BetaFactorCountViewController *betaVC=[[[BetaFactorCountViewController alloc] init] autorelease];
    [betaVC setTitle:@"获取Beta系数"];
    betaVC.delegate=self;
    betaVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:betaVC animated:YES];
    
}

-(void)calTool{
    NSNumberFormatter *formatter=[[[NSNumberFormatter alloc] init] autorelease];
    if (self.toolType==BateFactor) {
        float f200=1-[self getParam:1]/100;
        float f201=[self getParam:0]/(1+(1-[self getParam:2]/100)*[self getParam:1]/100/f200);
        [formatter setNumberStyle:NSNumberFormatterPercentStyle];
        [self setText:[formatter stringFromNumber:[NSNumber numberWithFloat:f200]] tag:200];
        [formatter setPositiveFormat:@"###0.##"];
        [self setText:[formatter stringFromNumber:[NSNumber numberWithFloat:f201]] tag:201];
    }else if (self.toolType==Discountrate){
        float f200=([self getParam:0]*[self getParam:2]+[self getParam:3]+[self getParam:4]+[self getParam:1])/100;
        float f201=1-[self getParam:7]/100;
        float f202=f200*f201+(1-[self getParam:5]/100)*[self getParam:6]*[self getParam:7]/10000;
        [formatter setNumberStyle:NSNumberFormatterPercentStyle];
        [formatter setPositiveFormat:@"##.##"];
        [formatter setPositiveSuffix:@"%"];
        [self setText:[formatter stringFromNumber:[NSNumber numberWithFloat:f200*100]] tag:200];
        [self setText:[formatter stringFromNumber:[NSNumber numberWithFloat:f201*100]] tag:201];
        [self setText:[formatter stringFromNumber:[NSNumber numberWithFloat:f202*100]] tag:202];
    }else if (self.toolType==DiscountCashFlow){
        float f200=(([self getParam:2]/100*[self getParam:0]+[self getParam:0])/(([self getParam:1]-[self getParam:2])/100))/(1+[self getParam:1]/100)+[self getParam:0]/(1+[self getParam:1]/100);
        float f201=(f200-[self getParam:3]+[self getParam:4])/[self getParam:5];
        [formatter setPositiveFormat:@"####.##"];
        [formatter setPositiveSuffix:@"万元"];
        [self setText:[formatter stringFromNumber:[NSNumber numberWithFloat:f200]] tag:200];
        [formatter setPositiveSuffix:@"元"];
        [self setText:[formatter stringFromNumber:[NSNumber numberWithFloat:f201]] tag:201];
    }else if (self.toolType==FreeCashFlow){
        float f200=[self getParam:0]*(1-[self getParam:1]/100)+[self getParam:2]+[self getParam:3]-[self getParam:4];
        [formatter setPositiveSuffix:@"万元"];
        [self setText:[formatter stringFromNumber:[NSNumber numberWithFloat:f200]] tag:200];
    }else if (self.toolType==PEReturnOnInvest){
        float f200=[self getParam:0]/([self getParam:1]/100)-[self getParam:0];
        float f202=[self getParam:0]/([self getParam:1]/100);
        float f203=[self getParam:5]*[self getParam:7]*0.75*[self getParam:1]/100-[self getParam:0];
        float f204=f203-[self getParam:6];
        float f205=(f203-[self getParam:6])/[self getParam:0];
        float f206=powf(f205,(1/([self getParam:4]-[self getParam:2])))-1;
        [formatter setPositiveFormat:@"####.##"];
        [formatter setPositiveSuffix:@"万元"];
        [self setText:[formatter stringFromNumber:[NSNumber numberWithFloat:f200]] tag:200];
        [self setText:[formatter stringFromNumber:[NSNumber numberWithFloat:f202]] tag:202];
        [self setText:[formatter stringFromNumber:[NSNumber numberWithFloat:f203]] tag:203];
        [self setText:[formatter stringFromNumber:[NSNumber numberWithFloat:f204]] tag:204];
        [formatter setPositiveSuffix:@"倍"];
        [self setText:[formatter stringFromNumber:[NSNumber numberWithFloat:f205]] tag:205];
        [formatter setPositiveSuffix:@"%"];
        [self setText:[formatter stringFromNumber:[NSNumber numberWithFloat:f206]] tag:206];
    }
    
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
    
    textField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    if (flag) {
        textField.tag=100+index;
        textField.clearButtonMode=UITextFieldViewModeUnlessEditing;
    } else {
        textField.tag=200+index;
        textField.clearButtonMode=UITextFieldViewModeNever;
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
