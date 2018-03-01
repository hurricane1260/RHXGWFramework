//
//  STKCallbackInfo.h
//  iphone-stock
//
//  Created by ztian on 14-2-28.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STKCallbackInfo : NSObject

@property (nonatomic,retain) id target;
@property (nonatomic,assign) SEL resultHandler;
@property (nonatomic,assign) SEL failHandler;

- (id)initWithTarget:(id)target resultHandler:(SEL)resultHandler failHandler:(SEL)failHandler;

- (void)performResultHandlerWithObject:(id)object;

- (void)performFailHandlerWithObject:(id)object;

- (void)performResultHandler;

- (void)performFailHandler;

@end
