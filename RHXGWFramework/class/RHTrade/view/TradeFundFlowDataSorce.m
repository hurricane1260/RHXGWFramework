//
//  TradeFundFlowDataSorce.m
//  stockscontest
//
//  Created by rxhui on 15/7/14.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "TradeFundFlowDataSorce.h"
#import "TradeFundFlowListItemView.h"
#import "BaseTableCell.h"
#import "TransferHistoryListVO.h"
#import "TransferFlowListVO.h"

@interface TradeFundFlowDataSorce ()

kRhPStrong NSIndexPath * selectIndexPath;

kRhPAssign CGFloat reasonHeight;

kRhPStrong NSMutableDictionary * tagDic;
@end

@implementation TradeFundFlowDataSorce

- (instancetype)init{
    if (self = [super init]) {
        self.tagDic = [NSMutableDictionary dictionary];
    }
    return self;
}

-(UITableViewCell *)tableView:(UITableView *)tablev cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BaseTableCell *cell = [tablev dequeueReusableCellWithIdentifier:self.cellIndentifier];
    if(!cell){
        cell = [[BaseTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIndentifier];
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, self.cellHeight);
        UIView<ITableCellItemView> *view = [self didBuildItemView];
        
        __weak typeof(self) welf = self;
        if ([view isKindOfClass:[TradeFundFlowListItemView class]]) {
            TradeFundFlowListItemView * tradeView = view;
            tradeView.showCallBack = ^(NSDictionary * param){
                NSNumber * height = [param objectForKey:@"height"];
                [welf.tagDic setObject:height forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            };
        }
        
        if(view){
            cell.itemView = view;
        }
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 320-keyAppWindow.width)];//否则6和6plus右边会空出一片
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    
    UIView<ITableCellItemView> *itemView = cell.itemView;
    if(itemView){
        if (self.dataList.count > 0) {
            id itemData = [self.dataList objectAtIndex:indexPath.row];
            itemView.itemData = itemData;
            
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat rHeight = [[self.tagDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] floatValue];
    return self.cellHeight + rHeight;
    ;
}

@end
