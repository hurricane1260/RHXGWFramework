//
//  CRHMessageVo.h
//  JinHuiXuanGuWang
//
//  Created by liyan on 17/5/15.
//
//

#import "RHBaseVO.h"

@interface CRHMessageVo : RHBaseVO

/**
 接口响应信息中必须包含error_no和error_info，其中error_no为0时，请求成功，可以正常解析返回的数据，error_no不为0时表示请求失败，解析error_info中的错误消息；
 */
kRhPStrong NSNumber * error_no;

kRhPCopy NSString * error_info;

@end
