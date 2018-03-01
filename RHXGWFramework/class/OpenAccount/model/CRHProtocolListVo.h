//
//  CRHProtocolListVo.h
//  JinHuiXuanGuWang
//  财人汇电子合同列表
//  Created by liyan on 17/5/15.
//
//

#import "RHBaseVO.h"

@interface CRHProtocolListVo : RHBaseVO

/**
    电子合同id
 */
kRhPCopy NSString * econtract_id;

/**
    电子合同类别
 */
kRhPCopy NSString * econtract_type;

/**
    电子合同版本
 */
kRhPCopy NSString * econtract_version;

/**
    电子合同MD5值
 */
kRhPCopy NSString * econtract_md5;

/**
    电子合同编号
 */
kRhPCopy NSString * econtract_no;

/**
    电子合同版本
 */
kRhPCopy NSString * econtract_remark;

/**
    电子合同名称
 */
kRhPCopy NSString * econtract_name;

/**
    电子合同内容
 */
kRhPCopy NSString * econtract_content;

@end
