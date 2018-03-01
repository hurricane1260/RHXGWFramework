//
//  BaseDataSource.m
//  stockscontest
//
//  Created by 方海龙 on 15-1-23.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "BaseDataSource.h"
#import "BaseTableCell.h"

@implementation BaseDataSource

@synthesize dataList, delegate, cellHeight, itemViewClassName, cellIndentifier;


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (![self.delegate respondsToSelector:@selector(tableViewDidScroll:)]) {
        return;
    }
    [self.delegate tableViewDidScroll:scrollView];
}

/**
 *  下拉刷新数据
 */
-(void)pullRefreshData{
    if([self.delegate respondsToSelector:@selector(pullRefreshDataHandler)]){
        [self.delegate pullRefreshDataHandler];
    }
}

/**
 *  停止滚动时加载下一页数据
 *
 *  @param scrollView 列表TableView
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(![scrollView isKindOfClass:[UITableView class]]){
        return;
    }
    UITableView *aTableView = (UITableView *)scrollView;
    NSArray *currCells = aTableView.visibleCells;
    if(!currCells || currCells.count == 0){
        return;
    }
    
    UITableViewCell *lastCell = [currCells objectAtIndex:(currCells.count - 1)];
    
    NSIndexPath *indexPath = [aTableView indexPathForCell:lastCell];
    if(indexPath.row != (self.dataList.count - 1)){
        return;
    }
    
    if([self.delegate respondsToSelector:@selector(loadNextPageDataHandler)]){
        [self.delegate loadNextPageDataHandler];
    }
}

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [tableView setLayoutMargins:UIEdgeInsetsMake(0, 10, 10, 0)];
//    }
//    
//    return 1;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.dataList.count > 0) {
        id itemData = [self.dataList objectAtIndex:indexPath.row];
        if([self.delegate respondsToSelector:@selector(tableCellDidSelectedWithData:)]){
            [self.delegate tableCellDidSelectedWithData:itemData];
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = self.dataList.count;
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tablev cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseTableCell *cell = [tablev dequeueReusableCellWithIdentifier:self.cellIndentifier];
    if(!cell){
        cell = [[BaseTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIndentifier];
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, self.cellHeight);
        UIView<ITableCellItemView> *view = [self didBuildItemView];
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

-(UIView<ITableCellItemView> *)didBuildItemView{
    if(self.itemViewClassName.length == 0){
        return nil;
    }
    Class clazz = NSClassFromString(self.itemViewClassName);
    if(!clazz){
        return nil;
    }
    
    id obj = [[clazz alloc] init];
    if(![obj isKindOfClass:[UIView class]]){
        return nil;
    }
    
    UIView *itemView = (UIView *)obj;
    if([itemView conformsToProtocol:@protocol(ITableCellItemView)]){
        UIView<ITableCellItemView> *retView = (UIView<ITableCellItemView> *)itemView;
        return retView;
    }
    return nil;
}

@end
