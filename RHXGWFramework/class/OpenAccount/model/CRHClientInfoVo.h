//
//  CRHClientInfoVo.h
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/28.
//
//

#import "RHBaseVO.h"

@interface CRHClientInfoVo : RHBaseVO

/**
 客户编号
 */
kRhPCopy NSString * client_id;

/**
 资产账户
 */
kRhPCopy NSString * fund_account;

/**
 分支机构
 */
kRhPStrong NSNumber * branch_no;

/**
 客户姓名
 */
kRhPCopy NSString * client_name;

/*
 证件类别
 */
kRhPCopy NSString * id_kind;

/**
 证件号码
 */
kRhPCopy NSString * id_no;

/**
 证件开始日期
 */
kRhPStrong NSNumber * id_begindate;

/**
 证件有效截止日期
 */
kRhPStrong NSNumber * id_enddate;

/**
 手机号码
 */
kRhPCopy NSString * mobile_tel;

/**
 出生日期
 */
kRhPStrong NSNumber * birthday;

/**
 身份证地址
 */
kRhPCopy NSString * id_address;

/**
 签发机关
 */
kRhPCopy NSString * issued_depart;

/**
 客户风险测评日
 */
kRhPStrong NSNumber * corp_begin_date;

/**
 客户风险到期日
 */
kRhPStrong NSNumber * corp_end_date;

/**
 反洗钱风险等级
 */
kRhPStrong NSNumber * aml_risk_level;

/**
 客户风险等级
 */
kRhPStrong NSNumber * corp_risk_level;

/**
 客户性别
 */
kRhPCopy NSString * client_gender;

/**
 国籍地区
 */
kRhPCopy NSString * nationality;

/**
 回访日期
 */
kRhPStrong NSNumber * confirm_date;

/**
 客户状态
 */
kRhPCopy NSString * client_status;

/**
 联系地址
 */
kRhPCopy NSString * address;

/**
 邮政编码
 */
kRhPCopy NSString * zipcode;

/**
 城市编号
 */
kRhPCopy NSString * city_no;

/**
 电子信箱
 */
kRhPCopy NSString * e_mail;

/**
 学历代码
 */
kRhPCopy NSString * degree_code;

/**
 职业代码
 */
kRhPCopy NSString * profession_code;
@end
