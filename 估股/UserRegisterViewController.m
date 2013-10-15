//
//  UserRegisterViewController.m
//  googuu
//
//  Created by Xcode on 13-10-15.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "UserRegisterViewController.h"
#import "IQKeyBoardManager.h"

@interface UserRegisterViewController ()

@end

typedef enum{
    
    PhoneNum=100,
    CheckCode=101,
    Pwd=102,
    CheckPwd=103
    
} TextFieldType;

@implementation UserRegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)backTap:(UITapGestureRecognizer *)tap{
    for(int i=0;i<4;i++){
        [(UITextField*)[self.view viewWithTag:100+i] resignFirstResponder];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[Utiles colorWithHexString:@"#FDFBE4"]];
    [IQKeyBoardManager installKeyboardManager];
    [IQKeyBoardManager enableKeyboardManger];
    [self initComponents];
    
    UITapGestureRecognizer *backTap=[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTap:)] autorelease];
    [self.view addGestureRecognizer:backTap];
	
}

-(void)initComponents{
    
    [self addSingleLabel:@"手机号码" frame:CGRectMake(10,50,80,25)];
    [self addTextField:@"限大陆11位手机号码" frame:CGRectMake(100,50,200,30) tag:PhoneNum];
    
    UIButton *getCheckCodeBt=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [getCheckCodeBt setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getCheckCodeBt setFrame:CGRectMake(10,90,80,30)];
    [getCheckCodeBt addTarget:self action:@selector(getCheckCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getCheckCodeBt];
    
    [self addTextField:@"输入验证码" frame:CGRectMake(130,90,110,30) tag:CheckCode];
    
    if (self.actionType==UserResetPwd) {
        [self addSingleLabel:@"老密码" frame:CGRectMake(10,135,80,25)];
        [self addSingleLabel:@"新密码" frame:CGRectMake(10,175,80,25)];
        [self addTextField:@"" frame:CGRectMake(100,135,200,30) tag:Pwd];
        [self addTextField:@"" frame:CGRectMake(100,175,200,30) tag:CheckPwd];
    } else {
        [self addSingleLabel:@"密码" frame:CGRectMake(10,135,80,25)];
        [self addSingleLabel:@"确认密码" frame:CGRectMake(10,175,80,25)];
        [self addTextField:@"" frame:CGRectMake(100,135,200,30) tag:Pwd];
        [self addTextField:@"" frame:CGRectMake(100,175,200,30) tag:CheckPwd];
    }
    
    UIButton *regBt=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [regBt setBackgroundColor:[UIColor orangeColor]];
    [regBt setFrame:CGRectMake(10,220,SCREEN_WIDTH-30,30)];
    if (self.actionType==UserResetPwd) {
        [regBt setTitle:@"重置密码" forState:UIControlStateNormal];
        [regBt addTarget:self action:@selector(resetPwd:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:regBt];
    } else {
        [regBt setTitle:@"注册" forState:UIControlStateNormal];
        [regBt addTarget:self action:@selector(userReg:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:regBt];
    }

    UIButton *backBt=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backBt setTitle:@"返回" forState:UIControlStateNormal];
    [backBt setBackgroundColor:[UIColor orangeColor]];
    [backBt setFrame:CGRectMake(10,260,SCREEN_WIDTH-30,30)];
    [backBt addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBt];
}

#pragma mark -
#pragma mark Bt Action

-(void)back:(UIButton *)bt{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)resetPwd:(UIButton *)bt{
    
}

-(void)getCheckCode:(UIButton *)bt{
    
    [bt setEnabled:NO];
    [MBProgressHUD showHUDAddedTo:self.view withTitle:@"" animated:YES];
    [bt setTitle:@"请稍后" forState:UIControlStateDisabled];
    NSString *phoneNum=[(UITextField *)[self.view viewWithTag:PhoneNum] text];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:phoneNum,@"mobile", nil];
    [Utiles getNetInfoWithPath:@"UserRegVaildCode" andParams:params besidesBlock:^(id obj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络错误" duration:1.0];
    }];
    
}

-(void)userReg:(UIButton *)bt{
    
    [MBProgressHUD showHUDAddedTo:self.view withTitle:@"" animated:YES];
    NSString *phoneNum=[(UITextField *)[self.view viewWithTag:PhoneNum] text];
    NSString *code=[(UITextField *)[self.view viewWithTag:CheckCode] text];
    NSString *passWord=[(UITextField *)[self.view viewWithTag:Pwd] text];
    
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:phoneNum,@"mobile",code,@"code",[Utiles md5:passWord],@"password", nil];
    
    [Utiles postNetInfoWithPath:@"UserRegister" andParams:params besidesBlock:^(id obj) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if([[obj objectForKey:@"status"] integerValue]!=1){
            [Utiles showToastView:self.view withTitle:nil andContent:[obj objectForKey:@"msg"] duration:2.0];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络错误" duration:1.0];
    }];
    
}

#pragma mark -
#pragma Components init

-(void)addSingleLabel:(NSString *)name frame:(CGRect)rect{
    UILabel *label=[[[UILabel alloc] initWithFrame:rect] autorelease];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [label setText:name];
    [self.view addSubview:label];
}

-(void)addTextField:(NSString *)title frame:(CGRect)rect tag:(NSInteger)tag{
    UITextField *textField = [[[UITextField alloc] initWithFrame:rect] autorelease];
    textField.delegate = self;
    textField.keyboardType=UIKeyboardTypeDecimalPad;
    [textField setBackgroundColor:[UIColor whiteColor]];
    textField.placeholder = title;
    [textField setTag:tag];
    [textField placeholderRectForBounds:CGRectMake(20,5,80,20)];
    textField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    textField.borderStyle=UITextBorderStyleRoundedRect;
    textField.clearButtonMode=UITextFieldViewModeUnlessEditing;
    textField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    [textField addPreviousNextDoneOnKeyboardWithTarget:self previousAction:@selector(previousClicked:) nextAction:@selector(nextClicked:) doneAction:@selector(doneClicked:)];
    if (tag == PhoneNum){
        [textField setEnablePrevious:NO next:YES];
    }else if(tag== CheckPwd){
        [textField setEnablePrevious:YES next:NO];
    }
    if (tag>101) {
        textField.keyboardType=UIKeyboardTypeDefault;
        textField.secureTextEntry = YES;
    }
    [self.view addSubview:textField];
}

#pragma mark -
#pragma TextField Delegate

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

-(BOOL)shouldAutorotate{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
