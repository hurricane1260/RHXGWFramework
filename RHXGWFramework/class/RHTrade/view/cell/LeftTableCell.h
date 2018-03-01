//
//  LeftTableCell.h
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/20.
//
//

#import <UIKit/UIKit.h>

@interface LeftTableCell : UITableViewCell

@property (nonatomic, strong) id cellData;


@property (nonatomic, assign) TradeControllerType viewType;

+(NSString *)reuseIdentifier;

@end
