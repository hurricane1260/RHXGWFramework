//
//  STKRequestContext.h
//  iphone-stock
//
//  Created by ztian on 14-2-25.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STKCallbackInfo.h"
#import "STKData.h"

@interface STKRequestContext : STKCallbackInfo

@property (nonatomic,retain) STKData *request;

- (id)initWithTarget:(id)target resultHandler:(SEL)resultHandler failHandler:(SEL)failHandler request:(STKData *)request;


@end
