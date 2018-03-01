//
//  RiskLetterView.h
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/12.
//
//风险告知函

#import <UIKit/UIKit.h>
@class  CRHClientInfoVo;
@class CRHRiskResultVo;
@interface RiskLetterView : UIView
@property (nonatomic,strong)id viewData;

- (NSInteger)getCurrentHeight;

-(void)setViewDataWithClientVo:(CRHClientInfoVo *)ClientVo RiskResultVo:(CRHRiskResultVo *)RiskResultVo;

@end
