//
//  CRHBankListVo.h
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/5/31.
//
//

#import "RHBaseVO.h"

@interface CRHBankListVo : RHBaseVO<NSCoding>

/**
 分支机构
 */
kRhPCopy NSString * branch_no;

/**
 银行代码
 */
kRhPCopy NSString * bank_no;

/**
 银行名称
 */
kRhPCopy NSString * bank_name;

/**
 类型  11：一步式需要密码，12：一步式无需密码，21：两步式需要卡号，22：两步式无需卡号
 */
kRhPCopy NSString * fun_flag;

/**
 拼音描述
 */
kRhPCopy NSString * pinyin;

/**
 电子合同编号
 */
kRhPCopy NSString * econtract_id;

/**
 三方机构认证时 银行标识
 */
kRhPCopy NSString * verify_bank_id;

/**
 支持一卡双签的银行配置，如：工行普通存管支持双签，则配置工行信用存管的bank_no
 */
kRhPCopy NSString * res_bank_no;

/**
 银行卡名称
 */
kRhPCopy NSString * card_name;

/**
 密码名称
 */
kRhPCopy NSString * pwd_name;

/**
 银行帮助信息显示 可以包括样式的html
 */
kRhPCopy NSString * depository_memo;

/**
 银行绑定方式
 */
kRhPCopy NSString * bank_type;

@end
