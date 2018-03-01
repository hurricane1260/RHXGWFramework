//
//  BuyAndSellView.h
//  stockscontest
//
//  Created by rxhui on 15/6/9.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <UIKit/UIKit.h>




@protocol TradeViewBuyAndSellDelegate <NSObject>

@optional

///查询股票价格
-(void)requestStockPriceWithStockCode:(NSString *)stockCode andExchangeType:(NSString *)exchangeType;

//查询大约可买数量
-(void)requestStockCountWithParam:(id)param;

///查询股票的exchangeType
-(void)requestStockExchangeTypeWithStockCode:(NSString *)stockCode;

///查询股票上下限价格
//-(void)requestStockLimitPriceWithParam:(NSDictionary *)param;

///查询股东账号
-(void)requestShareHolderAccount;

///发购买请求
- (void)sendEntrustRequestWithParam:(NSDictionary *)param;
@end


@interface BuyAndSellView : UIScrollView

/**
 *  买入/卖出
 */
@property (nonatomic,assign) TradeBuySellViewType viewType;

/**
 *  模拟/实盘
 */
@property (nonatomic,assign) TradeControllerType controllerType;

@property (nonatomic,copy) NSString *stockCode;

@property (nonatomic,copy) NSString *stockName;

@property (nonatomic,copy) NSString *stockExchangeType;

@property (nonatomic,copy) NSString *enableBalance;

@property (nonatomic,weak) id <TradeViewBuyAndSellDelegate> stockDelegate;

@property (nonatomic,strong) id priceDic;//传入价格上下限数据

@property (nonatomic,strong) id countDic;//传入数量

@property (nonatomic,strong) NSArray *stockList;

@property (nonatomic,strong) NSArray *holdStockList;

@property (nonatomic,strong) id priceData;//行情

@property (nonatomic,copy) NSString *stockHolderAccount;

///键盘会挡住textfield
@property (nonatomic,readonly) BOOL needToUp;

@property (nonatomic, assign) BOOL isSecondTrade;

@property (nonatomic,assign) BOOL hasChangedPrice;//在textFiled里修改过price



-(void)hideKeyboards;

-(void)clearForm;
@end
