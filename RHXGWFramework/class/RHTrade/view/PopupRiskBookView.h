//
//  PopupRiskBookView.h
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/24.
//
//

#import <UIKit/UIKit.h>

@interface PopupRiskBookView : UIView

@property (nonatomic, copy) ButtonCommonCallBack  singBtnBlock;
@property (nonatomic, copy) ButtonCommonCallBack  removeRiskBookView;


-(instancetype)initRiskBookViewWithParams:(NSDictionary *)params;

@end
