//
//  BaseTableCell.m
//  stockscontest
//
//  Created by 方海龙 on 15-1-23.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "BaseTableCell.h"

@implementation BaseTableCell

@synthesize itemView = _itemView;

-(void)setItemView:(UIView<ITableCellItemView> *)aView{
    if(_itemView != aView){
        [_itemView removeFromSuperview];
        _itemView = aView;
        if(_itemView){
            [self.contentView addSubview:_itemView];
            [self setNeedsLayout];
        }
    }
}

-(void)layoutSubviews{
    self.contentView.frame = self.bounds;
    _itemView.frame = self.bounds;
}

@end
