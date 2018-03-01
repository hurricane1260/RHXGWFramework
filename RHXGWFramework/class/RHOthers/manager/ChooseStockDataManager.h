//
//  ChooseStockDataManager.h
//  JinHuiXuanGuWang
//
//  Created by Zzbei on 2016/10/24.
//
//

#import <Foundation/Foundation.h>

@protocol ChooseStockDataManagerDelegate <NSObject>

@optional
//请求选股banner返回
- (void)requestChooseStockBannerResultHandler:(id)resultData andSuccess:(BOOL)success;
//请求选股列表返回
//- (void)requestChooseStockListResultHandler:(id)resultData andSuccess:(BOOL)success;
//请求实时选股返回
//- (void)requestCurrenChooseStockResultHandler:(id)resultData andPageCount:(id)pageCount andSuccess:(BOOL)success;
//请求荐股返回
//- (void)requestRecommendStockResultHandler:(id)resultData andSuccess:(BOOL)success;
//请求标签股返回
//- (void)requestTagStockResultHandler:(id)resultData andSuccess:(BOOL)success;
//意见反馈返回
//- (void)requestFeedBackkResultHandler:(id)resultData andSuccess:(BOOL)success;

@end

@interface ChooseStockDataManager : NSObject

@property (nonatomic,weak) id<ChooseStockDataManagerDelegate> delegate;

- (void)cancelAllRequest;

/**
 *  @brief 请求选股banner
 *
 *  @param location 位置
 */
- (void)requestChooseStockBannerWithLocation:(NSString *)location;

/**
 *  @brief 请求选股列表
 */
- (void)requestChooseStockList;

/**
 *  @brief 请求实时选股
 *
 *  @param sortFlag 排序规则0降序,1升序
 */
//- (void)requestCurrentChooseStockWithSortFlag:(NSString *)sortFlag andPageSize:(NSString *)pageSize andCurrentPage:(NSString *)currentPage;

/**
 *  @brief 请求荐股
 *
 *  @param 页码
 */
//- (void)requestRecommendStockWithPageSize:(NSString *)pageSize andCurrentPage:(NSString *)currentPage andType:(NSString *)type;

/**
 *  @brief 请求标签股
 *
 *  @param 页码, tagType标签类型
 */
//- (void)requestTagStockWithTagType:(NSString *)tagType andPageSize:(NSString *)pageSize andCurrentPage:(NSString *)currentPage;

/**
 *  @brief 意见返回(客服小妹)
 *
 *  @param userId 用户ID, content 建议内容
 */
//- (void)requestFeedBackWithUserId:(NSString *)userId andContent:(NSString *)content;

@end
