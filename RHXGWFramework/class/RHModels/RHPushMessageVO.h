//
//  RHPushMessageVO.h
//  TZYJ_IPhone
//
//  Created by liyan on 16/4/29.
//
//

#import <Foundation/Foundation.h>

@interface RHPushMessageVO : NSObject

/**
 *  模块Id
 */
@property (nonatomic,strong) NSNumber * modelId;

/**
 *  消息标题
 */
@property (nonatomic,copy) NSString * contentTitle;

/**
 *  资讯详情
 */
@property (nonatomic,copy) NSString * content;

/**
 *  资讯主键
 */
@property (nonatomic,strong) NSNumber * newsId;

/**
 *  时间
 */
@property (nonatomic,strong) NSNumber * time;

/**
 *  消息类型
 */
@property (nonatomic,strong) NSNumber * type;

+ (id)generateWithDict:(NSDictionary *)dic;

@end
