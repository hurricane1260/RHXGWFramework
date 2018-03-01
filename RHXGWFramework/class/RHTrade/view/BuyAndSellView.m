//
//  BuyAndSellView.m
//  stockscontest
//
//  Created by rxhui on 15/6/9.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "BuyAndSellView.h"
#import "BuyAndSellTitleView.h"
#import "CMStepper.h"
#import "ButtonPickerView.h"
#import "BuyViewStockListCell.h"
#import "BuyAndSellPriceListCell.h"
#import "UITextField+ExtentRange.h"
#import "UITextField+CustomKeyBoard.h"
#import "TradeListHeadView.h"
#import "TradeStockTableViewCell.h"
#import "TradeNoneDataView.h"
#import "TradeStockPriceVO.h"
#import "SKFiveReportVO.h"
#import "BuyAndSellPriceVO.h"
#import "StockListVO.h"
#import "StockVO.h"
#import "SKCodeTable.h"
#define kHintTimeInterval 3.0f

@interface BuyAndSellView ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, CMStepperDelegate, CMAlertDelegate, ButtonPickerDelegate,CustomKeyBoardDelegate>

/*! @brief 内容－买入的股票代码/简称输入框*/
@property (nonatomic,strong) UITextField *stockNameValueView;

@property (nonatomic,strong) UIView *stockNameBackView;

/*! @brief 内容－买入的输入框按键精灵 */
@property (nonatomic,strong) UITableView *stockListView;

/*! @brief 委托买入/市价买入的按钮 */
@property (nonatomic,strong) ButtonPickerView *buyButtons;

/*! @brief 价格的步进器 */
@property (nonatomic,strong) CMStepper *priceStepper;

@property (nonatomic,strong) UILabel *priceLabel;

/*! @brief 跌停价 */
@property (nonatomic,strong) UILabel *minPriceLabel;

/*! @brief 涨停价 */
@property (nonatomic,strong) UILabel *maxPriceLabel;

/*! @brief 5买列表 */
@property (nonatomic,strong) UITableView *buyPriceListView;

/*! @brief 分割线 */
@property (nonatomic,strong) UILabel *buySeperatorView;

/*! @brief 5卖列表 */
@property (nonatomic,strong) UITableView *sellPriceListView;

/*! @brief 数量的步进器 */
@property (nonatomic,strong) CMStepper *countStepper;

/*! @brief 最大可买/卖标签 */
@property (nonatomic,strong) UILabel *maxBuyCount;

/*! @brief 确认购买按钮 */
@property (nonatomic,strong) UIButton *buyConfirmButton;

/*! @brief 买入查找股票时的遮罩层 */
//@property (nonatomic,strong) UIButton *maskView;

/*! @brief 持股头 */
@property (nonatomic,strong) TradeListHeadView *headView;

/*! @brief 持股列表 */
@property (nonatomic,strong) UITableView *stockHolderView;

/*! @brief 持股无数据*/
@property (nonatomic,strong) TradeNoneDataView *noHoldStockView;

/*! @brief 记录查询的字符串，修改string的颜色 */
@property (nonatomic,copy) NSString *queryString;

/*! @brief 买5列表的dataSource */
@property (nonatomic,strong) NSArray *buyPriceList;

/*! @brief 卖5列表的dataSource */
@property (nonatomic,strong) NSArray *sellPriceList;

//@property (nonatomic,strong) NSArray *stockHolderArray;//持仓列表

/*! @brief 类型，股票or基金*/
@property (nonatomic,copy) NSString *stockType;

/*! @brief 1是股票，0是基金*/
@property (nonatomic,assign) BOOL isStock;

@property (nonatomic,strong) NSArray * numArr;
@property (nonatomic,strong) NSArray * engArr;
@property (nonatomic,strong) NSArray * stockArr;
@property (nonatomic,strong) UIView * numberBoard;
@property (nonatomic,strong) UIView * englishBoard;
@property (nonatomic,strong) UIButton * button;
@property (nonatomic,strong) NSMutableArray * selectArr;
@property (nonatomic,assign) BOOL hasChangedCount;//在textFiled里修改过count
@property (nonatomic,strong) NSArray * tempTitleArray;
/**跌停价*/
@property (nonatomic,copy) NSString * downPrice;
@property (nonatomic,copy) NSString * upPrice;
@property (nonatomic,assign) NSInteger   MaxBuyCountValue;


@end

@implementation BuyAndSellView

#pragma mark =============================================初始化&布局=======================================================


static NSString *stockCellIdentifier = @"stockCellIdentifier";

static NSString *buyPriceCellIdentifier = @"buyPriceCellIdentifier";

static NSString *sellPriceCellIdentifier = @"sellPriceCellIdentifier";

static NSString *stockHolderCellIdentifier = @"stockHolderCellIdentifier";

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.showsHorizontalScrollIndicator = NO;
        _isStock = YES;
        [self initSubviews];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeText:) name:UITextFieldTextDidChangeNotification object:nil];
        self.hasChangedPrice = NO;
        self.hasChangedCount = NO;
//        self.needRefreshPrice = YES;
    }
    return self;
}

-(void)initSubviews {
//    self.titleBackView = [[BuyAndSellTitleView alloc]init];
//    [self addSubview:self.titleBackView];
    
    __weak typeof(self) welf = self;

    
    self.stockNameBackView = [[UIView alloc]init];
    [self addSubview:self.stockNameBackView];
    self.stockNameBackView.layer.borderWidth = 1.0f;
    self.stockNameBackView.layer.masksToBounds = YES;
    self.stockNameBackView.backgroundColor = [UIColor whiteColor];
    
    self.stockNameValueView = [[UITextField alloc]init];
    [self.stockNameBackView addSubview:self.stockNameValueView];
    self.stockNameValueView.delegate = self;
    self.stockNameValueView.font = font3_number_xgw;
    self.stockNameValueView.textColor = color2_text_xgw;
    self.stockNameValueView.backgroundColor = [UIColor whiteColor];
    self.stockNameValueView.placeholder = @"股票代码/名称";
    self.stockNameValueView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.stockNameValueView.autocorrectionType = UITextAutocorrectionTypeNo;
    self.stockNameValueView.spellCheckingType = UITextSpellCheckingTypeNo;
    //    self.stockNameValueView.keyboardType = UIKeyboardTypeASCIICapable;
//    [self.stockNameValueView createCustomKeyBoard];
//    self.stockNameValueView.keyBoardDelegate = self;
    
    self.stockListView = [[UITableView alloc]init];
    self.stockListView.delegate = self;
    self.stockListView.dataSource = self;
    self.stockListView.backgroundColor = [UIColor whiteColor];
    self.stockListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSArray *titleList = @[@"限价委托", @"市价委托"];
    self.tempTitleArray = titleList;
    NSArray * holdingList = @[@"全仓",@"半仓",@"1/3仓",@"1/4仓"];
    self.buyButtons = [[ButtonPickerView alloc]initWithTitleList:titleList];
    self.buyButtons.firstTitle = @"限价委托";
    self.buyButtons.clipsToBounds = NO;
    self.buyButtons.delegate = self;
    self.buyButtons.pickerBlock = ^(ButtonPickerType type) {
        if (type == HoldingType) {
          
            welf.buyButtons.holdingList = holdingList;
            
        }else if(type == marketPriceType){
            welf.buyButtons.titleList = welf.tempTitleArray;
        }
    };
    
   
    
    self.priceStepper = [[CMStepper alloc]init];
    [self addSubview:self.priceStepper];
    self.priceStepper.step = [NSDecimalNumber decimalNumberWithString:@"0.01"];
    self.priceStepper.delegate = self;
    
    self.priceLabel = [UILabel didBuildLabelWithText:@"" font:font3_number_xgw textColor:color2_text_xgw wordWrap:NO];
    [self addSubview:self.priceLabel];
    self.priceLabel.hidden = YES;
    self.priceLabel.layer.borderWidth = 1.0f;
    self.priceLabel.layer.masksToBounds = YES;
    self.priceLabel.backgroundColor = [UIColor whiteColor];
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    self.priceLabel.font = font3_number_xgw;
    

    self.minPriceLabel = [UILabel didBuildLabelWithText:@"" font:font1_number_xgw textColor:color2_text_xgw wordWrap:NO];
    self.minPriceLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * minPriceTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(minPriceClick)];
    [self.minPriceLabel addGestureRecognizer:minPriceTap];
    [self addSubview:self.minPriceLabel];
    self.minPriceLabel.font = font1_number_xgw;
    

    self.maxPriceLabel = [UILabel didBuildLabelWithText:@"" font:font1_number_xgw textColor:color2_text_xgw wordWrap:NO];
    self.maxPriceLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer * maxPriceTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maxPriceClick)];
    [self.maxPriceLabel addGestureRecognizer:maxPriceTap];

    [self addSubview:self.maxPriceLabel];
    self.maxPriceLabel.font = font1_number_xgw;
    
    
    self.buyPriceListView = [[UITableView alloc]init];
    [self addSubview: self.buyPriceListView];
    self.buyPriceListView.delegate = self;
    self.buyPriceListView.dataSource = self;
    self.buyPriceListView.backgroundColor = [UIColor whiteColor];
    self.buyPriceListView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.buyPriceListView.estimatedRowHeight = 27.0f;
    self.buyPriceListView.scrollEnabled = NO;
    
//    self.buySeperatorView = [UILabel didBuildLabelWithText:@"…………………………………………" fontSize:12.0f textColor:color16_other_xgw wordWrap:NO];
    self.buySeperatorView = [UILabel didBuildLabelWithText:@"…………………………………………" font:font1_common_xgw textColor:color16_other_xgw wordWrap:NO];
    [self addSubview:self.buySeperatorView];
    
    self.sellPriceListView = [[UITableView alloc]init];
    [self addSubview: self.sellPriceListView];
    self.sellPriceListView.delegate = self;
    self.sellPriceListView.dataSource = self;
    self.sellPriceListView.backgroundColor = [UIColor whiteColor];
    self.sellPriceListView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.sellPriceListView.estimatedRowHeight = 27.0f;
    self.sellPriceListView.scrollEnabled = NO;
    
    self.countStepper = [[CMStepper alloc]init];
    [self addSubview:self.countStepper];
    self.countStepper.isInteger = YES;
    self.countStepper.step = [NSDecimalNumber decimalNumberWithString:@"100"];
    self.countStepper.delegate = self;
    
    self.maxBuyCount = [[UILabel alloc]init];
    [self addSubview:self.maxBuyCount];
    self.maxBuyCount.font = font1_number_xgw;
    self.maxBuyCount.textColor = color2_text_xgw;
    
    self.buyConfirmButton = [[UIButton alloc]init];
    [self.buyConfirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [self.buyConfirmButton setTitle:@"确认" forState:UIControlStateHighlighted];
    [self.buyConfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buyConfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [self.buyConfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    self.buyConfirmButton.titleLabel.font = font4_common_xgw;
    [self addSubview:self.buyConfirmButton];
    [self.buyConfirmButton addTarget:self action:@selector(buyButtonTouchHandler) forControlEvents:UIControlEventTouchUpInside];
    
    self.headView = [[TradeListHeadView alloc]init];
    [self addSubview:self.headView];
    
    self.stockHolderView = [[UITableView alloc]init];
    [self addSubview:self.stockHolderView];
    self.stockHolderView.delegate = self;
    self.stockHolderView.dataSource = self;
    self.stockHolderView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.stockHolderView.backgroundColor = [UIColor whiteColor];
    [self.stockHolderView registerClass:[TradeStockTableViewCell class] forCellReuseIdentifier:stockHolderCellIdentifier];
    
    self.noHoldStockView = [[TradeNoneDataView alloc]init];
    self.noHoldStockView.titleLabel.text = @"暂无持仓";
    [self.stockHolderView addSubview:self.noHoldStockView];
    self.noHoldStockView.hidden = YES;
    
    [self addSubview:self.buyButtons];
    
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat layoutX = 10.0f;
    CGFloat layoutY = 10.0f;
    
    CGFloat leftWidth = self.width * 0.55;
    
    self.stockNameBackView.size = CGSizeMake(leftWidth, 40.0f);
    self.stockNameBackView.x = layoutX;
    self.stockNameBackView.y = layoutY;
    
    self.stockNameValueView.width = leftWidth - 21.0f;
    self.stockNameValueView.height = 38.0f;
    self.stockNameValueView.x = 20.0f;
    self.stockNameValueView.y = 1.0f;
    
    layoutY = self.stockNameBackView.y + self.stockNameBackView.height;
    self.stockListView.x = layoutX;
    self.stockListView.y = layoutY;
    self.stockListView.width = self.stockNameBackView.width;
    
    layoutY += 10.0f;
    self.priceStepper.x = layoutX;
    self.priceStepper.y = layoutY;
    self.priceStepper.size = CGSizeMake(leftWidth, 40.0f);
    self.priceLabel.frame = self.priceStepper.frame;
    
    layoutY = self.priceStepper.y + self.priceStepper.height + 5.0f;
    self.minPriceLabel.y = layoutY;
    [self.minPriceLabel sizeToFit];
    self.minPriceLabel.x = self.priceStepper.x;
    
    self.maxPriceLabel.y = layoutY;
    [self.maxPriceLabel sizeToFit];
    self.maxPriceLabel.x = self.priceStepper.width + self.priceStepper.x - self.maxPriceLabel.width;
    
    layoutY += 24.0f;
    self.countStepper.x = layoutX;
    self.countStepper.y = layoutY;
    self.countStepper.size = self.priceStepper.size;
    
    layoutY = self.countStepper.y + self.countStepper.height + 5.0f;
    if (self.controllerType == TradeControllerTypeSimulate) {
        self.maxBuyCount.width = leftWidth;
        self.maxBuyCount.height = 24.0f;
    }
    else {
        [self.maxBuyCount sizeToFit];
    }
    self.maxBuyCount.x = self.countStepper.x;
    self.maxBuyCount.y = layoutY;
    
    self.buyButtons.y = layoutY;
    self.buyButtons.size = CGSizeMake(leftWidth, 40.0f * 6 + 20);
    self.buyButtons.x = layoutX;
    
   
    
    layoutY += 24.0f;
    self.buyConfirmButton.size = self.stockNameBackView.size;
    self.buyConfirmButton.y = layoutY;
    self.buyConfirmButton.x = layoutX;
    
    //买卖行情
    layoutY = 5.0f;
    layoutX = self.stockNameBackView.x + self.stockNameBackView.width + 15.0f;
    self.sellPriceListView.x = layoutX;
    self.sellPriceListView.y = layoutY;
    self.sellPriceListView.size = CGSizeMake(self.width - layoutX - 10.0f, 22.0f * 5);
    layoutY = self.sellPriceListView.y + self.sellPriceListView.height;
    
    [self.buySeperatorView sizeToFit];
    self.buySeperatorView.x = layoutX;
    self.buySeperatorView.y = layoutY;
    layoutY += 20.0f;
    
    self.buyPriceListView.x = layoutX;
    self.buyPriceListView.y = layoutY;
    self.buyPriceListView.size = self.sellPriceListView.size;
    
    layoutY = self.buyConfirmButton.y + self.buyConfirmButton.height + 10.0f;
    self.headView.size = CGSizeMake(self.width, 27.0f);
    self.headView.x = 0.0f;
    self.headView.y = layoutY;
    
    layoutY += self.headView.height;
    
    self.stockHolderView.y = layoutY;
    self.stockHolderView.x = 0.0f;
    if (_isSecondTrade) {
        self.stockHolderView.size = CGSizeMake(self.width, self.height - self.stockHolderView.y);
    }
    else {
        self.stockHolderView.size = CGSizeMake(self.width, self.height - self.stockHolderView.y - TabBarHeight);
    }
    
    self.noHoldStockView.width = self.width;
    self.noHoldStockView.height = self.stockHolderView.height;
}

#pragma mark =============================================确认买入卖出=======================================================

//检查参数，请求股东账户
-(void)buyButtonTouchHandler {
    [self hideKeyboards];
    
    if (![self.stockDelegate respondsToSelector:@selector(requestShareHolderAccount)]) {
        return;
    }
    if (![self checkEntrustParam]) {
        return;
    }
    if (self.controllerType == TradeControllerTypeReal) {
        NSString *titleString = nil;
        if (self.viewType == TradeBuySellViewTypeBuy) {
            titleString = @"买入委托";
        }
        else {
            titleString = @"卖出委托";
        }
        
        NSString *priceString = nil;
        
        
        
        if ([self.buyButtons.firstTitle isEqualToString:@"限价委托"]) {
            priceString = self.priceStepper.currentValue.stringValue;
        }
        else if ([self.buyButtons.leftTitle isEqualToString:@"全仓"]||[self.buyButtons.leftTitle isEqualToString:@"半仓"]||[self.buyButtons.leftTitle isEqualToString:@"1/3仓"]||[self.buyButtons.leftTitle isEqualToString:@"1/4仓"]){
            priceString = self.priceStepper.currentValue.stringValue;

        }
        else {
            priceString = self.buyButtons.firstTitle;
        }
        
        NSString *showMessage = [NSString stringWithFormat:@"  证券代码：%@\n  股票名称：%@\n  委托价格：%@\n  委托数量：%@\n",_stockCode,_stockName,priceString,self.countStepper.currentValue];
        
        [CMAlert show:titleString message:showMessage superView:nil buttonTitleList:@[@"取消",@"确认"] andDelegate:self];
    }
    else {
        NSString *titleString = nil;
        if (self.viewType == TradeBuySellViewTypeBuy) {
            titleString = @"买入委托";
        }
        else {
            titleString = @"卖出委托";
        }
        
        NSString *priceString = [NSString stringWithFormat:@"%@",self.priceStepper.currentValue];
        NSString *showMessage = [NSString stringWithFormat:@"  证券代码：%@\n  股票名称：%@\n  委托价格：%@\n  委托数量：%@\n",_stockCode,_stockName,priceString,self.countStepper.currentValue];
        [CMAlert show:titleString message:showMessage superView:nil buttonTitleList:@[@"取消",@"确认"] andDelegate:self];
    }
   
   
}

- (BOOL)checkEntrustParam {
    if (!self.stockCode || self.stockCode.length == 0) {
        [CMProgress showWarningProgressWithTitle:nil message:@"请输入简称或代码" warningImage:nil duration:kHintTimeInterval];
        return NO;
    }
    if (!self.stockName || self.stockName.length == 0) {
        [CMProgress showWarningProgressWithTitle:nil message:@"请输入简称或代码" warningImage:nil duration:kHintTimeInterval];
        return NO;
    }
    if ([self.buyButtons.firstTitle isEqualToString:@"限价委托"] || self.controllerType == TradeControllerTypeSimulate) {
        if([self.priceStepper.currentValue compare: self.priceStepper.maxValue] == NSOrderedDescending) {
            [CMProgress showWarningProgressWithTitle:nil message:@"超出涨停价格！" warningImage:nil duration:kHintTimeInterval];
            return NO;
        }
        else if ([self.priceStepper.currentValue compare:self.priceStepper.minValue] == NSOrderedAscending) {
            [CMProgress showWarningProgressWithTitle:nil message:@"超出跌停价格！" warningImage:nil duration:kHintTimeInterval];
            return NO;
        }
    }

    if ([self.countStepper.currentValue compare:[NSDecimalNumber decimalNumberWithString:@"0"]] == NSOrderedSame) {
        [CMProgress showWarningProgressWithTitle:nil message:@"输入的股数不能为0！" warningImage:nil duration:kHintTimeInterval];
        return NO;
    }
    else if ([self.countStepper.currentValue compare: self.countStepper.maxValue] == NSOrderedDescending) {
        if (self.viewType == TradeBuySellViewTypeBuy) {
            [CMProgress showWarningProgressWithTitle:nil message:@"购买股数超出最大可购买数量！" warningImage:nil duration:kHintTimeInterval];
        }
        else {
            [CMProgress showWarningProgressWithTitle:nil message:@"卖出股数超出最大可卖出数量！" warningImage:nil duration:kHintTimeInterval];
        }
        return NO;
    }
    else {
        if (self.viewType == TradeBuySellViewTypeSell) {
            return YES;
        }
        if ((NSInteger)self.countStepper.currentValue.integerValue % 100 != 0) {
            [CMProgress showWarningProgressWithTitle:nil message:@"买入的股数非100的倍数！" warningImage:nil duration:kHintTimeInterval];
            return NO;
        }
    }
    return YES;
}

- (NSMutableDictionary *)buildBuyOrSellParam {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.stockCode forKey:@"stockCode"];
    [param setValue:self.stockExchangeType forKey:@"exchangeType"];
//    [param setValue:self.stockName forKey:@"stockName"];//有些股票名称带“*”，不可传
    [param setValue:self.countStepper.currentValue forKey:@"entrustAmount"];
    
    if (_viewType == TradeBuySellViewTypeBuy) {
        [param setValue:@"1" forKey:@"entrustBs"];
    }
    else if (_viewType == TradeBuySellViewTypeSell) {
        [param setValue:@"2" forKey:@"entrustBs"];
    }
    
    if ([self.buyButtons.firstTitle hasSuffix:@"委托"]) {
        [param setValue:self.priceStepper.currentValue forKey:@"entrustPrice"];
    }
    else {//市价传0
        [param setValue:@"0" forKey:@"entrustPrice"];
    }
    
    NSString *entrustProp = nil;
    if ([self.buyButtons.firstTitle isEqualToString:@"最优五档即成剩撤"]) {
        entrustProp = @"U";
    }
    else if ([self.buyButtons.firstTitle isEqualToString:@"最优五档即成剩转限"]) {
        entrustProp = @"R";
    }
    else if ([self.buyButtons.firstTitle isEqualToString:@"对手方最优价格"]) {
        entrustProp = @"Q";
    }
    else if ([self.buyButtons.firstTitle isEqualToString:@"本方最优价格"]) {
        entrustProp = @"S";
    }
    else if ([self.buyButtons.firstTitle isEqualToString:@"即时成交剩撤"]) {
        entrustProp = @"T";
    }
    else if ([self.buyButtons.firstTitle isEqualToString:@"全额成交或撤销"]) {
        entrustProp = @"V";
    }
    else if ([self.buyButtons.firstTitle hasSuffix:@"委托"]) {
        entrustProp = @"0";
    }

    [param setValue:entrustProp forKey:@"entrustProp"];
    
    return param;
}

- (NSMutableDictionary *)buildSimulateTradeParam {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.stockCode forKey:@"stockCode"];
    NSDecimalNumber *vol = self.countStepper.currentValue;
    NSDecimalNumber *price = self.priceStepper.currentValue;
    [param setValue:vol forKey:@"vol"];
    [param setValue:price forKey:@"price"];
    NSDecimalNumber *amount = [vol decimalNumberByMultiplyingBy:price];//股票金额
    [param setValue:amount forKey:@"amount"];
    //买卖方向
    if (_viewType == TradeBuySellViewTypeBuy) {
        [param setValue:@"1" forKey:@"businessType"];
    }
    else if (_viewType == TradeBuySellViewTypeSell) {
        [param setValue:@"2" forKey:@"businessType"];
    }
    /*过户费（单位为元）：max(买入总股数或卖出总股数/1000,1)
     券商佣金（单位为元）：max(买入总股数或卖出总股数*买入价格或卖出价格*0.05%,5)
     印花税（单位为元，只卖出方收取）：卖出总股数*卖出价格*0.1%
     */
    
    CGFloat commission = MAX(5.0f, amount.doubleValue * 0.0005);
    CGFloat commissionRate = commission / amount.doubleValue;
    CGFloat fee = MAX(1.0f, amount.doubleValue * 0.001);
    CGFloat feeRate = fee / amount.doubleValue;
    [param setValue:[NSNumber numberWithDouble:commission] forKey:@"commission"];
    [param setValue:[NSNumber numberWithDouble:commissionRate] forKey:@"commissionRate"];
    [param setValue:[NSNumber numberWithDouble:fee] forKey:@"fee"];
    [param setValue:[NSNumber numberWithDouble:feeRate] forKey:@"feeRate"];
    
    if (self.viewType == TradeBuySellViewTypeSell) {
        CGFloat stampDuty = amount.doubleValue * 0.001f;
        CGFloat stampDutyRate = 0.001f;
        [param setValue:[NSNumber numberWithDouble:stampDuty] forKey:@"stampDuty"];
        [param setValue:[NSNumber numberWithDouble:stampDutyRate] forKey:@"stampDutyRate"];
    }
    
    return param;
}

#pragma mark =============================================清理界面=======================================================

//隐藏键盘
-(void)hideKeyboards {
    [self.stockNameValueView resignFirstResponder];
    [self.priceStepper hideKeyboard];
    [self.countStepper hideKeyboard];
    [self.buyButtons hideButtonList];
}

-(void)clearForm {
    self.stockListView.hidden = YES;
    self.stockNameValueView.text = @"";
    self.isStock = YES;
    self.hasChangedPrice = NO;
    self.hasChangedCount = NO;
    self.priceStepper.minValue = [NSDecimalNumber decimalNumberWithString:@"0.00"];
    self.priceStepper.maxValue = [NSDecimalNumber decimalNumberWithString:@"0.00"];
    self.priceStepper.currentValue = [NSDecimalNumber decimalNumberWithString:@"0.00"];
    self.priceLabel.hidden = YES;
    self.buyButtons.titleList = @[@"限价委托", @"市价委托"];
    [self.buyButtons hideButtonList];
    self.minPriceLabel.text = @"跌停";
    self.maxPriceLabel.text = @"涨停";
    if (self.stockNameValueView.text.length == 0) {
        self.maxBuyCount.text = (self.viewType == TradeBuySellViewTypeBuy) ? @"可买0股" : @"可卖0股";
        self.buyButtons.leftTitle = self.maxBuyCount.text;
    }
    self.MaxBuyCountValue =0;

    self.buyPriceList = @[];
    [self.buyPriceListView reloadData];
    self.sellPriceList = @[];
    [self.sellPriceListView reloadData];
    self.countStepper.minValue = [NSDecimalNumber decimalNumberWithString:@"0"];
    self.countStepper.maxValue = [NSDecimalNumber decimalNumberWithString:@"0"];
    self.countStepper.currentValue = [NSDecimalNumber decimalNumberWithString:@"0"];
}

#pragma mark 根据颜色创建图片--------------------------------------------------

- (UIImage *)createImageWithColor:(UIColor *)color rect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return theImage;
}

#pragma mark 获得输入框字符串发送请求--------------------------------------------------

- (void)getKeyBoardString:(NSString *)string
{
    if (![string isEqualToString:@""]) {
        self.queryString = string;
        if (self.controllerType == TradeControllerTypeReal) {
            self.stockList = [[SKCodeTable instance] getCodeItemListByKeyword:string type:tradeData];
        } else {
            self.stockList = [[SKCodeTable instance] getCodeItemListByKeyword:string type:adviserData];
        }
        
        [self.stockListView reloadData];
    }
    if ([string isEqualToString:@""]) {
        self.stockList = nil;
        [self.stockListView reloadData];
    }
}

#pragma mark =============================================setter & getter=======================================================

-(void)setStockExchangeType:(NSString *)aType {
    if (_stockExchangeType) {
        _stockExchangeType = nil;
    }
    _stockExchangeType = aType;
    if (!self.stockDelegate || ![self.stockDelegate respondsToSelector:@selector(requestStockPriceWithStockCode:andExchangeType:)]) {
        return;
    }
    [self.stockDelegate requestStockPriceWithStockCode:_stockCode andExchangeType:_stockExchangeType];
    [self.priceStepper resetStepper];
    [self.countStepper resetStepper];
    
    if (self.controllerType == TradeControllerTypeSimulate) {
        return;//模拟盘略过
    }
    NSArray *shaEntrustList = @[@"限价委托", @"最优五档即成剩撤",@"最优五档即成剩转限"];
    NSArray *szaEntrustList = @[@"限价委托", @"对手方最优价格",@"本方最优价格",@"即时成交剩撤", @"最优五档即成剩撤",@"全额成交或撤销"];
    NSArray *jqEntrustList = @[@"限价委托"];
    
    if (_stockExchangeType.integerValue == 1) {
        self.buyButtons.titleList = shaEntrustList;
        self.tempTitleArray = shaEntrustList;
        self.buyButtons.isHideImage = YES;

        
        
    }
    else if (_stockExchangeType.integerValue == 2) {
        self.buyButtons.titleList = szaEntrustList;
        self.tempTitleArray = szaEntrustList;
        self.buyButtons.isHideImage = YES;

    }
    
    if (_stockCode.length > 2 && ([[_stockCode substringToIndex:3] isEqualToString:@"131"] ||[[_stockCode substringToIndex:3] isEqualToString:@"204"])) {
        self.buyButtons.titleList = jqEntrustList;
        self.buyButtons.isHideImage = NO;
    }
    
    else if ([_stockExchangeType isEqualToString:@"D"]) {
        self.buyButtons.titleList = shaEntrustList;
        self.buyButtons.isHideImage = YES;

    }
    else if ([_stockExchangeType isEqualToString:@"H"]) {
        self.buyButtons.titleList = szaEntrustList;
        self.buyButtons.isHideImage = YES;

    }
    else {
        NSLog(@"---_stockExchangeType错误，不是1,2,D,H");
    }
}

///设置股票代码
-(void)setStockCode:(NSString *)aCode {
    if (_stockCode) {
        _stockCode = nil;
    }
    if (!aCode) {
        [self clearForm];
        return;
    }
    _stockCode = [NSString stringWithFormat:@"%@",aCode];
    self.hasChangedPrice = NO;
    self.hasChangedCount = NO;
    if (!self.stockDelegate || ![self.stockDelegate respondsToSelector:@selector(requestStockExchangeTypeWithStockCode:)]) {
        return;
    }
    [self.stockDelegate requestStockExchangeTypeWithStockCode:_stockCode];
}

//股票名称
@synthesize stockName = _stockName;
-(void)setStockName:(NSString *)aName {
    if (_stockName) {
        _stockName = nil;
    }
    _stockName = aName;
    self.stockNameValueView.text = [NSString stringWithFormat:@"%@ %@",self.stockCode,_stockName];
}

-(NSString *)stockName {
    NSRange range = [self.stockNameValueView.text rangeOfString:@" "];
    if (range.location == NSNotFound) {
        return @"";
    }
    return [self.stockNameValueView.text substringFromIndex:range.location + range.length];
}

//资金
-(void)setEnableBalance:(NSString *)enableBalance
{
    _enableBalance = enableBalance;
    
    if (_stockCode.length > 2 && ([[_stockCode substringToIndex:3] isEqualToString:@"131"])) {
        NSInteger stockCount = self.enableBalance.integerValue / 1000;
        self.maxBuyCount.text = [NSString stringWithFormat:@"可借出%ld元",(long)stockCount * 1000];
        if (!self.hasChangedCount) {
            self.countStepper.currentValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld",(long)stockCount * 1000]];
        }
        self.countStepper.maxValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld",(long)stockCount * 1000]];
    }
    if (_stockCode.length > 2 && ([[_stockCode substringToIndex:3] isEqualToString:@"204"])) {
        NSInteger stockCount = self.enableBalance.integerValue / 1000;
        if (self.enableBalance.integerValue / 1000 > 0) {
            self.maxBuyCount.text = [NSString stringWithFormat:@"可借出%ld元",(long)stockCount * 1000];
            if (!self.hasChangedCount) {
                self.countStepper.currentValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld",(long)stockCount * 1000]];
                
            }
            self.countStepper.maxValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld",(long)stockCount * 1000]];
        } else {
            self.maxBuyCount.text = [NSString stringWithFormat:@"可借出0元"];
            if (!self.hasChangedCount) {
                self.countStepper.currentValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"0"]];
                
            }
            self.countStepper.maxValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"0"]];
        }
    }
    if (self.viewType == TradeBuySellViewTypeSell) {
        self.buyButtons.leftTitle = self.maxBuyCount.text;

    }

    [self setNeedsLayout];
}

//view类型，买卖
-(void)setViewType:(TradeBuySellViewType)aType {
    _viewType = aType;
//    NSLog(@"-%@",self.buyConfirmButton);
    if (_viewType == TradeBuySellViewTypeBuy) {
        self.priceStepper.skinColor = color6_text_xgw;
        self.countStepper.skinColor = color6_text_xgw;
        self.buyConfirmButton.backgroundColor = color6_text_xgw;
        [self.buyConfirmButton setBackgroundImage:[self createImageWithColor:color6_text_xgw rect:CGRectMake(0, 0, self.width * 0.55, 40.0f)] forState:UIControlStateNormal | UIControlStateHighlighted | UIControlStateDisabled];
        self.stockNameBackView.layer.borderColor = color6_text_xgw.CGColor;
        self.priceLabel.layer.borderColor = color6_text_xgw.CGColor;
        self.maxBuyCount.text = @"可买0股";
    }
    else if (_viewType == TradeBuySellViewTypeSell) {
        self.priceStepper.skinColor = color12_icon_xgw;
        self.countStepper.skinColor = color12_icon_xgw;
        self.buyConfirmButton.backgroundColor = color12_icon_xgw;
        [self.buyConfirmButton setBackgroundImage:[self createImageWithColor:color12_icon_xgw rect:CGRectMake(0, 0, self.width * 0.55, 40.0f)] forState:UIControlStateNormal | UIControlStateHighlighted | UIControlStateDisabled];
        self.stockNameBackView.layer.borderColor = color12_icon_xgw.CGColor;
        self.priceLabel.layer.borderColor = color12_icon_xgw.CGColor;
//        self.stockNameBackView.hidden = YES;
        self.maxBuyCount.text = @"可卖0股";
        self.MaxBuyCountValue =0;
    }
    self.buyButtons.leftTitle = self.maxBuyCount.text;

    [self clearForm];
}

//查询exchangType返回
-(void)setPriceDic:(id )aPrice {
    if (_priceDic) {
        _priceDic = nil;
    }
    _priceDic = aPrice;
    self.stockType = [_priceDic objectForKey:@"stockType"];
    if (self.controllerType == TradeControllerTypeReal) {
        NSNumber *up = [_priceDic objectForKey:@"upPrice"];
        NSNumber *down = [_priceDic objectForKey:@"downPrice"];
        [self changeViewWithUpPrice:up downPrice:down];
        [self setNeedsLayout];
    }
}

-(void)setStockType:(NSString *)aType {
    if (_stockType) {
        _stockType = nil;
    }
    _stockType = aType;
    //0股票，c创业板股票,h h股
    if ([_stockType isEqualToString:@"0"] || [_stockType isEqualToString:@"c"] || [_stockType isEqualToString:@"h"]) {
        self.isStock = YES;
    }//1基金，L lof基金，T etf基金，j货币etf基金，l国债etf基金
    else if ([_stockType isEqualToString:@"1"] || [_stockType isEqualToString:@"L"] || [_stockType isEqualToString:@"T"] || [_stockType isEqualToString:@"j"] || [_stockType isEqualToString:@"l"]){
        self.isStock = NO;
    }
    else if ([_stockType isEqualToString:@"Z"]) {
        self.isStock = NO;
    }
}

-(void)setIsStock:(BOOL)aBool {
    _isStock = aBool;
    self.priceStepper.isStock = aBool;
    if ((_stockCode.length > 2 && ([[_stockCode substringToIndex:3] isEqualToString:@"131"] ||[[_stockCode substringToIndex:3] isEqualToString:@"204"])) || aBool == NO) {
        self.priceStepper.step = [NSDecimalNumber decimalNumberWithString:@"0.001"];
        self.countStepper.step = [NSDecimalNumber decimalNumberWithString:@"1000"];
    }
    else {
        self.priceStepper.step = [NSDecimalNumber decimalNumberWithString:@"0.01"];
        self.countStepper.step = [NSDecimalNumber decimalNumberWithString:@"100"];
    }
    [self.buyPriceListView reloadData];
    [self.sellPriceListView reloadData];
}

//查询股票返回
-(void)setStockList:(NSArray *)aList {
    if (_stockList) {
        _stockList = nil;
        [self.stockListView reloadData];
    }
    _stockList = aList;
    if (![_stockList isKindOfClass:[NSArray class]] || !_stockList || _stockList.count == 0) {
        return;
    }
    [self addSubview:self.stockListView];
    [self.stockListView reloadData];
    if (self.stockListView.hidden) {
        self.stockListView.hidden = NO;
    }
}

//大约可买返回
-(void)setCountDic:(id)aDic {
    if (_countDic) {
        _countDic = nil;
    }
    _countDic = aDic;
    self.countStepper.minValue = [NSDecimalNumber decimalNumberWithString:@"0"];
    if (self.controllerType == TradeControllerTypeReal) {//实盘
        NSNumber *number = _countDic;
        
        if (self.viewType == TradeBuySellViewTypeBuy) {
            self.countStepper.maxValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",number]];
            
            if (!self.hasChangedCount) {
                self.countStepper.currentValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",number]];
            }
            
            self.maxBuyCount.text = [NSString stringWithFormat:@"可买%@股",number];
            if ([[_stockCode substringToIndex:3] isEqualToString:@"131"] ||[[_stockCode substringToIndex:3] isEqualToString:@"204"])
            {
                self.maxBuyCount.text = [NSString stringWithFormat:@"可买0股"];
                self.countStepper.currentValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",@0]];
                self.countStepper.maxValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",@0]];
            }
            self.buyButtons.leftTitle = self.maxBuyCount.text;

            [self setNeedsLayout];
        }
    }
    else {//模拟盘
        NSDictionary *dic = _countDic;
        NSNumber *sellCount = [dic objectForKey:@"enableAmount"];
        NSNumber *buyMoney = [dic objectForKey:@"funds"];
        if (self.viewType == TradeBuySellViewTypeSell) {//卖出
            self.countStepper.maxValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",sellCount]];
            self.maxBuyCount.text = [NSString stringWithFormat:@"可卖%@股",sellCount];
            self.buyButtons.leftTitle = self.maxBuyCount.text;

        }
        else {//买入
            /*过户费（单位为元）：max(买入总股数或卖出总股数/1000,1)
             券商佣金（单位为元）：max(买入总股数或卖出总股数*买入价格或卖出价格*0.05%,5)
             印花税（单位为元，只卖出方收取）：卖出总股数*卖出价格*0.1%
             
             最大可买股数（必须是100的整数倍）=（可用资金-委托冻结资金-过户费-券商佣金）/买入价格
             */
            CGFloat ghf = MAX(1.0f, self.countStepper.currentValue.doubleValue * 0.001);
            CGFloat qsyj = MAX(5.0f, self.countStepper.currentValue.doubleValue * self.priceStepper.currentValue.doubleValue * 0.0005);
            CGFloat maxBuyFloat = (buyMoney.doubleValue - ghf - qsyj) / self.priceStepper.currentValue.doubleValue;
            NSInteger maxBuyInt = (maxBuyFloat / 100) * 100;
            maxBuyInt = maxBuyInt - maxBuyInt % 100;
            self.countStepper.maxValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld",(long)maxBuyInt]];
            self.maxBuyCount.text = [NSString stringWithFormat:@"可买%ld股",(long)maxBuyInt];
            self.buyButtons.leftTitle = self.maxBuyCount.text;

        }
    }
}

//价格行情返回
-(void)setPriceData:(id)aData {
    if (_priceData) {
        _priceData = nil;
    }
    _priceData = aData;
    if (![_priceData isKindOfClass:[SKFiveReportVO class]]) {
        return;
    }
    SKFiveReportVO *receiveVO = (SKFiveReportVO *)self.priceData;
    if (![receiveVO.symbol isEqualToString: self.stockCode] ) {
        return;
    }
    
    [self applyPriceData];
}

-(void)applyPriceData {
    SKFiveReportVO *receiveVO = (SKFiveReportVO *)self.priceData;
//    NSLog(@"-----%@",[NSNumber numberWithBool:self.hasChangedPrice]);
    if (self.controllerType == TradeControllerTypeSimulate) {
        NSNumber *upPrice = [NSNumber numberWithFloat:receiveVO.lastClose *1.1f];
        NSNumber *downPrice = [NSNumber numberWithFloat:receiveVO.lastClose * 0.9f];
        [self changeViewWithUpPrice:upPrice downPrice:downPrice];
    }
    
    if (!self.hasChangedPrice) {
        if (self.isStock) {
            self.priceStepper.currentValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",receiveVO.close]];
        }
        else {
            self.priceStepper.currentValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.3f",receiveVO.close]];
        }
    }
    if (_stockCode.length > 2 && ([[_stockCode substringToIndex:3] isEqualToString:@"131"])) {
        NSInteger stockCount = self.enableBalance.integerValue / 1000;
        self.maxBuyCount.text = [NSString stringWithFormat:@"可借出%ld元",(long)stockCount * 1000];
        if (!self.hasChangedCount) {
            self.countStepper.currentValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld",(long)stockCount * 1000]];
        }
        self.countStepper.maxValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld",(long)stockCount * 1000]];

    }
    if (_stockCode.length > 2 && ([[_stockCode substringToIndex:3] isEqualToString:@"204"])) {
        NSInteger stockCount = self.enableBalance.integerValue / 1000;
        if (self.enableBalance.integerValue / 1000 > 0) {
            self.maxBuyCount.text = [NSString stringWithFormat:@"可借出%ld元",(long)stockCount * 1000];
            if (!self.hasChangedCount) {
                self.countStepper.currentValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld",(long)stockCount * 1000]];

            }
            self.countStepper.maxValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld",(long)stockCount * 1000]];
        } else {
            self.maxBuyCount.text = [NSString stringWithFormat:@"可借出0元"];
            if (!self.hasChangedCount) {
                self.countStepper.currentValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"0"]];

            }
            self.countStepper.maxValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"0"]];
        }

    }
    
    if (self.viewType == TradeBuySellViewTypeSell) {
        
        self.buyButtons.leftTitle = self.maxBuyCount.text;
    }
    
    NSMutableArray *buyArr = [NSMutableArray array];
    for (int i = 0; i < receiveVO.buys.count; i++) {
        BuyAndSellPriceVO *itemVO = [[BuyAndSellPriceVO alloc]init];
        itemVO.buyerOrSalor = [NSString stringWithFormat:@"买%d",i + 1];
        itemVO.price = [receiveVO.buys objectAtIndex:i];
        itemVO.amount = [receiveVO.buyVolumns objectAtIndex:i];
        itemVO.openPrice = [NSString stringWithFormat:@"%.3f",receiveVO.lastClose];
        [buyArr addObject:itemVO];
    }
    self.buyPriceList = buyArr.copy;
    [self.buyPriceListView reloadData];
    
    NSMutableArray *saleArr = [NSMutableArray array];
    for (int i = 5; i > 0; i--) {
        BuyAndSellPriceVO *itemVO = [[BuyAndSellPriceVO alloc]init];
        itemVO.buyerOrSalor = [NSString stringWithFormat:@"卖%d",i];
        itemVO.price = [receiveVO.sells objectAtIndex:i - 1];
        itemVO.amount = [receiveVO.sellVolumns objectAtIndex:i - 1];
        itemVO.openPrice = [NSString stringWithFormat:@"%.3f",receiveVO.lastClose];
        [saleArr addObject:itemVO];
    }
    self.sellPriceList = saleArr.copy;
    [self.sellPriceListView reloadData];

    
    [self setNeedsLayout];
}

//持仓返回
-(void)setHoldStockList:(NSArray *)aList {
    if (_holdStockList) {
        _holdStockList = nil;
    }
    _holdStockList = aList;
    [self.stockHolderView reloadData];
    if (self.controllerType == TradeControllerTypeSimulate) {
        return;
    }
    if (self.viewType == TradeBuySellViewTypeBuy) {
        if (_holdStockList.count == 0) {
            self.noHoldStockView.hidden = NO;
        }
        else {
            self.noHoldStockView.hidden = YES;
        }
        return;
    }

    if (_holdStockList.count == 0) {
        self.maxBuyCount.text = @"可卖0股";
        self.MaxBuyCountValue = 0;
        self.countStepper.maxValue = [NSDecimalNumber decimalNumberWithString:@"0"];
        self.countStepper.currentValue = [NSDecimalNumber decimalNumberWithString:@"0"];
        self.noHoldStockView.hidden = NO;
        
        if (_stockCode.length > 2 && ([[_stockCode substringToIndex:3] isEqualToString:@"131"])) {
            NSInteger stockCount = self.enableBalance.integerValue / 1000;
            self.maxBuyCount.text = [NSString stringWithFormat:@"可借出%ld元",(long)stockCount * 1000];
            self.countStepper.currentValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld",(long)stockCount * 1000]];
            self.countStepper.maxValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld",(long)stockCount * 1000]];
        }
        if (_stockCode.length > 2 && ([[_stockCode substringToIndex:3] isEqualToString:@"204"])) {
            NSInteger stockCount = self.enableBalance.integerValue / 1000;
            if (self.enableBalance.integerValue / 1000 > 0) {
                self.maxBuyCount.text = [NSString stringWithFormat:@"可借出%ld元",(long)stockCount * 1000];
                self.countStepper.currentValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld",(long)stockCount * 1000]];
                self.countStepper.maxValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld",(long)stockCount * 1000]];
            } else {
                self.maxBuyCount.text = [NSString stringWithFormat:@"可借出0元"];
                self.countStepper.currentValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"0"]];
                self.countStepper.maxValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"0"]];
            }
        }

        self.buyButtons.leftTitle = self.maxBuyCount.text;
        [self setNeedsLayout];
        return;
    }
    
    self.noHoldStockView.hidden = YES;
    BOOL notFound = YES;
    for (StockListVO *item in self.holdStockList) {
        if (item.stockCode.integerValue == _stockCode.integerValue) {
            notFound = NO;
            self.maxBuyCount.text = [NSString stringWithFormat:@"可卖%ld股",(long)item.enableAmount.integerValue];
            self.buyButtons.leftTitle = self.maxBuyCount.text;

            self.MaxBuyCountValue = [item.enableAmount integerValue];
            self.countStepper.maxValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",item.enableAmount]];
            if (!self.hasChangedCount) {
                self.countStepper.currentValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",item.enableAmount]];
               // self.priceStepper.currentValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",item.lastPrice]];
            }
            [self setNeedsLayout];
            return;
        }
    }
    if (notFound && !(_stockCode.length > 2 && ([[_stockCode substringToIndex:3] isEqualToString:@"131"])) && !(_stockCode.length > 2 && ([[_stockCode substringToIndex:3] isEqualToString:@"204"]))) {
        self.maxBuyCount.text = @"可卖0股";
        self.MaxBuyCountValue = 0;
        self.countStepper.maxValue = [NSDecimalNumber decimalNumberWithString:@"0"];
        self.countStepper.currentValue = [NSDecimalNumber decimalNumberWithString:@"0"];
        self.buyButtons.leftTitle = self.maxBuyCount.text;

    }
    [self setNeedsLayout];
}

- (void)setStockHolderAccount:(NSString *)aAccount {
    if (_stockHolderAccount) {
        _stockHolderAccount = nil;
    }
    _stockHolderAccount = aAccount;
//    NSString *titleString = nil;
//    if (self.viewType == TradeBuySellViewTypeBuy) {
//        titleString = @"买入委托";
//    }
//    else {
//        titleString = @"卖出委托";
//    }
//    
//    NSString *priceString = nil;
//    if ([self.buyButtons.firstTitle isEqualToString:@"限价委托"]) {
//        priceString = self.priceStepper.currentValue.stringValue;
//    }
//    else {
//        priceString = self.buyButtons.firstTitle;
//    }
//    
//    NSString *showMessage = [NSString stringWithFormat:@"  账户：%@\n  证券代码：%@\n  股票名称：%@\n  委托价格：%@\n  委托数量：%@\n",_stockHolderAccount,_stockCode,_stockName,priceString,self.countStepper.currentValue];
//    
//    [CMAlert show:titleString message:showMessage superView:nil buttonTitleList:@[@"取消",@"确认"] andDelegate:self];
}

-(BOOL)needToUp {
    if ([self.stockNameValueView isFirstResponder] || [self.countStepper isFirstResponder] || [self.priceStepper isFirstResponder]) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)setControllerType:(TradeControllerType)aType {
    _controllerType = aType;
    if (_controllerType == TradeControllerTypeSimulate) {
        self.buyButtons.hidden = YES;
        self.isStock = YES;
        self.headView.titleList = @[@"市值",@"盈亏",@"持仓",@"成本/现价"];
    }
    else {
        self.headView.titleList = @[@"市值",@"盈亏",@"持仓/可用",@"成本/现价"];
    }
}

- (void)setIsSecondTrade:(BOOL)aBool {
    _isSecondTrade = aBool;
    [self setNeedsLayout];
}

- (void)changeViewWithUpPrice:(NSNumber *)upPrice downPrice:(NSNumber *)downPrice {
    if (_stockCode.length > 2 && ([[_stockCode substringToIndex:3] isEqualToString:@"131"] ||[[_stockCode substringToIndex:3] isEqualToString:@"204"])) {
        upPrice = [NSNumber numberWithFloat:5000.000];
        downPrice = [NSNumber numberWithFloat:0.001];
    }
    if (self.isStock) {
        self.priceStepper.minValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",downPrice.floatValue]];
        self.priceStepper.maxValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",upPrice.floatValue]];
    }
    else {
        self.priceStepper.minValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.3f",downPrice.floatValue]];
        self.priceStepper.maxValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.3f",upPrice.floatValue]];
    }
    
    NSMutableAttributedString *mutaString = nil;
    if (_isStock) {
        mutaString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"跌停%.2f",downPrice.floatValue]];
    }
    else {
        //#warning 如何获得基金的利息和全价？
        mutaString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"跌停%.3f",downPrice.floatValue]];
    }
    NSRange range = NSMakeRange(2, mutaString.length - 2);
    [mutaString addAttribute:NSForegroundColorAttributeName value:color7_text_xgw range:range];
    self.minPriceLabel.attributedText = mutaString;
    
    mutaString = nil;
    if (_isStock) {
        mutaString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"涨停%.2f",upPrice.floatValue]];
    }
    else {
        mutaString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"涨停%.3f",upPrice.floatValue]];
    }
    range = NSMakeRange(2, mutaString.length - 2);
    [mutaString addAttribute:NSForegroundColorAttributeName value:color6_text_xgw range:range];
    self.maxPriceLabel.attributedText = mutaString;
    self.downPrice = [NSString stringWithFormat:@"%.2f",downPrice.floatValue];
    self.upPrice = [NSString stringWithFormat:@"%.2f",upPrice.floatValue];
//    [self setNeedsLayout];
}

#pragma mark =============================================通知=======================================================

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
//    self.titleBackView = nil;
    self.headView = nil;
    self.stockNameValueView = nil;
    self.stockNameBackView = nil;
    self.stockListView = nil;
//    self.priceValueLabel = nil;
//    self.increaseValueLabel = nil;
    self.buyButtons = nil;
    self.priceStepper.delegate = nil;
    self.priceStepper = nil;
    self.priceLabel = nil;
    self.minPriceLabel = nil;
    self.maxPriceLabel = nil;
    self.sellPriceListView = nil;
    self.buyPriceListView = nil;
    self.countStepper.delegate = nil;
    self.countStepper = nil;
//    self.countSlider = nil;
    self.maxBuyCount = nil;
    self.buyConfirmButton = nil;
    self.buySeperatorView = nil;
    self.buyPriceList = nil;
    self.sellPriceList = nil;
    self.stockHolderView = nil;
    self.queryString = nil;
    self.stockType = nil;
    self.engArr = nil;
    self.numArr = nil;
    self.englishBoard = nil;
    self.numberBoard = nil;
    self.button = nil;
    self.selectArr = nil;
    
    self.stockCode = nil;
    self.stockName = nil;
    self.stockExchangeType = nil;
//    self.priceDic = nil;
    self.countDic = nil;
    self.stockList = nil;
    self.holdStockList = nil;
    self.priceData = nil;
    _stockHolderAccount = nil;
}

-(void)textFieldDidChangeText:(NSNotification *)notification {
    //    self.needRefreshPrice = YES;//更改了股票，需要更改价格
    UITextField *textfield = notification.object;
    
    if (textfield != self.stockNameValueView) {
        [self.priceStepper resetStepper];
        [self.countStepper resetStepper];
        return;
    }
    else {
        NSString *changeText = [textfield.text uppercaseString];
        if ([changeText isEqualToString:@""]) {
            [self clearForm];
            [[NSNotificationCenter defaultCenter]postNotificationName:kTradeStockClearNotificationName object:nil];
            return;
        }
        self.queryString = changeText;
        [self getKeyBoardString:textfield.text];
    }
    
}

#pragma mark =============================================delegate=======================================================

- (void)didSelectedItemWithTitle:(NSString *)titleString {
    //右边的现价 市价选择
    if (self.buyButtons.buttonPickerType == marketPriceType) {
        if (![titleString hasPrefix:@"限价"]) {
            self.priceLabel.hidden = NO;
            self.priceLabel.text = titleString;
        }
        else {
            self.priceLabel.hidden = YES;
        }
    //左边的仓位选择
    }else if (self.buyButtons.buttonPickerType == HoldingType){
        NSInteger value ;

        if (self.viewType == TradeBuySellViewTypeBuy) {
            value = [_countDic integerValue];
            
        }else{
            
            value = self.MaxBuyCountValue;
        }
        
        if ([titleString isEqualToString:@"全仓"]) {
            
            self.countStepper.currentValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld",(long)value]];

        }else if ([titleString isEqualToString:@"半仓"]){
            NSString * countV = [self getIntNumberWithStr:[NSString stringWithFormat:@"%ld",(long)value/2]];
            
            self.countStepper.currentValue = [NSDecimalNumber decimalNumberWithString:countV];
            
            
        }else if ([titleString isEqualToString:@"1/3仓"]){
            NSString * countV = [self getIntNumberWithStr:[NSString stringWithFormat:@"%ld",(long)value/3]];;
            self.countStepper.currentValue = [NSDecimalNumber decimalNumberWithString:countV];


        }else if ([titleString isEqualToString:@"1/4仓"]){
            NSString * countV = [self getIntNumberWithStr:[NSString stringWithFormat:@"%ld",(long)value/4]];;
            self.countStepper.currentValue = [NSDecimalNumber decimalNumberWithString:countV];
        }
        
    }
   
}

/**
 *  点击弹出框的确认按钮触发事件
 */
#pragma mark--点击购买卖弹出框确认按钮
-(void)comitButtonTouchHandler {
    if (![self.stockDelegate respondsToSelector:@selector(sendEntrustRequestWithParam:)]) {
        return;
    }
    NSMutableDictionary *param = nil;
    if (self.controllerType == TradeControllerTypeReal) {
        param = [self buildBuyOrSellParam];
    }
    else {
        param = [self buildSimulateTradeParam];
    }
    
    [self.stockDelegate sendEntrustRequestWithParam:param.copy];
    //NSLog(@"确认买卖");
    self.countStepper.currentValue = [NSDecimalNumber decimalNumberWithString:@"0"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"requestTradeBalance" object:nil];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *text = [NSString stringWithFormat:@"%@",textField.text];
    NSRange range = [text rangeOfString:@" "];
    if (text.length == 6 && range.location == NSNotFound) {
        self.stockCode = text;
    }
    else if (text.length > 0 && text.length < 6) {
        SKCodeItemVO *item = [self.stockList firstObject];
        self.stockCode = item.code;
    }
    else if ([text isEqualToString:@""] || !textField.text) {
        self.stockCode = text;
        [self clearForm];
    }
//    self.maskView.hidden = YES;
    self.stockListView.hidden = YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.buyButtons hideButtonList];
    if ([self.priceStepper isFirstResponder]) {
        self.hasChangedPrice = YES;
        return;
    }
    if ([self.countStepper isFirstResponder]) {
        self.hasChangedCount = YES;
        return;
    }
    if (textField != self.stockNameValueView) {
        return;
    }
    if (self.stockNameValueView.text.length != 0) {
        return;
    }
    if (self.viewType == TradeBuySellViewTypeSell) {//卖出时，先展示持仓列表
        self.stockList = self.holdStockList;
    }
}

//下拉框控件
-(void)didPickerItemWithStockCode:(NSString *)stockCode {
//    self.needRefreshPrice = YES;
//    [self clearForm];
    NSString *stockString = stockCode;
    NSRange range = [stockString rangeOfString:@" "];
    if (range.location == NSNotFound) {
        return;
    }
    self.stockCode = [stockString substringFromIndex:range.location + range.length];
    self.stockName = [stockString substringToIndex:range.location];
}

#pragma mark--请求最大可购买数
-(void)valueChangestepper:(CMStepper *)stepper {
    //两个stepper的currentValue值改变会触发这个方法
    if (stepper == self.priceStepper && [self.priceStepper isFirstResponder]) {
        self.hasChangedPrice = YES;
        [self.priceStepper resetStepper];
        [self.countStepper resetStepper];
    }
    if (stepper == self.priceStepper && self.controllerType == TradeControllerTypeSimulate) {
        //请求最大可购买数
        if (![self.stockDelegate respondsToSelector:@selector(requestStockCountWithParam:)]) {
            return;
        }
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:self.stockCode forKey:@"stockCode"];
        [param setValue:[NSNumber numberWithInteger:self.viewType + 1] forKey:@"businessType"];
        [self.stockDelegate requestStockCountWithParam:param];
        return;//模拟盘到此为止
    }
    
    if (stepper == self.priceStepper && self.viewType == TradeBuySellViewTypeBuy) {
        if (self.stockCode.length == 0) {
            return;
        }
        if ([self.priceStepper.currentValue compare:[NSDecimalNumber decimalNumberWithString:@"0"]] == NSOrderedSame ) {
            return;
        }
        //请求最大可购买数
        if (![self.stockDelegate respondsToSelector:@selector(requestStockCountWithParam:)]) {
            return;
        }
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:self.stockCode forKey:@"stockCode"];
        
       
        if ([self.buyButtons.firstTitle hasSuffix:@"委托"]) {
            [param setValue:@"0" forKey:@"entrustProp"];
            [param setValue:stepper.currentValue forKey:@"entrustPrice"];
        }
        else {
            if ([self.buyButtons.firstTitle isEqualToString:@"最优五档即成剩撤"]) {
                [param setValue:@"U" forKey:@"entrustProp"];
            }
            else if ([self.buyButtons.firstTitle isEqualToString:@"最优五档即成剩转限"]) {
                [param setValue:@"R" forKey:@"entrustProp"];
            }
            else if ([self.buyButtons.firstTitle isEqualToString:@"对手最优价格"]) {
                [param setValue:@"Q" forKey:@"entrustProp"];
            }
            else if ([self.buyButtons.firstTitle isEqualToString:@"本方最优价格"]) {
                [param setValue:@"S" forKey:@"entrustProp"];
            }
            else if ([self.buyButtons.firstTitle isEqualToString:@"即时成交剩余撤销"]) {
                [param setValue:@"T" forKey:@"entrustProp"];
            }
            else if ([self.buyButtons.firstTitle isEqualToString:@"全额成交或撤销"]) {
                [param setValue:@"V" forKey:@"entrustProp"];
            }
            [param setValue:self.priceStepper.currentValue forKey:@"entrustPrice"];
        }
   
        [param setValue:self.stockExchangeType forKey:@"exchangeType"];
        [self.stockDelegate requestStockCountWithParam:param];
    }
    else if (stepper == self.countStepper) {
        self.hasChangedCount = YES;
        //self.hasChangedPrice = YES;
        if (self.viewType == TradeBuySellViewTypeSell) {
            return;
        }
        if ((NSInteger)stepper.currentValue.integerValue % 100 != 0) {
            [CMProgress showWarningProgressWithTitle:nil message:@"输入的股数非100的倍数！" warningImage:nil duration:kHintTimeInterval];
        }
    }
}

//上下限
-(void)valueErrorStepper:(CMStepper *)stepper andLeftError:(BOOL)leftError andRightError:(BOOL)rightError {
    if (stepper == self.priceStepper) {
        if (leftError) {
            [CMProgress showWarningProgressWithTitle:nil message:@"超出跌停价格！" warningImage:nil duration:kHintTimeInterval];
        }
        else if (rightError) {
            [CMProgress showWarningProgressWithTitle:nil message:@"超出涨停价格！" warningImage:nil duration:kHintTimeInterval];
        }
    }
    else if (stepper == self.countStepper) {
        if (!rightError) {
            return;
        }
        if (self.viewType == TradeBuySellViewTypeBuy) {
            [CMProgress showWarningProgressWithTitle:nil message:@"购买股数超出最大可购买数量！" warningImage:nil duration:kHintTimeInterval];
        }
        else {
            [CMProgress showWarningProgressWithTitle:nil message:@"卖出股数超出最大可卖出数量！" warningImage:nil duration:kHintTimeInterval];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.stockListView) {
        return 40.0f;
    }
    else if (tableView == self.stockHolderView) {
        return 60.0f;
    }
    else {
        return 22.0f;
    }
    return 0.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.stockListView) {
        if (self.stockList.count == 0) {
            return [[UITableViewCell alloc]init];
        }
        BuyViewStockListCell *cell = [tableView dequeueReusableCellWithIdentifier:stockCellIdentifier];
        if (!cell) {
            cell = [[BuyViewStockListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stockCellIdentifier];
        }
        cell.cellData = [self.stockList objectAtIndex:indexPath.row];
        [cell applyStringColorWithQueryString:self.queryString];
        return cell;
    }
    else if (tableView == self.buyPriceListView) {
        BuyAndSellPriceListCell *cell = [tableView dequeueReusableCellWithIdentifier:buyPriceCellIdentifier];
        if (!cell) {
            cell = [[BuyAndSellPriceListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:buyPriceCellIdentifier];
        }
        cell.isStock = self.isStock;
        if (self.buyPriceList.count == 0) {
            BuyAndSellPriceVO *tempVO = [[BuyAndSellPriceVO alloc]init];
            tempVO.buyerOrSalor = [NSString stringWithFormat:@"买%d",(int)indexPath.row + 1];
            tempVO.price = @"--";
            tempVO.amount = @"--";
            cell.isStock = self.isStock;
            cell.cellData = tempVO;
        }
        else {
            cell.isStock = self.isStock;
            cell.cellData = [self.buyPriceList objectAtIndex:indexPath.row];
        }
        return cell;
    }
    else if (tableView == self.sellPriceListView) {
        BuyAndSellPriceListCell *cell = [tableView dequeueReusableCellWithIdentifier:sellPriceCellIdentifier];
        if (!cell) {
            cell = [[BuyAndSellPriceListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sellPriceCellIdentifier];
        }
        if (self.sellPriceList.count == 0) {
            BuyAndSellPriceVO *tempVO = [[BuyAndSellPriceVO alloc]init];
            tempVO.buyerOrSalor = [NSString stringWithFormat:@"卖%d",(int)(5 - indexPath.row)];
            tempVO.price = @"--";
            tempVO.amount = @"--";
            cell.isStock = self.isStock;
            cell.cellData = tempVO;
        }
        else {
            cell.isStock = self.isStock;
            cell.cellData = [self.sellPriceList objectAtIndex:indexPath.row];
        }
        return cell;
    }
    else if (tableView == self.stockHolderView) {
        TradeStockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stockHolderCellIdentifier];
        cell.stockVO = [self.holdStockList objectAtIndex:indexPath.row];
        cell.actionView.hidden = YES;
        cell.cellType = self.controllerType;
        return cell;
    }
    else {
        return [[UITableViewCell alloc]init];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.stockListView) {
        if (self.stockList.count >= 5) {
            self.stockListView.height = 40.0f * 5;
        }
        else {
            self.stockListView.height = 40.0f * self.stockList.count;
        }
        return self.stockList.count;
    }
    else if (tableView == self.stockHolderView) {
        return self.holdStockList.count;
    }
    else{
        return 5;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //取到选中的数据源，改变text
    if (tableView == self.stockListView) {
//        self.needRefreshPrice = YES;
//        [self clearForm];
        BuyViewStockListCell *cell = (BuyViewStockListCell *)[tableView cellForRowAtIndexPath:indexPath];
        self.stockNameValueView.text = cell.stockString;
        [self.stockListView removeFromSuperview];
        NSRange range = [cell.stockString rangeOfString:@" "];
        if (range.location == NSNotFound) {
            return;
        }
        NSString *stockCode = [cell.stockString substringWithRange:NSMakeRange(0, range.location)];
        self.stockCode = stockCode;
        
        [self.stockNameValueView resignFirstResponder];
    }
    else if (tableView == self.buyPriceListView) {
        BuyAndSellPriceListCell *cell = (BuyAndSellPriceListCell *)[tableView cellForRowAtIndexPath:indexPath];
        BuyAndSellPriceVO *priceVO = cell.cellData;
        self.priceStepper.currentValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",priceVO.price]];
        self.hasChangedPrice = YES;

        NSArray *cells = self.sellPriceListView.visibleCells;
        [cells makeObjectsPerformSelector:@selector(setSelected:) withObject:nil];
    }
    else if (tableView == self.sellPriceListView) {
        BuyAndSellPriceListCell *cell = (BuyAndSellPriceListCell *)[tableView cellForRowAtIndexPath:indexPath];
        BuyAndSellPriceVO *priceVO = cell.cellData;
        self.priceStepper.currentValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",priceVO.price]];
        //self.hasChangedPrice = NO;
        self.hasChangedPrice = YES;
        NSArray *cells = self.buyPriceListView.visibleCells;
        [cells makeObjectsPerformSelector:@selector(setSelected:) withObject:nil];
    }
    else if (tableView == self.stockHolderView) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        StockListVO *itemVO = [self.holdStockList objectAtIndex:indexPath.row];
//        self.maskView.hidden = !self.maskView.hidden;
//        self.needRefreshPrice = YES;
//        [self clearForm];
        self.stockCode = itemVO.stockCode;
        self.stockName = itemVO.stockName;
        self.hasChangedPrice = NO;
        self.hasChangedCount = NO;
        if (self.viewType == TradeBuySellViewTypeSell) {
            self.maxBuyCount.text = [NSString stringWithFormat:@"可卖%@股",[NSString stringWithFormat:@"%@",itemVO.enableAmount]];
            
            self.buyButtons.leftTitle = self.maxBuyCount.text;
            self.MaxBuyCountValue = [itemVO.enableAmount integerValue];
            self.countStepper.maxValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",itemVO.enableAmount]];
            self.countStepper.currentValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",itemVO.enableAmount]];
            self.priceStepper.currentValue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",itemVO.lastPrice]];
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hideKeyboards];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self hideKeyboards];
}
#pragma mark--点击跌停价格
-(void)minPriceClick{
    if ([NSString isBlankString:self.downPrice]) {
        return;
    }
    self.priceStepper.currentValue =[NSDecimalNumber decimalNumberWithString:self.downPrice];
    self.hasChangedPrice = YES;
    self.hasChangedCount = NO;

}
#pragma  mark--点击涨停价格
-(void)maxPriceClick{
    if ([NSString isBlankString:self.upPrice]) {
        return;
    }
    self.priceStepper.currentValue =[NSDecimalNumber decimalNumberWithString:self.upPrice];
    self.hasChangedPrice = YES;
    self.hasChangedCount = NO;

}
-(NSString *)getIntNumberWithStr:(NSString *)str{
   // NSString * temStr = str;
    NSMutableString * temStr = [NSMutableString stringWithString:str];
    if (str.length<3) {
        [CMProgress showWarningProgressWithTitle:nil message:@"输入的股数非100的倍数！" warningImage:nil duration:2];
        return @"0";
    }else{
        NSRange range = {str.length-2,2};
        [temStr replaceCharactersInRange:range withString:@"00"];
        return temStr;
        
    }
    
}

@end
