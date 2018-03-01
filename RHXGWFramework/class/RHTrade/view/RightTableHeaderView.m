//
//  RightTableHeaderView.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/19.
//
//

#import "RightTableHeaderView.h"
@interface RightTableHeaderView ()
@property (nonatomic, strong) NSMutableArray *titleLabelList;
@property (nonatomic, assign) NSInteger width;

@end
@implementation RightTableHeaderView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleLabelList = [NSMutableArray array];
        [self initSubviews];
    }
    return self;
}
-(void)initSubviews{
    
    [self addAutoLineWithColor:color16_other_xgw];
}
- (void)setTitleList:(NSArray *)aList {
    if (_titleList) {
        _titleList = nil;
    }
    _titleList = aList.copy;
    [self initLabels];
    [self setNeedsLayout];
}

-(void)initLabels{
    
    if (self.titleLabelList.count > 0) {
        [self.titleLabelList removeAllObjects];
    }
    for (NSString *title in _titleList) {
     
        UILabel *titleLabel = [UILabel didBuildLabelWithText:title font:font1_common_xgw textColor:color2_text_xgw wordWrap:NO];
        titleLabel.textAlignment = NSTextAlignmentRight;
        [self.titleLabelList addObject:titleLabel];
        [self addSubview:titleLabel];
    }
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (int i = 0; i < self.titleLabelList.count; i++) {
        UILabel * label = self.titleLabelList[i];
        
        if ([label.text isEqualToString:@"备注"]) {
            label.size = CGSizeMake(120, self.size.height);
        }else{
            label.size = CGSizeMake(90, self.size.height);
 
        }
        label.origin = CGPointMake(i*90, 0);
        
        if (i==self.titleLabelList.count-1) {
            //最后一项的时候记录一下
            self.width = CGRectGetMaxX(label.frame)+24;
        }
    }
    
    self.autoLine.frame = CGRectMake(0, self.size.height-1, self.size.width, 1);

}
- (NSInteger)getCurrentWidth{
    
    return self.width;
}


@end
