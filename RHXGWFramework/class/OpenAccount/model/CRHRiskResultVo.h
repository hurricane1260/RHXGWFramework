//
//  CRHRiskResultVo.h
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/5/26.
//
//

#import "RHBaseVO.h"

@interface CRHRiskResultVo : RHBaseVO

/**
 试卷得分
 */
kRhPCopy NSString * paper_score;

/**
 客户风险等级
 */
kRhPCopy NSString * corp_risk_level;

/**
 客户风险等级名称(corp_risk_level的字典翻译值)
 */
kRhPCopy NSString * risk_level_name;

/**
 投资建议
 */
kRhPCopy NSString * invest_advice;


//以下为新增
/**
    投资期限
 */
kRhPCopy NSString * invest_term;

/**
    投资类别
 */
kRhPCopy NSString * invest_kind;

/**
 投资期限（名称）
 */
kRhPCopy NSString * en_invest_term;

/**
 投资类别（名称）
 */
kRhPCopy NSString * en_invest_kind;

/**
 特殊情况
 */
kRhPCopy NSString * specific_factor;

/**
 适当性匹配建议
 */
kRhPCopy NSString * suggest_risk_promot;


/**
    用户答案
 */
kRhPCopy NSString * answer;

@end
