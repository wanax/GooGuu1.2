//
//  EnumSummary.h
//  googuu
//
//  Created by Xcode on 13-8-15.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnumSummary : NSObject

typedef enum{
    
    BateFactor=0,//bate系数
    Discountrate=1,//折现率
    DiscountCashFlow=2,//现金流折现
    FreeCashFlow=3,//自由现金流
    StartUpComValue=4,//初创公司估值
    InvestBeforeValu=41,//投前估值
    InvestAfterValu=42,//投后估值
    MultRoundsOfFinance=43,//多轮融资计算
    PEReturnOnInvest=5,//PE投资回报
    FundsTimeValue=6,//资金的时间价值
    InvestIncome=7,//投资收益
    AStockTransFees=8,//A股交易手续费
    HKStockTransFees=9,//港股交易手续费
    ExcelShortcuts=10//Excel快捷键
    
    
} FinancalToolsType;

//评论类型，此页面三种评论公用
typedef enum {
    
    CompanyType,//关于股票公司的评论
    NewsType,//估股新闻中分析报告的评论
    ArticleType//股票公司中分析报告的评论
    
} CommentType;

//浏览来源，当从保存列表进入时加载保存数据 ChartViewController
typedef enum {
    ValuationModelType,
    MyConcernedType,
    MySavedType,
    ModelViewType,
    ChartViewType,
    DragableChart,
    FinancalModelChart,
    ChartSaved,
    DiscountSaved,
    SearchStockList
} BrowseSourceType;

typedef enum {
    NewsBar=0,
    ValuationModelBar=1,
    MyGooGuuBar=2,
    SettingBar=3
} TabBarType;

//股票市场 CompanyListViewController
typedef enum {
    HK=1,//港股
    NYSE=2,//纽交所
    SZSE=4,//深圳
    SHSE=8,//上海
    SHSZSE=12,//沪深
    NASDAQ=16,//纳斯达克
    NANY=18,//美股
    ALL=31    
} MarketType;

//拖动图表按钮动作定义
typedef enum{
    SaveData=1,
    DragChartType=2,
    ResetChart=3,
    BackToSuperView=4
} ChartBtAction;

typedef enum{
    MainIncome=11,
    OperaFee=22,
    OperaCap=33,
    DiscountRate=44
} IndustoryModelType;

typedef enum{
    FinancialRatio=1,
    FinancialChart=2,
    FinancialOther=3,
    FinancialBack=4
}FinancialProportion;

typedef enum{
    AttentionAction=11,
    AddComment=22,
    AddShare=33
}ValuationModelAction;

typedef enum{
    OneMonth=1,
    ThreeMonth=2,
    SixMonth=3,
    OneYear=4
}DahonTimeInterval;

typedef enum {
    
    FinancalModel,//金融模型
    DragabelModel,//可调整参数模型
    DahonModel//大行数据
    
} ChartType;






@end
