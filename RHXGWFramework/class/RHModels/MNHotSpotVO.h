//
//  MNHotSpotVO.h
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/10/27.
//
//

#import <Foundation/Foundation.h>

@interface MNHotSpotVO : NSObject

kRhPStrong NSNumber * newsId;

kRhPCopy NSString * title;

kRhPCopy NSString * outline;

kRhPStrong NSNumber * time;

kRhPStrong NSString * content;

kRhPAssign CGFloat  height;


//用于活动内参短文推送
/**
 *   背景图片地址
 */
kRhPCopy NSString * photoUrl;

/**
 *  类型：1-内参，2-短文，3-活动
 */
kRhPStrong NSNumber * type;

/**
 *  链接地址
 */
kRhPCopy NSString * url;

/**
 *  来源
 */
kRhPCopy NSString * comefrom;

/**
 *  时间
 */
kRhPStrong NSNumber * updateAt;


+ (id)generateWithDict:(NSDictionary *)dic;
@end
