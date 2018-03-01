//
//  CRHUserVideoStausInfoVo.h
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/5.
//
//

#import "RHBaseVO.h"

@interface CRHUserVideoStausInfoVo : RHBaseVO

/**
 当前在总队列中的位置 
 */
kRhPCopy NSString * waitPosition;

/**
 当前在自己营业部队列中的位置
 */
kRhPCopy NSString * waitPositionInSelfOrg;

/**
 所有排队总人数
 */
kRhPCopy NSString * waitNum;

/**
 0:排队中 1：被应答
 */
kRhPCopy NSString * status;

/**
 视频流服务器Ip
 */
kRhPCopy NSString * anyChatStreamIpOut;

/**
 视频流服务器Port
 */
kRhPCopy NSString * anyChatStreamPort;

/**
 登录视频服务器用户名
 */
kRhPCopy NSString * userName;

/**
 登录登录视频服务器密码
 */
kRhPCopy NSString * loginPwd;

/**
 视频服务器房间号
 */
kRhPCopy NSString * roomId;

/**
 视频服务器房间密码
 */
kRhPCopy NSString * roomPwd;

/**
 对方视频系统Id
 */
kRhPCopy NSString * remoteId;



@end
