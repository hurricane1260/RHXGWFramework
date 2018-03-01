//
//  CRHRiskTestVo.h
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/5/26.
//
//

#import "RHBaseVO.h"

@interface CRHRiskTestVo : RHBaseVO

/**
 问题编号
 */
kRhPCopy NSString * question_no;

/**
 试题类型（0:单选题 1:多选题 2:可编辑题）
 */
kRhPCopy NSString * question_kind;

/**
 试题内容
 */
kRhPCopy NSString * question_content;

/**
 试题类别（0:客观情况 1:主观意向）
 */
kRhPCopy NSString * question_type;

/**
 答案内容(示例:{3:31-40岁,2:23-30岁,1:22岁以下})
 */
kRhPCopy NSDictionary * answer_content;

/**
 默认选项(多选用半角逗号隔开，如1,2,3)
 */
kRhPCopy NSString * default_answer;

/**
 警告信息（和要求答案不符时的说明）
 */
kRhPCopy NSString * warn_tip;

/**
 试卷编号
 */
kRhPCopy NSString * local_paper_id;
@end
