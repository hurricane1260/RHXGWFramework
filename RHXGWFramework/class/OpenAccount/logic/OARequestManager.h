//
//  OARequestManager.h
//  JinHuiXuanGuWang
//
//  Created by liyan on 17/5/5.
//
//

#import "RHBaseHttpRequest.h"
@class CRHProtocolListVo;

@interface OARequestManager : RHBaseHttpRequest

/**
 *  通用请求类
 *
 *  @param  param    参数
 *          type     请求类型
 *          callBack 请求回调
 *          url      请求url索引
 */
- (void)sendCommonRequestWithParam:(id)param withRequestType:(CRHRequestType)type withUrlString:(NSString *)url withCompletion:(RequestCompletionCallback)callBack;

- (void)sendJinHuiRequestWithParam:(id)param withRequestType:(CRHRequestType)type withUrlString:(NSString *)url withCompletion:(RequestCompletionCallback)callBack;


/**
 *  发送短信验证码
 *
 *  @param  mobile_tel 电话号码
 */
- (void)sendSMSVerifyCodeWithParam:(NSDictionary *)param withRequestType:(CRHRequestType)type withCompletion:(RequestCompletionCallback)callBack;


/**
 *  注册客户信息查询
 *
 *  @param  mobile_tel （电话号码）  mobile_code（短信验证码） app_id（接入方式 网上收集端 200）register_way （注册来源 1:PC,2:手机，默认1）   csdc_open_flag（1：开户，3：转户，5：产品户） op_station（站点地址 传ip即可）
 */
- (void)sendCheckRegisterUserWithParam:(NSDictionary *)param withRequestType:(CRHRequestType)type withCompletion:(RequestCompletionCallback)callBack;


/**
 *  验证短信验证码
 *
 *  @param  phoneNumber 电话号码  verifyCode 验证码 type 类型
 */
- (void)sendCheckSMSVerifyCodeWithParam:(NSDictionary *)param withRequestType:(CRHRequestType)type withCompletion:(RequestCompletionCallback)callBack;

/**
 *  请求协议列表
 *
 *  @param  biz_id （业务标记：1:开户，3：转户，5：简易开户，6：三方存管，7：经纪人，21：中登证书，22：自建证书）
            econtract_type （协议类别：0:存管协议、1:开户相关协议、2:数字证书申请责任书)
 */
- (void)requestProtocolListWithParam:(id)param withRequestType:(CRHRequestType)type withCompletion:(RequestCompletionCallback)callBack;

/**
 *  请求协议内容
 *
 *  @param  econtract_id 电子合同id
 */
- (void)requestProtocolContentWithParam:(id)param withRequestType:(CRHRequestType)type withCompletion:(RequestCompletionCallback)callBack;

/**
 *  请求协议签署 因为这个接口调取地方较多 单独写接口 简化参数添加
 *
 *  @param  vo 合同信息类  caCertSn ca证书（需要从crhCACertQuery接口获取） bizType业务类型（1 开户   6 三方存管协议）
 */
//- (void)requestProtocolSignWithCRHProtocolListVo:(CRHProtocolListVo *)vo withCACertSn:(NSString *)caCertSn withRequestType:(CRHRequestType)type withCompletion:(RequestCompletionCallback)callBack;

- (void)requestProtocolSignWithCRHProtocolListVo:(CRHProtocolListVo *)vo withCACertSn:(NSString *)caCertSn withRequestType:(CRHRequestType)type withBusinessType:(NSString *)bizType withCompletion:(RequestCompletionCallback)callBack;

/**
 *  上传个人身份证
 *
 *  @param
 */
- (void)requestUploadPersonIdImgToSever:(id)param withRequestType:(CRHRequestType)type withCompletion:(RequestCompletionCallback)callBack;

//- (void)requestUploadPersonIdImgToSever:(id)param withImgData:(NSData *)data  withRequestType:(CRHRequestType)type withCompletion:(RequestCompletionCallback)callBack;
//
//- (void)requestUploadPersonIdImgToSever:(id)param withImgKey:(NSString *)imgKey withImgData:(NSData *)data  withRequestType:(CRHRequestType)type withCompletion:(RequestCompletionCallback)callBack;
/**
 *  上传个人信息
 *
 *  @param  
 */
- (void)requestUploadPersonMsgToSever:(id)param withRequestType:(CRHRequestType)type withCompletion:(RequestCompletionCallback)callBack;

/**
 *  查询字典项
 *
 *  @param
 */
- (void)queryDicWithId:(NSString *)entry withCompletion:(RequestCompletionCallback)callBack;

/**
    
 */
- (void)requestQueryClientInfoWithComoletion:(RequestCompletionCallback)callBack;
@end
