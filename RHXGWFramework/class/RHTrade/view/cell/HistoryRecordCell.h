//
//  HistoryRecordCell.h
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/27.
//
//历史转账的Cell

#import <UIKit/UIKit.h>

@interface HistoryRecordCell : UITableViewCell

+(NSString *)cellReuseIdentifier;

@property (nonatomic,strong)id  cellData;


@end
