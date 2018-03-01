//
//  ResultMessageVO.m
//  stockscontest
//
//  Created by 方海龙 on 15-1-13.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "ResultMessageVO.h"

@implementation ResultMessageVO

+(ResultMessageVO *)parseData:(id)data{
    if(!data){
        return nil;
    }
    
    id messObj = [data valueForKey:@"message"];
    if(!messObj){
        return nil;
    }
    
    ResultMessageVO *messageVO = [[ResultMessageVO alloc] init];
    NSNumber *codeNumber = [messObj valueForKey:@"code"];
    messageVO.code = [codeNumber integerValue];
    messageVO.message = [messObj valueForKey:@"message"];
    return messageVO;
}

+(ResultMessageVO *)buildMessageVOWithMessage:(NSString *)aMess{
    ResultMessageVO *messageVO = [[ResultMessageVO alloc] init];
    messageVO.code = -404;
    messageVO.message = aMess;
    return messageVO;
}


@end
