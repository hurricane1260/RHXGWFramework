//
//  PrefecturePictureVO.h
//  stockscontest
//
//  Created by Zzbei on 15/12/8.
//  Copyright © 2015年 方海龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrefecturePictureVO : NSObject

@property (nonatomic,assign) NSInteger carousel;

@property (nonatomic,assign) NSInteger ord;

@property (nonatomic,copy) NSString * imgPath;

@property (nonatomic,copy) NSString * type;

@property (nonatomic,copy) NSString * linkUrl;

@property (nonatomic,copy) NSString * title;

+ (id)pictureWithDict:(NSDictionary *)dict;
- (id)initWithDict:(NSDictionary *)dict;

@end
