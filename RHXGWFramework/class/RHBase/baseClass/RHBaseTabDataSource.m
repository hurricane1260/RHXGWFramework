
//  RHBaseTabDataSource.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/10/12.
//
//

#import "RHBaseTabDataSource.h"
#import "TradeIPOWeekTableViewCell.h"
//#import "MNGroupPositionCell.h"

@interface RHBaseTabDataSource ()//TradeIPOWeekTableViewCellDelegate

kRhPAssign CGFloat reasonHeight;

@end

@implementation RHBaseTabDataSource

@synthesize headerHeight = _headerHeight, itemheaderViewName = _itemheaderViewName,headerList = _headerList,headerIndentifier = _headerIndentifier;

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell  forRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (self.dataList.count == 0) {
    //        return;
    //    }
    //    if (![cell conformsToProtocol:@protocol(ITableCellItemView)] ) {
    //        return;
    //    }
    //    UITableViewCell<ITableCellItemView> * retCell = (UITableViewCell<ITableCellItemView> *)cell;
    //    retCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //    if ([retCell respondsToSelector:@selector(loadDataWithModel:)]) {
    //        id model = self.dataList[indexPath.section][indexPath.row];
    //        [retCell loadDataWithModel:model];
    //    }
    
    
    //group
    if (self.dataList.count == 0) {
        return;
    }
    if (![cell conformsToProtocol:@protocol(ITableCellItemView)] ) {
        return;
    }
    UITableViewCell<ITableCellItemView> * retCell = (UITableViewCell<ITableCellItemView> *)cell;
    if ([retCell isKindOfClass:[NSClassFromString(@"MNSetCell") class]]) {
        retCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if ([retCell respondsToSelector:@selector(loadDataWithModel:)]) {
        id model;
        if (self.style == UITableViewStylePlain) {
            model = self.dataList[indexPath.row];
        }
        else{
            model = self.dataList[indexPath.section][indexPath.row];
        }
        [retCell loadDataWithModel:model];
        return;
    }
    if ([retCell respondsToSelector:@selector(loadDataWithModel:withIndexPath:)]) {
        id model;
        if (self.style == UITableViewStylePlain) {
            model = self.dataList[indexPath.row];
            [retCell loadDataWithModel:model withIndexPath:indexPath.row];
        }
        else{
            model = self.dataList[indexPath.section][indexPath.row];
            [retCell loadDataWithModel:model withIndexPath:0];
        }
        return;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.dataList.count > 0) {
        id itemData;
        if (self.style == UITableViewStylePlain) {
            itemData = self.dataList[indexPath.row];
        }
        else{
           itemData = self.dataList[indexPath.section][indexPath.row];
        }
        if([self.delegate respondsToSelector:@selector(tableCellDidSelectedWithData:)]){
            [self.delegate tableCellDidSelectedWithData:itemData];
        }
        if ([self.delegate respondsToSelector:@selector(tableCellDidSelectedWithIndexPath:)]) {
            [self.delegate tableCellDidSelectedWithIndexPath:indexPath];
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    NSInteger count = [self.dataList[section] count];
    //    return count;
    
    //group
    NSInteger count;
    if (self.style == UITableViewStylePlain) {
        count = [self.dataList count];
    }
    else{
        count = [(NSArray *)self.dataList[section] count];
    }
    return count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //    return self.dataList.count;
    
    //group
    if (self.style == UITableViewStylePlain) {
        return 1;
    }
    else{
        return self.dataList.count;
    }
    //    return _headerList.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return self.cellGap;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    //       return  0.01;
    
    //group
    if (_headerHeight == 0) {
        return  0.01;
    }
    else{
        return _headerHeight;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tablev cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Class class = NSClassFromString(self.itemViewClassName);
    UITableViewCell<ITableCellItemView> *cell = [tablev dequeueReusableCellWithIdentifier:self.cellIndentifier];
    
    if(!cell){
        cell = [[class alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIndentifier];
//        __weak typeof (self) welf = self;
//        if ([cell isKindOfClass:[MNGroupPositionCell class]]) {
//            MNGroupPositionCell * positionCell = cell;
//            positionCell.showCallBack = ^(NSDictionary * param){
//                if ([param objectForKey:@"height"]) {
//                    if (self.selectIndexPath) {
//                        MNGroupPositionCell * preCell = [tablev cellForRowAtIndexPath:welf.selectIndexPath];
//                        preCell.isShow = NO;
//                    }
//                    self.reasonHeight = [[param objectForKey:@"height"] floatValue];
//                    self.selectIndexPath = indexPath;
//                    [tablev reloadData];
//                }
//            };
//        }
        
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, self.cellHeight);
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
//    if ([cell isKindOfClass:[TradeIPOWeekTableViewCell class]]) {
//        TradeIPOWeekTableViewCell * item = (TradeIPOWeekTableViewCell *)cell;
//        item.delegate = self;
//    
//    }
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!self.headerHeight) {
        return nil;
    }
    
    //    if (self.style == UITableViewStyleGrouped) {
    Class class = NSClassFromString(self.itemheaderViewName);
    UITableViewHeaderFooterView<ITableHeaderItemView> * headerView = [tableView dequeueReusableCellWithIdentifier:self.headerIndentifier];
    if (!headerView) {
        headerView = [[class alloc] initWithReuseIdentifier:self.headerIndentifier];
        headerView.frame = CGRectMake(0, 0, MAIN_SCREEN_WIDTH, _headerHeight);
        
    }
//    if (self.headerList.count) {
//        if (![headerView conformsToProtocol:@protocol(ITableHeaderItemView)] ) {
//            return headerView;
//        }
//        if ([headerView respondsToSelector:@selector(setHeaderData:)]) {
//            if (self.style == UITableViewStyleGrouped) {
//                id model = self.headerList[section];
//                //                    if ([model isKindOfClass:[NSArray class]]) {
//                //                        model = model[0];
//                //                    }
//                headerView.headerData = model;
//            }
//            else if (self.style == UITableViewStylePlain){
//                id model = self.headerList[section];
//                headerView.headerData = model;
//            }
//        }
//    }
    return headerView;
    //    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *) view forSection:(NSInteger)section{
    UITableViewHeaderFooterView<ITableHeaderItemView> * headerView = view;

    if (self.headerList.count) {
        if (![headerView conformsToProtocol:@protocol(ITableHeaderItemView)] ) {
            return;
        }
        if ([headerView respondsToSelector:@selector(setHeaderData:)]) {
            if (self.style == UITableViewStyleGrouped) {
                if (section >= self.headerList.count) {
                    return;
                }
                id model = self.headerList[section];
                headerView.headerData = model;
            }
            else if (self.style == UITableViewStylePlain){
                id model = self.headerList[section];
                headerView.headerData = model;
            }
        }
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.selectIndexPath == indexPath) {
        return self.cellHeight + self.reasonHeight;
    }
    return self.cellHeight;
    
}
@end
