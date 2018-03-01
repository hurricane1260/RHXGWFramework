//
//  RHDataSource.m
//  TZYJ_IPhone
//
//  Created by liyan on 16/4/27.
//
//

#import "RHDataSource.h"
#import "RHPushMessageVO.h"
#import "BaseTableCell.h"

@implementation RHDataSource

@synthesize dataList = _dataList, delegate, cellHeight, itemViewClassName, cellIndentifier,cellGap;

-(void)setDataList:(NSArray *)dataList{
    if (_dataList) {
        _dataList = nil;
    }
    _dataList = dataList;
}

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
    
//    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//    return cell.frame.size.height;
    if ([self.itemViewClassName isEqualToString:@"RHSysTableViewCell"]) {
        RHPushMessageVO * vo = self.dataList[indexPath.row];
        NSString * str = vo.contentTitle;
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font3_common_xgw,NSFontAttributeName, nil];
        CGSize size = [str boundingRectWithSize:CGSizeMake(keyAppWindow.width - 20.0f, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        return 49.0f + size.height;

    }
    else{
        return self.cellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0f;
    return self.cellGap;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.0f;
    }
    else{
        return 1.0f;
    }
    return 0.0f;
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
    NSInteger count = [self.dataList count];
    return count;
//    return 5;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return self.dataList.count;
//}

-(UITableViewCell *)tableView:(UITableView *)tablev cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Class class = NSClassFromString(self.itemViewClassName);
    UITableViewCell<ITableCellItemView> *cell = [tablev dequeueReusableCellWithIdentifier:self.cellIndentifier];
    if(!cell){
        cell = [[class alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIndentifier];
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, self.cellHeight);
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataList.count == 0) {
        return;
    }
    if (![cell conformsToProtocol:@protocol(ITableCellItemView)] ) {
        return;
    }
    UITableViewCell<ITableCellItemView> * retCell = (UITableViewCell<ITableCellItemView> *)cell;
    if ([retCell respondsToSelector:@selector(loadDataWithModel:)]) {
        id model = self.dataList[indexPath.row];
        [retCell loadDataWithModel:model];
    }
    
}

//-(UIView<ITableCellItemView> *)didBuildItemView{
//    if(self.itemViewClassName.length == 0){
//        return nil;
//    }
//    Class clazz = NSClassFromString(self.itemViewClassName);
//    if(!clazz){
//        return nil;
//    }
//    
//    id obj = [[clazz alloc] init];
//    if(![obj isKindOfClass:[UIView class]]){
//        return nil;
//    }
//    
//    UIView *itemView = (UIView *)obj;
//    if([itemView conformsToProtocol:@protocol(ITableCellItemView)]){
//        UIView<ITableCellItemView> *retView = (UIView<ITableCellItemView> *)itemView;
//        return retView;
//    }
//    return nil;
//}

@end
