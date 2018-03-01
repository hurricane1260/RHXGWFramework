//
//  TradeInfoController.m
//  stockscontest
//
//  Created by rxhui on 16/2/1.
//  Copyright © 2016年 方海龙. All rights reserved.
//

#import "TradeInfoController.h"

@interface TradeInfoController ()

@property (nonatomic, strong) UITextView *contentTextView;

@end

@implementation TradeInfoController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _contentTextView = [[UITextView alloc]init];
        [self.view addSubview:_contentTextView];
        _contentTextView.editable = NO;
        _contentTextView.backgroundColor = color1_text_xgw;
        _contentTextView.textColor = color2_text_xgw;
        
    }
    return self;
}

- (void)setContentString:(NSString *)aString {
    if (_contentString) {
        _contentString = nil;
    }
    _contentString = aString.copy;
    self.contentTextView.text = _contentString;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _contentTextView.frame = CGRectMake(0, self.layoutStartY, self.view.width, self.view.height - self.layoutStartY);
}

@end
