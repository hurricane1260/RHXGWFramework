//
//  SKCodeItemVO.h
//  iphone-stock
//
//  Created by ztian on 14-3-6.
//  retainright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "SKBaseVO.h"
#import "SKUtils.h"

@interface SKCodeItemVO : SKBaseVO <NSCoding>

/// 根据字符串初始化，格式为“000002,万  科Ａ,sza,wka”
- (id)initWithNSString:(NSString *)value;

///标识
@property (nonatomic,retain) NSString *flag;
/// 股票代码，带前缀
@property (nonatomic,retain) NSString *symbol;
/// 名称
@property (nonatomic,retain) NSString *name;
/// 类型
@property (nonatomic,readonly) NSString *type;
/// 拼音
@property (nonatomic,retain) NSString *pinyin;
/// 代码，不带前缀
@property (nonatomic,retain) NSString *code;
/// 前缀
@property (nonatomic,retain) NSString *prefix;
/// 子板块或成分股，元素为股票代码，格式为sha_000001
@property (nonatomic,retain) NSMutableArray *subItems;
/// 上级板块，元素为股票代码，格式为sha_000001
@property (nonatomic,retain) NSMutableArray *supItems;
/// 申万级别，只有当type为TYPE_BLOCK_SW时有效，从1开始
@property (nonatomic,assign) int level;

///是否是自选股
@property (nonatomic,assign) BOOL isOptional;

/// 是否是指数
- (BOOL)isIndex;
/// 是否是板块
- (BOOL)isBlock;
/// 是否是股票
- (BOOL)isStock;
/// 是否是A股
- (BOOL)isAStock;
/// 是否是B股
- (BOOL)isBStock;






@end
