//
//  WebViewController.h
//  JinHuiXuanGuWang
//
//  Created by Zzbei on 2016/11/10.
//
//

#import "BaseViewController.h"
//@class SPShareNewsBubbleViewModel;

typedef enum{
    addStock,
    deleteStock
} changeStockType;

@interface WebViewController : BaseViewController

@property (nonatomic,copy) NSString * UrlString;
@property (nonatomic,copy) NSString * webViewTitle;
@property (nonatomic,copy) NSString * shareContent;
@property (nonatomic,strong) NSNumber * sourceType;  //1是内链,2是外链

//@property (nonatomic,strong) SPShareNewsBubbleViewModel * viewModel;

@end
