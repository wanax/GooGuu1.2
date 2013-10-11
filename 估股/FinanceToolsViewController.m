//
//  FinanceToolsViewController.m
//  UIDemo
//
//  Created by Xcode on 13-6-18.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "FinanceToolsViewController.h"
#import "LoginView.h"
#import "ClientLoginViewController.h"
#import "CounterViewController.h"

@interface FinanceToolsViewController ()

@end

@implementation FinanceToolsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
}

-(void)initComponents{
    
    self.title=@"金融工具";
    self.customTabel=[[UITableView alloc] initWithFrame:CGRectMake(0,0,320,520) style:UITableViewStyleGrouped];
    
    self.customTabel.dataSource=self;
    self.customTabel.delegate=self;
    [self.view addSubview:self.customTabel];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self initComponents];
}

#pragma mark -
#pragma Table DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 10;
    }else return 5;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) {
        return 15;
    }else return 15;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int row=0;
    if (section==0) {
        row=4;
    } else if(section==1){
        row=3;
    }else if(section==2){
        row=3;
    }else if(section==3){
        row=1;
    }
    return row;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *label = [[[UILabel alloc] init] autorelease];
    
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont fontWithName:@"Heiti SC" size:16.0f];
    
    UIView *view = nil;
    if (section==0) {
        view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    } else {
        view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 25)];
    }
    [view autorelease];
    [view addSubview:label];
    
    return view;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier=@"Cell";
    
    UITableViewCell *cell=[self.customTabel dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.font=[UIFont fontWithName:@"Heiti SC" size:14.0];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    void (^setCell) (NSString *,NSString *)=^(NSString *name,NSString *img){
        [cell.textLabel setText:name];
        UIImage *image = [UIImage imageNamed:img];
        cell.imageView.image = image;
    };
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            setCell(@"贝塔系数",@"BETA");
        } else if(indexPath.row==1){
            setCell(@"折现率",@"WACC");
        }else if(indexPath.row==2){
            setCell(@"现金流折现",@"CASHCOUNT");
        }else if(indexPath.row==3){
            setCell(@"自由现金流",@"FREECRASH");
        }
    } else if(indexPath.section==1) {
        if (indexPath.row==0) {
            setCell(@"初创公司估值",@"COMVALU");
        } else if(indexPath.row==1){
            setCell(@"PE投资回报",@"PE");
        }else if(indexPath.row==2){
            setCell(@"资金的时间价值",@"FUNDTIME");
        }
    }else if(indexPath.section==2) {
        if (indexPath.row==0) {
            setCell(@"投资收益",@"INVESTCOM");
        } else if(indexPath.row==1){
            setCell(@"A股交易手续费",@"ASTOCK");
        }else if(indexPath.row==2){
            setCell(@"港股交易手续费",@"HSTOCK");
        }
    }else if(indexPath.section==3) {
        if (indexPath.row==0) {
            setCell(@"Excel快捷键(2007)",@"EXCEL");
        }
    }
    
    
    return cell;
}


#pragma mark -
#pragma Table Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    void (^combinePush) (NSString *,NSString *,NSString *,NSString *)=^(NSString *pName,NSString *pUnit,NSString *rName,NSString *rUnit){
        
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:pName,@"pName",pUnit,@"pUnit",rName,@"rName",rUnit,@"rUnit", nil];
        CounterViewController *counter=[[[CounterViewController alloc] init] autorelease];
        counter.params=params;
        counter.title=[[[tableView  cellForRowAtIndexPath:indexPath] textLabel] text];
        counter.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:counter animated:YES];
        [self.customTabel deselectRowAtIndexPath:indexPath animated:YES];
        
    };
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            combinePush(@"贝塔系数,债务占比,有效税率",@"0,%,%",@"股权占比,有效税率,无杠杆贝塔系数",@"%,%,1");
        } else if(indexPath.row==1){
            combinePush(@"贝塔系数,无风险利率,市场溢价,小市值股票溢价,国家溢价,有效税率,负债成本,债务占比",@"0,%,%,%,%,%,%,%",@"权益成本,股权占比,资本成本(WACC)",@"%,%,%");
        }else if(indexPath.row==2){
            combinePush(@"企业无杠杆自由现金流,折现率,永续增长率,贷款金额,现金及现金等价物余额,发行股票数量",@"万元,%,%,万元,万元,万元",@"企业价值,每股价值",@"万元,元");
        }else if(indexPath.row==3){
            combinePush(@"企业息税前利润(EBIT),有效税率,净运营资本增加/减少,折扣和摊销,资本开支",@"万元,%,万元,万元,万元",@"企业自由现金流",@"万元");
        }
    } else if(indexPath.section==1) {
        if (indexPath.row==0) {
            combinePush(@"A轮融资金额,B轮融资金额,C轮融资金额,A轮融资投前估值,B轮融资投前估值,C轮融资投前估值",@"万元,万元,万元,万元,万元,万元",@"企业累计被稀释股份比例",@"%");
        } else if(indexPath.row==1){
            combinePush(@"投资金额,投后占公司股份比例,投资年份,被投公司当年利润,被投公司预计上市年份,被投公司上市前一年利润,投资支付佣金等其他费用,上市后预计是盈率",@"万元,%,年,万元,年,万元,万元,倍",@"公司投前估值,公司投前市盈率,公司投后股价,投资退出金额,投资盈利计算,投资回报倍数,内部收益率(IRR)",@"万元,倍,万元,万元,万元,倍,%");
        }else if(indexPath.row==2){
            combinePush(@"资金的现值,预计年收益率,时间长度,每年计息次数",@"元,%,年,次",@"资金未来价值",@"元");
        }
    }else if(indexPath.section==2) {
        if (indexPath.row==0) {
            combinePush(@"投资金额,投入时间,期末价值",@"元,天,元",@"年化收益率,期间收益率",@"%,%");
        } else if(indexPath.row==1){
            combinePush(@"股票买入价,股票买入数量,股票卖出价,股票卖出数量,劵商佣金比率,印花税税率,过户费税率",@"元/股,股,元/股,股,%,%,元/千股",@"过户费,印花税,券商佣金,交易手续费,总体投资损益,盈亏率",@"元,元,元,元,元,%");
        }else if(indexPath.row==2){
            combinePush(@"",@"",@"",@"");
        }
    }else if(indexPath.section==3) {
        if (indexPath.row==0) {
            combinePush(@"",@"",@"",@"");
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)shouldAutorotate{
    return NO;
}




















@end