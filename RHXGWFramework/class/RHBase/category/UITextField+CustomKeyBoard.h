//
//  UITextField+CustomKeyBoard.h
//  stockscontest
//
//  Created by Zzbei on 16/3/8.
//  Copyright © 2016年 方海龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomKeyBoardDelegate <NSObject>

- (void)getKeyBoardString:(NSString *)string;

@end

@interface UITextField (CustomKeyBoard)

@property (nonatomic,strong) NSArray * numArr;
@property (nonatomic,strong) NSArray * engArr;
@property (nonatomic,strong) UIView * numberBoard;
@property (nonatomic,strong) UIView * englishBoard;
@property (nonatomic,weak) id<CustomKeyBoardDelegate>keyBoardDelegate;

- (void)createCustomKeyBoard;

@end
