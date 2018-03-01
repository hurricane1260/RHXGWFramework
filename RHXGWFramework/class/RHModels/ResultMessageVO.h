//
//  ResultMessageVO.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-13.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultMessageVO : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

+(ResultMessageVO *)parseData:(id)data;

+(ResultMessageVO *)buildMessageVOWithMessage:(NSString *)aMess;

@end
