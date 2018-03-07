//
//  BankListDataSource.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/8/8.
//
//

#import "BankListDataSource.h"
#import "CRHBankListTableViewCell.h"

@interface BankListDataSource ()

kRhPStrong NSNumber * reasonHeight;

@end

@implementation BankListDataSource

- (NSMutableDictionary *)indexDic{
    if (!_indexDic) {
        _indexDic = [NSMutableDictionary dictionary];
    }
    return _indexDic;
}


- (UITableViewCell *)tableView:(UITableView *)tablev cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Class class = NSClassFromString(self.itemViewClassName);
        UITableViewCell<ITableCellItemView> *cell = [tablev dequeueReusableCellWithIdentifier:self.cellIndentifier];

    if(!cell){
        cell = [[class alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIndentifier];
        NSLog(@"----------返回的cell------------");
        __weak typeof (self) welf = self;
        if ([cell isKindOfClass:[CRHBankListTableViewCell class]]) {
            CRHBankListTableViewCell * bCell = cell;
            bCell.heightCallBack = ^(NSDictionary * param){
                if ([param objectForKey:@"height"]) {
                    welf.selectIndexPath = indexPath;
                    welf.reasonHeight = [param objectForKey:@"height"];
                    [tablev reloadData];

                }
            };
        }
        
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"----------返回的cell的高------------");

    if ([indexPath isEqual:self.selectIndexPath]) {
        return [self.reasonHeight floatValue];
    }
    return self.cellHeight;
    
}
@end
