//
//  CRHVideoServiceVo.h
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/5.
//
//

#import "RHBaseVO.h"

@interface CRHVideoServiceVo : RHBaseVO

/**
 柜员工号
 */
kRhPCopy NSString * emp_no;

/**
 柜员姓名
 */
kRhPCopy NSString * emp_name;

/**
 所属营业部名称
 */
kRhPCopy NSString * org_name;

/**
 执业证书编号
 */
kRhPCopy NSString * cert_no;

@end
