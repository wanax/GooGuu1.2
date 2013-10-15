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
    Pwd=101,
    Pwd2=102,
    CheckCode=103,
    
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

    if (self.actionType!=UserResetPwd) {
        [self addSingleLabel:@"手机号码" frame:CGRectMake(10,50,80,25)];
        [self addTextField:@"限大陆11位手机号码" frame:CGRectMake(100,50,200,30) tag:PhoneNum type:UIKeyboardTypeDecimalPad isSecure:NO];
    }else{
        [self addSingleLabel:@"用户名" frame:CGRectMake(10,50,80,25)];
        [self addTextField:@"昵称/手机号/邮箱" frame:CGRectMake(100,50,200,30) tag:PhoneNum type:UIKeyboardTypeDefault isSecure:NO];
    }

    if (self.actionType==UserResetPwd) {
        [self addSingleLabel:@"老密码" frame:CGRectMake(10,90,80,25)];
        [self addTextField:@"" frame:CGRectMake(100,90,200,30) tag:Pwd type:UIKeyboardTypeDefault isSecure:YES];
        [self addSingleLabel:@"新密码" frame:CGRectMake(10,130,80,25)];
        [self addTextField:@"" frame:CGRectMake(100,130,200,30) tag:Pwd2 type:UIKeyboardTypeDefault isSecure:YES];
    } else if(self.actionType==UserRegister){
        [self addSingleLabel:@"密码" frame:CGRectMake(10,90,80,25)];
        [self addTextField:@"" frame:CGRectMake(100,90,200,30) tag:Pwd type:UIKeyboardTypeDefault isSecure:YES];
        [self addSingleLabel:@"确认密码" frame:CGRectMake(10,130,80,25)];
        [self addTextField:@"" frame:CGRectMake(100,130,200,30) tag:Pwd2 type:UIKeyboardTypeDefault isSecure:YES];
    } else if(self.actionType==UserFindPwd){
        [self addSingleLabel:@"新密码" frame:CGRectMake(10,90,80,25)];
        [self addTextField:@"" frame:CGRectMake(100,90,200,30) tag:Pwd type:UIKeyboardTypeDefault isSecure:YES];
    }
    
    if (self.actionType!=UserResetPwd) {
        UIButton *getCheckCodeBt=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [getCheckCodeBt setTitle:@"获取验证码" forState:UIControlStateNormal];
        [getCheckCodeBt setFrame:CGRectMake(10,170,80,30)];
        [getCheckCodeBt addTarget:self action:@selector(getCheckCode:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:getCheckCodeBt];
        if (self.actionType==UserRegister) {
            [self addTextField:@"输入验证码" frame:CGRectMake(130,170,110,30) tag:CheckCode type:UIKeyboardTypeDecimalPad isSecure:NO];
        } else if(self.actionType==UserFindPwd){
            [self addTextField:@"输入验证码" frame:CGRectMake(130,170,110,30) tag:CheckCode-1 type:UIKeyboardTypeDecimalPad isSecure:NO];
        }
    }
    
    UIButton *regBt=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [regBt setBackgroundColor:[UIColor orangeColor]];
    [regBt setFrame:CGRectMake(10,220,SCREEN_WIDTH-30,30)];
    if (self.actionType==UserResetPwd) {
        [regBt setTitle:@"重置密码" forState:UIControlStateNormal];
        [regBt addTarget:self action:@selector(resetPwd:) forControlEvents:UIControlEventTouchUpInside];
    } else if(self.actionType==UserRegister){
        [regBt setTitle:@"注册" forState:UIControlStateNormal];
        [regBt addTarget:self action:@selector(userReg:) forControlEvents:UIControlEventTouchUpInside];
    } else if(self.actionType==UserFindPwd){
        [regBt setTitle:@"找回密码" forState:UIControlStateNormal];
        [regBt addTarget:self action:@selector(findPwd:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:regBt];

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

-(void)findPwd:(UIButton *)bt{
    
    NSString *phoneNum=[(UITextField *)[self.view viewWithTag:PhoneNum] text];
    NSString *passWord=[(UITextField *)[self.view viewWithTag:Pwd] text];
    NSString *code=[(UITextField *)[self.view viewWithTag:(CheckCode-1)] text];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:phoneNum,@"mobile",code,@"code",[Utiles md5:passWord],@"newpass", nil];
    [Utiles postNetInfoWithPath:@"UserFindPwd" andParams:params besidesBlock:^(id obj) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [Utiles showToastView:self.view withTitle:nil andContent:[obj objectForKey:@"msg"] duration:2.0];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络错误" duration:1.0];
    }];
}

-(void)resetPwd:(UIButton *)bt{

    NSString *userName=[(UITextField *)[self.view viewWithTag:PhoneNum] text];
    NSString *oldPwd=[(UITextField *)[self.view viewWithTag:Pwd] text];
    NSString *newPwd=[(UITextField *)[self.view viewWithTag:Pwd2] text];
    
    if (![oldPwd isEqualToString:newPwd]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:userName,@"username",[Utiles md5:oldPwd],@"oldpass",[Utiles md5:newPwd],@"newpass", nil];
        [Utiles postNetInfoWithPath:@"UserResetPwd" andParams:params besidesBlock:^(id obj) {

            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [Utiles showToastView:self.view withTitle:nil andContent:[obj objectForKey:@"msg"] duration:2.0];
            if([[obj objectForKey:@"status"] integerValue]==1){
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Utiles showToastView:self.view withTitle:nil andContent:@"网络错误" duration:1.0];
        }];
    } else {
        [Utiles showToastView:self.view withTitle:nil andContent:@"修改前后密码相同" duration:1.5];
    }
    
}

-(void)userReg:(UIButton *)bt{

    NSString *phoneNum=[(UITextField *)[self.view viewWithTag:PhoneNum] text];
    NSString *passWord=[(UITextField *)[self.view viewWithTag:Pwd] text];
    NSString *checkPwd=[(UITextField *)[self.view viewWithTag:Pwd2] text];
    NSString *code=[(UITextField *)[self.view viewWithTag:CheckCode] text];
    
    if ([passWord isEqualToString:checkPwd]) {
        [MBProgressHUD showHUDAddedTo:self.view withTitle:@"" animated:YES];
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:phoneNum,@"mobile",code,@"code",[Utiles md5:passWord],@"password", nil];
        
        [Utiles postNetInfoWithPath:@"UserRegister" andParams:params besidesBlock:^(id obj) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if([[obj objectForKey:@"status"] integerValue]!=1){
                [Utiles showToastView:self.view withTitle:nil andContent:[obj objectForKey:@"msg"] duration:2.0];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Utiles showToastView:self.view withTitle:nil andContent:@"网络错误" duration:1.0];
        }];
    } else {
        [Utiles showToastView:self.view withTitle:nil andContent:@"密码输入不匹配" duration:1.5];
    }
    
    
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

-(void)addTextField:(NSString *)title frame:(CGRect)rect tag:(NSInteger)tag type:(UIKeyboardType)type isSecure:(BOOL)isPwd{
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
    }else if(tag== Pwd2){
        //[textField setEnablePrevious:YES next:NO];
    }
    textField.keyboardType=type;
    textField.secureTextEntry = isPwd;
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
