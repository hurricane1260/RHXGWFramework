//
//  MVOpenQuestionDataSource.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/22.
//
//

#import "MVOpenQuestionDataSource.h"
#import "OpenQuestionCell.h"

@interface MVOpenQuestionDataSource ()

kRhPStrong NSNumber * reasonHeight;

kRhPStrong NSMutableArray * indexPathArr;

@end

@implementation MVOpenQuestionDataSource

- (NSMutableDictionary *)indexDic{
    if (!_indexDic) {
        _indexDic = [NSMutableDictionary dictionary];
    }
    return _indexDic;
}

- (NSMutableArray *)indexPathArr{
    if (!_indexPathArr) {
        _indexPathArr = [NSMutableArray array];
    }
    return _indexPathArr;
}

- (UITableViewCell *)tableView:(UITableView *)tablev cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Class class = NSClassFromString(self.itemViewClassName);
    UITableViewCell<ITableCellItemView> *cell = [tablev dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld",indexPath.row]];
//    UITableViewCell<ITableCellItemView> *cell = [tablev dequeueReusableCellWithIdentifier:self.cellIndentifier];

    if(!cell){
        cell = [[class alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%ld",indexPath.row]];
//        cell = [[class alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIndentifier];

        __weak typeof (self) welf = self;
        if ([cell isKindOfClass:[OpenQuestionCell class]]) {
            OpenQuestionCell * quesCell = cell;
            quesCell.showCallBack = ^(NSDictionary * param){
                if ([param objectForKey:@"height"] && [param objectForKey:@"row"]) {
                    welf.reasonHeight = [param objectForKey:@"height"];
                    NSString * row = [[param objectForKey:@"row"] stringValue];

                        [welf.indexDic setObject:welf.reasonHeight forKey:row];
//                    [welf tableView:tablev heightForRowAtIndexPath:indexPath];
                    if (self.reloadCallBack) {
                        self.reloadCallBack();
                    }
//                    [tablev reloadRowsAtIndexPaths:self.indexPathArr withRowAnimation:UITableViewRowAnimationNone];
//                    }
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    if ([self.indexDic objectForKey:[NSString stringWithFormat:@"%ld",(indexPath.row )]]) {
        NSNumber * height = [self.indexDic objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row ]];
        NSLog(@"----------------第%ld项 高度 %@",indexPath.row,height);
        return [height floatValue];
    }

    NSLog(@"----------------第%ld项 高度 %f",indexPath.row,self.cellHeight);
    [self.indexDic setObject:[NSNumber numberWithFloat:self.cellHeight] forKey:[NSString stringWithFormat:@"%ld",indexPath.row ]];
    return self.cellHeight;
    
}
@end
