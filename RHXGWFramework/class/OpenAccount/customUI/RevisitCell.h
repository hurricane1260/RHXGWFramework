//
//  RevisitCell.h
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/11.
//
//

#import <UIKit/UIKit.h>

@interface RevisitCell : UITableViewCell
kRhPCopy ButtonCallBackWithParams warnBlock;

- (void)loadDataWithModel:(id)model withIndexPath:(NSInteger)row;
@end
