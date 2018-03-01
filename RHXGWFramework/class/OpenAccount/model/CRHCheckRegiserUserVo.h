//
//  CRHCheckRegiserUserVo.h
//  JinHuiXuanGuWang
//  财人汇注册用户信息验证
//  Created by rxhui on 17/5/16.
//
//

#import "RHBaseVO.h"

@interface CRHCheckRegiserUserVo : RHBaseVO

/**
    客户编号
 */
kRhPCopy NSString * client_id;

/**
    客户名称
 */
kRhPCopy NSString * client_name;

/**
    证件类型
 */
kRhPCopy NSString * id_kind;

/**
    证件号码
 */
kRhPCopy NSString * id_no;

/**
    开户类型
 */
kRhPCopy NSString * open_type;

/**
    是否第一次注册
 */
kRhPStrong NSNumber * is_first_reg;
@end
